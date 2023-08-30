//
//  AdvertisementDetailModels.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation

enum AdvertisementDetailScene {
    struct Model {
        let title: String
        let price: String
        let location: String
        let imageURL: String
        let createdDate: String
        let description: String
        let email: String
        let phoneNumber: String
        let address: String
    }

    // MARK: - Use cases
    enum InitForm {
        struct Request {}
        struct Response {
            let model: NetworkManagerModels.AdvertisementDetailModel
        }
        struct ViewModel {
            let model: Model
        }
    }

    enum Image {
        struct Request {}
        struct Response {
            let data: Data
        }
        struct ViewModel {
            let data: Data
        }
    }

    enum ErrorAlert {
        struct Response {
            let text: String
        }
        struct ViewModel {
            let text: String
        }
    }
}
