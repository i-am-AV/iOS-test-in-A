//
//  AdvertisementsListViewController.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import UIKit

final class AdvertisementsListViewController: UIViewController,
                                              AdvertisementsListDisplayLogic,
                                              UICollectionViewDelegateFlowLayout {
    // MARK: - Private typealias
    private typealias DataSource = UICollectionViewDiffableDataSource<
        AdvertisementsListScene.Sections, AdvertisementsListScene.Model
    >
    private typealias Snapshot = NSDiffableDataSourceSnapshot<
        AdvertisementsListScene.Sections, AdvertisementsListScene.Model
    >

    // MARK: - Nested types
    private enum Constants {
        static let title: String = "Объявления"
        static let actionTitle: String = "Закрыть"
        static let delay: TimeInterval = 2
    }

    // MARK: - Private properties
    private let interactor: AdvertisementsListBusinessLogic
    private let router: AdvertisementsListRoutingLogic

    private var needsHideIndicator: Bool = false
    private var needsStartFetching: Bool = false

    // MARK: - Private UI properties
    private lazy var collectionViewLayout: UICollectionViewCompositionalLayout = {
        UICollectionViewCompositionalLayout { [weak self] (_, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return AdvertisementsListCompositionalLayout.gridSectionLayout(environment: environment)
        }
    }()

    private lazy var dataSource: DataSource = DataSource(
        collectionView: collectionView
    ) { [weak self] collectionView, indexPath, itemIdentifier in
        guard
            let self = self,
            let section = AdvertisementsListScene.Sections(rawValue: indexPath.section)
        else { return UICollectionViewCell() }
        switch section {
        case .gridSection:
            let cell: UICollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AdvertisementsListCell.reuseIdentifier,
                for: indexPath
            )
            guard let advertisementsListCell = cell as? AdvertisementsListCell else { return cell }
            advertisementsListCell.model = AdvertisementsListCell.Model(
                image: UIImage(data: itemIdentifier.imageData ?? Data()),
                title: itemIdentifier.title,
                price: itemIdentifier.price,
                location: itemIdentifier.location,
                createdDate: itemIdentifier.createdDate,
                needsHideIndicator: self.needsHideIndicator
            )
            return advertisementsListCell
        }
    }

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl().prepareForAutoLayout()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refreshControl
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.collectionViewLayout
        ).prepareForAutoLayout()
        let imageView = UIImageView(
            image: UIImage(named: "network-error")
        ).prepareForAutoLayout()
        imageView.contentMode = .scaleAspectFit
        collectionView.backgroundView = imageView
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.register(
            AdvertisementsListCell.self,
            forCellWithReuseIdentifier: AdvertisementsListCell.reuseIdentifier
        )

        return collectionView
    }()

    // MARK: - Initialization
    init(
        interactor: AdvertisementsListBusinessLogic,
        router: AdvertisementsListRoutingLogic
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
        configureView()
        interactor.requestInitForm(AdvertisementsListScene.InitForm.Request())
    }

    // MARK: - AdvertisementsListDisplayLogic
    func displayInitForm(_ viewModel: AdvertisementsListScene.InitForm.ViewModel) {
        collectionView.backgroundView = nil
        needsStartFetching = false
        var snapshot: Snapshot = Snapshot()
        snapshot.appendSections([.gridSection])
        snapshot.appendItems(viewModel.advertisementsList, toSection: .gridSection)
        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let count: Int = self?.collectionView.visibleCells.count else { return }
            self?.interactor.requestLoadVisibleImages(
                AdvertisementsListScene.LoadVisibleImages.Request(lastIndex: count)
            )
        }
    }

    func displayLoadVisibleImages(_ viewModel: AdvertisementsListScene.LoadVisibleImages.ViewModel) {
        var snapshot: Snapshot = Snapshot()
        snapshot.appendSections([.gridSection])
        snapshot.appendItems(viewModel.model, toSection: .gridSection)
        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.collectionView.reloadData()
            self?.interactor.requestImages(AdvertisementsListScene.Images.Request())
        }
    }

    func displayImages(_ viewModel: AdvertisementsListScene.Images.ViewModel) {
        var snapshot: Snapshot = Snapshot()
        snapshot.appendSections([.gridSection])
        snapshot.appendItems(viewModel.model, toSection: .gridSection)
        dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    func displaySelectedAdvertisement(_ viewModel: AdvertisementsListScene.SelectedAdvertisement.ViewModel) {
        router.routeToDetails()
    }

    func displayErrorAlert(_ viewModel: AdvertisementsListScene.ErrorAlert.ViewModel) {
        needsHideIndicator = true
        needsStartFetching = true
        collectionView.reloadData()
        createErrorAlert(with: viewModel.text)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let sections = AdvertisementsListScene.Sections(rawValue: indexPath.section)
        else { return }
        switch sections {
        case .gridSection:
            interactor.requestSelectedAdvertisement(
                AdvertisementsListScene.SelectedAdvertisement.Request(index: indexPath.item)
            )
        }
    }

    // MARK: - Actions
    @objc private func refreshAction(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        needsHideIndicator = false
        guard needsStartFetching else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delay) {
            self.interactor.requestInitForm(AdvertisementsListScene.InitForm.Request())
        }
    }

    // MARK: - Private methods
    private func configureView() {
        view.backgroundColor = .systemBackground
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        view.addSubview(collectionView)
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func createErrorAlert(with text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Constants.actionTitle, style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
