//
//  AdvertisementsListModels.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation

enum AdvertisementsListScene {
    enum Sections: Int {
        case gridSection
    }

    struct Model: Hashable, Identifiable {
        let id: String
        let title: String
        let price: String
        let location: String
        var imageData: Data?
        let createdDate: String

        static func == (lhs: Model, rhs: Model) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Use cases
    enum InitForm {
        struct Request {}
        struct Response {
            let advertisementsList: [Model]
        }
        struct ViewModel {
            let advertisementsList: [Model]
        }
    }

    enum Images {
        struct Request {}
        struct Response {
            let model: [Model]
        }
        struct ViewModel {
            let model: [Model]
        }
    }

    enum SelectedAdvertisement {
        struct Request {
            let index: Int
        }
        struct Response {}
        struct ViewModel {}
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
