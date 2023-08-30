//
//  AdvertisementsListPresenter.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation
import UIKit.UIImage

final class AdvertisementsListPresenter: AdvertisementsListPresentationLogic {
    weak var view: AdvertisementsListDisplayLogic?

    // MARK: - AdvertisementsListPresentationLogic
    func presentInitForm(_ response: AdvertisementsListScene.InitForm.Response) {
        view?.displayInitForm(
            AdvertisementsListScene.InitForm.ViewModel(
                advertisementsList: response.advertisementsList.map {
                    AdvertisementsListScene.Model(
                        id: $0.id,
                        title: $0.title,
                        price: $0.price,
                        location: $0.location,
                        imageData: $0.imageData,
                        createdDate: $0.createdDate
                    )
                }
            )
        )
    }

    func presentImages(_ response: AdvertisementsListScene.Images.Response) {
        view?.displayImages(AdvertisementsListScene.Images.ViewModel(model: response.model))
    }

    func presentSelectedAdvertisement(_ response: AdvertisementsListScene.SelectedAdvertisement.Response) {
        view?.displaySelectedAdvertisement(AdvertisementsListScene.SelectedAdvertisement.ViewModel())
    }

    func presentErrorAlert(_ response: AdvertisementsListScene.ErrorAlert.Response) {
        view?.displayErrorAlert(AdvertisementsListScene.ErrorAlert.ViewModel(text: response.text))
    }
}
