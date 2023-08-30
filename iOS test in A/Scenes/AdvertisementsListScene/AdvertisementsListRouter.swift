//
//  AdvertisementsListRouter.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import UIKit

final class AdvertisementsListRouter: AdvertisementsListRoutingLogic {
    private let dataStore: AdvertisementsListDataStore
    weak var viewController: UIViewController?

    init(dataStore: AdvertisementsListDataStore) {
        self.dataStore = dataStore
    }

    // MARK: - AdvertisementsListRoutingLogic
    func routeToDetails() {
        let controller = AdvertisementDetailAssembly.build(identifier: dataStore.identifier)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
