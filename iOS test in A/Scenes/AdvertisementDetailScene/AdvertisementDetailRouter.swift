//
//  AdvertisementDetailRouter.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import UIKit

final class AdvertisementDetailRouter: AdvertisementDetailRoutingLogic {
    private let dataStore: AdvertisementDetailDataStore
    weak var viewController: UIViewController?

    init(dataStore: AdvertisementDetailDataStore) {
        self.dataStore = dataStore
    }
}
