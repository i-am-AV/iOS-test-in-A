//
//  AdvertisementsListInteractor.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation

final class AdvertisementsListInteractor: AdvertisementsListBusinessLogic, AdvertisementsListDataStore {
    // MARK: - Private properties
    private let presenter: AdvertisementsListPresentationLogic
    private let networkManager: NetworkManagerProtocol

    private var imagesUrlStringsDict: [String: String] = [:]
    private var advertisementsList: [AdvertisementsListScene.Model] = []

    // MARK: - AdvertisementsListDataStore
    private(set) var identifier: String = ""

    // MARK: - Initilization
    init(
        presenter: AdvertisementsListPresentationLogic,
        networkManager: NetworkManagerProtocol
    ) {
        self.presenter = presenter
        self.networkManager = networkManager
    }

    // MARK: - AdvertisementsListBusinessLogic
    func requestInitForm(_ request: AdvertisementsListScene.InitForm.Request) {
        networkManager.fetchAdvertisements { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.fillImagesUrlStringsDict(list.advertisements)
                self.advertisementsList = self.mapToAdvertisementsListModel(list.advertisements)
                DispatchQueue.main.async {
                    self.presenter.presentInitForm(
                        AdvertisementsListScene.InitForm.Response(
                            advertisementsList: self.advertisementsList
                        )
                    )
                }
            case .failure(let error):
                presentErrorAlert(with: error.localizedDescription)
            }
        }
    }

    func requestLoadVisibleImages(_ request: AdvertisementsListScene.LoadVisibleImages.Request) {
        let visibleItems = self.advertisementsList.prefix(request.lastIndex)
        let group = DispatchGroup()
        for item in visibleItems {
            group.enter()
            self.networkManager.fetchImage(by: imagesUrlStringsDict[item.id]!) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    guard
                        let index = self.advertisementsList.firstIndex(where: { $0.id == item.id }),
                        !self.advertisementsList.isEmpty
                    else { return }
                    self.advertisementsList[index].imageData = data
                    group.leave()
                case .failure(let error):
                    presentErrorAlert(with: error.localizedDescription)
                }
            }
        }
        group.notify(queue: .main) {
            self.presenter.presentLoadVisibleImages(
                AdvertisementsListScene.LoadVisibleImages.Response(
                    model: self.advertisementsList
                )
            )
        }
    }
    func requestImages(_ request: AdvertisementsListScene.Images.Request) {
        let group = DispatchGroup()
        for (id, urlString) in imagesUrlStringsDict {
            group.enter()
            self.networkManager.fetchImage(by: urlString) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    guard
                        let index = self.advertisementsList.firstIndex(where: { $0.id == id }),
                        !self.advertisementsList.isEmpty
                    else { return }
                    self.advertisementsList[index].imageData = data
                    group.leave()
                case .failure(let error):
                    presentErrorAlert(with: error.localizedDescription)
                }
            }
        }
        group.notify(queue: .main) {
            self.presenter.presentImages(
                AdvertisementsListScene.Images.Response(
                    model: self.advertisementsList
                )
            )
        }
    }

    func requestSelectedAdvertisement(_ request: AdvertisementsListScene.SelectedAdvertisement.Request) {
        guard let id = advertisementsList[safe: request.index]?.id else { return }
        self.identifier = id
        presenter.presentSelectedAdvertisement(AdvertisementsListScene.SelectedAdvertisement.Response())
    }

    // MARK: - Private methods
    private func fillImagesUrlStringsDict(_ model: [NetworkManagerModels.AdvertisementModel]) {
        model.forEach { self.imagesUrlStringsDict[$0.id] = $0.imageURL }
    }

    private func mapToAdvertisementsListModel(
        _ model: [NetworkManagerModels.AdvertisementModel]
    ) -> [AdvertisementsListScene.Model] {
        return model.map {
            AdvertisementsListScene.Model(
                id: $0.id,
                title: $0.title,
                price: $0.price,
                location: $0.location,
                imageData: nil,
                createdDate: DateFormatterHelper.shared.getFormattedString(from: $0.createdDate)
            )
        }
    }

    private func presentErrorAlert(with text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.presentErrorAlert(AdvertisementsListScene.ErrorAlert.Response(text: text))
        }
    }
}
