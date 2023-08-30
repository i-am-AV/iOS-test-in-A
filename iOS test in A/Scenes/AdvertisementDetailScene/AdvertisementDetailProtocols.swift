//
//  AdvertisementDetailProtocols.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation

protocol AdvertisementDetailDataStore {}

protocol AdvertisementDetailBusinessLogic {
    func requestInitForm(_ request: AdvertisementDetailScene.InitForm.Request)
    func requestImage(_ request: AdvertisementDetailScene.Image.Request)
}

protocol AdvertisementDetailPresentationLogic {
    func presentInitForm(_ response: AdvertisementDetailScene.InitForm.Response)
    func presentImage(_ response: AdvertisementDetailScene.Image.Response)
    func presentErrorAlert(_ response: AdvertisementDetailScene.ErrorAlert.Response)
}

protocol AdvertisementDetailDisplayLogic: AnyObject {
    func displayInitForm(_ viewModel: AdvertisementDetailScene.InitForm.ViewModel)
    func displayImage(_ viewModel: AdvertisementDetailScene.Image.ViewModel)
    func displayErrorAlert(_ viewModel: AdvertisementDetailScene.ErrorAlert.ViewModel)
}

protocol AdvertisementDetailRoutingLogic {}
