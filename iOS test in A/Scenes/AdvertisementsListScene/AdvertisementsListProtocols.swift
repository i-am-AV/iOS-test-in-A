//
//  AdvertisementsListProtocols.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation

protocol AdvertisementsListDataStore {
    var identifier: String { get }
}

protocol AdvertisementsListBusinessLogic {
    func requestInitForm(_ request: AdvertisementsListScene.InitForm.Request)
    func requestImages(_ request: AdvertisementsListScene.Images.Request)
    func requestSelectedAdvertisement(_ request: AdvertisementsListScene.SelectedAdvertisement.Request)
}

protocol AdvertisementsListPresentationLogic {
    func presentInitForm(_ response: AdvertisementsListScene.InitForm.Response)
    func presentImages(_ response: AdvertisementsListScene.Images.Response)
    func presentSelectedAdvertisement(_ response: AdvertisementsListScene.SelectedAdvertisement.Response)
    func presentErrorAlert(_ response: AdvertisementsListScene.ErrorAlert.Response)
}

protocol AdvertisementsListDisplayLogic: AnyObject {
    func displayInitForm(_ viewModel: AdvertisementsListScene.InitForm.ViewModel)
    func displayImages(_ viewModel: AdvertisementsListScene.Images.ViewModel)
    func displaySelectedAdvertisement(_ viewModel: AdvertisementsListScene.SelectedAdvertisement.ViewModel)
    func displayErrorAlert(_ viewModel: AdvertisementsListScene.ErrorAlert.ViewModel)
}

protocol AdvertisementsListRoutingLogic {
    func routeToDetails()
}
