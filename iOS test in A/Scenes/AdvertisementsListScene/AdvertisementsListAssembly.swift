//
//  AdvertisementsListAssembly.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import UIKit

enum AdvertisementsListAssembly {
    static func build() -> UIViewController {
        let presenter = AdvertisementsListPresenter()
        let networkManager: NetworkManagerProtocol = NetworkManager()
        let interactor = AdvertisementsListInteractor(
            presenter: presenter,
            networkManager: networkManager
        )
        let router = AdvertisementsListRouter(dataStore: interactor)
        let viewController = AdvertisementsListViewController(interactor: interactor, router: router)

        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
