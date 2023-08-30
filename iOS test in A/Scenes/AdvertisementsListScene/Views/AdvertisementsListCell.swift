//
//  AdvertisementsListCell.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import UIKit

final class AdvertisementsListCell: UICollectionViewCell {
    // MARK: - Model
    public struct Model {
        let image: UIImage?
        let title: String
        let price: String
        let location: String
        let createdDate: String
        let needsHideIndicator: Bool

        public init(
            image: UIImage?,
            title: String,
            price: String,
            location: String,
            createdDate: String,
            needsHideIndicator: Bool
        ) {
            self.image = image
            self.title = title
            self.price = price
            self.location = location
            self.createdDate = createdDate
            self.needsHideIndicator = needsHideIndicator
        }
    }

    public var model: Model? { didSet { updateModel() } }

    // MARK: - Static Public Propeties
    static public var reuseIdentifier: String { String(describing: self) }

    // MARK: - Nested types
    private enum Constants {
        enum ImageView {
            static let cornerRadius: CGFloat = 6.0
        }
        enum Fonts {
            static let titleFont: UIFont = .systemFont(ofSize: 16.0, weight: .regular)
            static let priceFont: UIFont = .systemFont(ofSize: 16.0, weight: .medium)
            static let locationFont: UIFont = .systemFont(ofSize: 12.0, weight: .medium)
            static let createdDateFont: UIFont = .systemFont(ofSize: 12.0, weight: .regular)
        }
        enum Spacings {
            static let large: CGFloat = 6.0
            static let small: CGFloat = 2.0
        }
    }

    // MARK: - Private UI properties
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium).prepareForAutoLayout()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView().prepareForAutoLayout()
        imageView.layer.cornerRadius = Constants.ImageView.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.cornerCurve = .continuous

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.titleFont
        label.numberOfLines = .zero
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.priceFont
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.locationFont
        label.textColor = .darkGray
        label.numberOfLines = .zero
        return label
    }()

    private let createdDateLabel: UILabel = {
        let label = UILabel().prepareForAutoLayout()
        label.font = Constants.Fonts.createdDateFont
        label.textColor = .darkGray
        return label
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        activityIndicator.startAnimating()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }

    // MARK: - Private methods
    private func updateModel() {
        activityIndicator.startAnimating()
        guard let model = model else {
            imageView.image = nil
            return
        }
        if let image: UIImage = model.image {
            activityIndicator.stopAnimating()
            imageView.image = image
        } else if model.needsHideIndicator {
            activityIndicator.stopAnimating()
            imageView.backgroundColor = .systemGroupedBackground
        }
        titleLabel.text = model.title
        priceLabel.text = model.price
        locationLabel.text = model.location
        createdDateLabel.text = model.createdDate
    }

    private func configureView() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(imageView)
        addSubview(activityIndicator)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(locationLabel)
        addSubview(createdDateLabel)
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.Spacings.large),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Spacings.small),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.Spacings.small),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            createdDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            createdDateLabel.topAnchor.constraint(
                equalTo: locationLabel.bottomAnchor,
                constant: Constants.Spacings.small
            ),
            createdDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            createdDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Spacings.large)
        ])
    }
}
