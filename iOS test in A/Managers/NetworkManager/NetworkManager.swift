//
//  NetworkManager.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 27.08.2023.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    // MARK: - Typealiases
    typealias СompletionType = (Result<NetworkManagerModels.AdvertisementsListModel, Error>) -> Void

    private typealias Errors = NetworkManagerModels.Errors
    private typealias AdvertisementsListModel = NetworkManagerModels.AdvertisementsListModel
    private typealias AdvertisementDetailModel = NetworkManagerModels.AdvertisementDetailModel

    // MARK: - Nested types
    private enum Constants {
        enum UrlStrings {
            static let advertisements: String = "https://www.avito.st/s/interns-ios/main-page.json"
            static let advertisementDetail: String = "https://www.avito.st/s/interns-ios/details/{itemId}.json"
        }
        enum Statuses {
            static let success: ClosedRange<Int> = 200...299
            static let redirection: ClosedRange<Int> = 300...399
            static let clientError: ClosedRange<Int> = 400...499
            static let serverError: ClosedRange<Int> = 500...599
        }
    }

    private enum ResponseResult {
        case success
        case failure(Error)
    }

    // MARK: - NetworkManagerProtocol
    func fetchAdvertisements(completion: @escaping СompletionType) {
        self.handleJsonDecode(
            urlString: Constants.UrlStrings.advertisements,
            model: AdvertisementsListModel.self,
            completion: completion
        )
    }

    func fetchDetailAdvertisement(by id: String, completion: @escaping DetailСompletionType) {
        self.handleJsonDecode(
            urlString: "https://www.avito.st/s/interns-ios/details/\(id).json",
            model: AdvertisementDetailModel.self,
            completion: completion
        )
    }

    func fetchImage(by urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        self.handleImageJsonDecode(urlString: urlString, completion: completion)
    }

    // MARK: - Private methods
    private func handleJsonDecode<T: Decodable>(
        urlString: String,
        model: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        getUrlRequest(by: urlString) { result in
            switch result {
            case .success(let request):
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error: Error = error { completion(.failure(error)) }
                    guard let data: Data = data else {
                        completion(.failure(Errors.noData))
                        return
                    }
                    self.handleNetworkResponse(response) { result in
                        switch result {
                        case .success:
                            do {
                                let result = try JSONDecoder().decode(model, from: data)
                                completion(.success(result))
                            } catch let error {
                                completion(.failure(error))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }.resume()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func handleImageJsonDecode(
        urlString: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        getUrlRequest(by: urlString) { result in
            switch result {
            case .success(let request):
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error: Error = error { completion(.failure(error)) }
                    guard let data: Data = data else {
                        completion(.failure(Errors.noData))
                        return
                    }
                    self.handleNetworkResponse(response) { result in
                        switch result {
                        case .success:
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }.resume()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getUrlRequest(
        by urlString: String,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(Errors.castError))
            return
        }
        completion(.success(URLRequest(url: url)))
    }

    /// Метод для обработки сетевого запроса
    /// При неудачном запросе возвращает локализованный тип ошибки
    private func handleNetworkResponse(
        _ response: URLResponse?,
        completion: @escaping (ResponseResult) -> Void
    ) {
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(Errors.castError))
            return
        }
        switch response.statusCode {
        case Constants.Statuses.success:
            completion(.success)
        case Constants.Statuses.redirection:
            completion(.failure(Errors.redirection))
        case Constants.Statuses.clientError:
            completion(.failure(Errors.clientError))
        case Constants.Statuses.serverError:
            completion(.failure(Errors.serverError))
        default:
            completion(.failure(Errors.requestFailed))
        }
    }
}
