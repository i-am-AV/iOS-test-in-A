//
//  AdvertisementDetailPresenter.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation
import UIKit.UIImage

final class AdvertisementDetailPresenter: AdvertisementDetailPresentationLogic {
    weak var view: AdvertisementDetailDisplayLogic?

    // MARK: - AdvertisementDetailPresentationLogic
    func presentInitForm(_ response: AdvertisementDetailScene.InitForm.Response) {
        let model: NetworkManagerModels.AdvertisementDetailModel = response.model
        view?.displayInitForm(
            AdvertisementDetailScene.InitForm.ViewModel(
                model: AdvertisementDetailScene.Model(
                    title: model.title,
                    price: model.price,
                    location: model.location,
                    imageURL: model.imageURL,
                    createdDate: DateFormatterHelper.shared.getFormattedString(from: model.createdDate),
                    description: model.description,
                    email: model.email,
                    phoneNumber: model.phoneNumber,
                    address: model.address
                )
            )
        )
    }

    func presentImage(_ response: AdvertisementDetailScene.Image.Response) {
        view?.displayImage(AdvertisementDetailScene.Image.ViewModel(data: response.data))
    }

    func presentErrorAlert(_ response: AdvertisementDetailScene.ErrorAlert.Response) {
        view?.displayErrorAlert(AdvertisementDetailScene.ErrorAlert.ViewModel(text: response.text))
    }
}
