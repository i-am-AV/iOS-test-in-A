//
//  AdvertisementDetailAssembly.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import UIKit

enum AdvertisementDetailAssembly {
    static func build(identifier: String) -> UIViewController {
        let presenter = AdvertisementDetailPresenter()
        let networkManager: NetworkManagerProtocol = NetworkManager()
        let interactor = AdvertisementDetailInteractor(
            presenter: presenter,
            networkManager: networkManager,
            identifier: identifier
        )
        let router = AdvertisementDetailRouter(dataStore: interactor)
        let viewController = AdvertisementDetailViewController(interactor: interactor, router: router)

        presenter.view = viewController
        router.viewController = viewController

        return viewController
    }
}
