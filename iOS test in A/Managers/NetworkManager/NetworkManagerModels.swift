//
//  NetworkManagerModels.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 27.08.2023.
//

struct NetworkManagerModels {
    struct AdvertisementsListModel: Codable {
        let advertisements: [AdvertisementModel]
    }

    struct AdvertisementModel: Codable {
        let id: String
        let title: String
        let price: String
        let location: String
        let imageURL: String
        let createdDate: String

        enum CodingKeys: String, CodingKey {
            case id
            case title
            case price
            case location
            case imageURL = "image_url"
            case createdDate = "created_date"
        }
    }

    struct AdvertisementDetailModel: Codable {
        let id: String
        let title: String
        let price: String
        let location: String
        let imageURL: String
        let createdDate: String
        let description: String
        let email: String
        let phoneNumber: String
        let address: String

        enum CodingKeys: String, CodingKey {
            case id
            case title
            case price
            case location
            case imageURL = "image_url"
            case createdDate = "created_date"
            case description
            case email
            case phoneNumber = "phone_number"
            case address
        }
    }

    enum Errors: Error {
        case noData
        case castError
        case redirection
        case clientError
        case serverError
        case requestFailed

        var localizedDescription: String {
            switch self {
            case .noData:
                return "Нет данных"
            case .castError:
                return "Ошибка приведения данных"
            case .redirection:
                return "Перенаправление"
            case .clientError:
                return "Ошибка клиента"
            case .serverError:
                return "Ошибка сервера"
            case .requestFailed:
                return "Ошибка запроса"
            }
        }
    }
}
