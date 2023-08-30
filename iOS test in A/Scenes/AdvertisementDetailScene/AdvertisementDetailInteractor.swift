//
//  AdvertisementDetailInteractor.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation

final class AdvertisementDetailInteractor: AdvertisementDetailBusinessLogic, AdvertisementDetailDataStore {
    private let presenter: AdvertisementDetailPresentationLogic
    private let networkManager: NetworkManagerProtocol
    private let identifier: String

    private var urlString: String?

    // MARK: - Initilization
    init(
        presenter: AdvertisementDetailPresentationLogic,
        networkManager: NetworkManagerProtocol,
        identifier: String
    ) {
        self.presenter = presenter
        self.networkManager = networkManager
        self.identifier = identifier
    }

    // MARK: - AdvertisementDetailBusinessLogic
    func requestInitForm(_ request: AdvertisementDetailScene.InitForm.Request) {
        networkManager.fetchDetailAdvertisement(by: identifier) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.urlString = model.imageURL
                DispatchQueue.main.async {
                    self.presenter.presentInitForm(AdvertisementDetailScene.InitForm.Response(model: model))
                }
            case .failure(let error):
                presentErrorAlert(with: error.localizedDescription)
            }
        }
    }

    func requestImage(_ request: AdvertisementDetailScene.Image.Request) {
        guard let urlString: String = urlString else { return }
        networkManager.fetchImage(by: urlString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.presenter.presentImage(AdvertisementDetailScene.Image.Response(data: data))
                }
            case .failure(let error):
                presentErrorAlert(with: error.localizedDescription)
            }
        }
    }

    // MARK: - Private methods
    private func presentErrorAlert(with text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.presentErrorAlert(AdvertisementDetailScene.ErrorAlert.Response(text: text))
        }
    }
}
