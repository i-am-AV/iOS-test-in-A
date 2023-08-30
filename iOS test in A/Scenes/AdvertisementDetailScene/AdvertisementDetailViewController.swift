//
//  AdvertisementDetailViewController.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import UIKit

final class AdvertisementDetailViewController: UIViewController, AdvertisementDetailDisplayLogic {
    // MARK: - Private properties
    private let interactor: AdvertisementDetailBusinessLogic
    private let router: AdvertisementDetailRoutingLogic

    // MARK: - Nested types
    private enum Constants {
        static let spacing: CGFloat = 8.0
        static let stackSpacing: CGFloat = 2.0
        static let actionTitle: String = "Закрыть"
        enum Fonts {
            static let priceFont: UIFont = .systemFont(ofSize: 32.0, weight: .bold)
            static let titleFont: UIFont = .systemFont(ofSize: 24.0, weight: .medium)
            static let descriptionFont: UIFont = .systemFont(ofSize: 20.0, weight: .medium)
            static let emailFont: UIFont = .systemFont(ofSize: 16.0, weight: .light)
            static let phoneNumberFont: UIFont = .systemFont(ofSize: 16.0, weight: .light)
            static let addressNumberFont: UIFont = .systemFont(ofSize: 16.0, weight: .light)
            static let locationFont: UIFont = .systemFont(ofSize: 14.0, weight: .regular)
            static let createdDateFont: UIFont = .systemFont(ofSize: 14.0, weight: .regular)
        }
    }

    // MARK: - Private UI properties
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large).prepareForAutoLayout()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let priceLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.priceFont
        label.textAlignment = .right
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView().prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = Constants.stackSpacing
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.titleFont
        label.numberOfLines = .zero
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.descriptionFont
        label.numberOfLines = .zero
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.emailFont
        return label
    }()

    private let phoneNumberLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.phoneNumberFont
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.addressNumberFont
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.locationFont
        label.textColor = .lightGray
        label.numberOfLines = .zero
        return label
    }()

    private let createdDateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.createdDateFont
        label.textColor = .lightGray
        return label
    }()

    // MARK: - Initialization
    init(
        interactor: AdvertisementDetailBusinessLogic,
        router: AdvertisementDetailRoutingLogic
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
        configureView()
        activityIndicator.startAnimating()
        interactor.requestInitForm(AdvertisementDetailScene.InitForm.Request())
    }

    // MARK: - AdvertisementDetailDisplayLogic
    func displayInitForm(_ viewModel: AdvertisementDetailScene.InitForm.ViewModel) {
        let model: AdvertisementDetailScene.Model = viewModel.model
        priceLabel.text = model.price
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        emailLabel.text = model.email
        phoneNumberLabel.text = model.phoneNumber
        addressLabel.text = model.address
        locationLabel.text = model.location
        createdDateLabel.text = model.createdDate
        interactor.requestImage(AdvertisementDetailScene.Image.Request())
    }

    func displayImage(_ viewModel: AdvertisementDetailScene.Image.ViewModel) {
        activityIndicator.stopAnimating()
        imageView.image = UIImage(data: viewModel.data)
    }

    func displayErrorAlert(_ viewModel: AdvertisementDetailScene.ErrorAlert.ViewModel) {
        createErrorAlert(with: viewModel.text)
    }

    // MARK: - Private methods
    private func configureView() {
        view.backgroundColor = .systemBackground
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        view.addSubview(imageView)
        imageView.addSubview(activityIndicator)
        view.addSubview(priceLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(phoneNumberLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(createdDateLabel)
        view.addSubview(stackView)
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -Constants.spacing),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.spacing),
            stackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.spacing),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.spacing),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func createErrorAlert(with text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Constants.actionTitle, style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
