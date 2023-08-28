//
//  NetworkManagerProtocol.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    typealias СompletionType = (Result<NetworkManagerModels.AdvertisementsListModel, Error>) -> Void
    typealias DetailСompletionType = (Result<NetworkManagerModels.AdvertisementDetailModel, Error>) -> Void

    /// Метод для получения списка объявлений
    func fetchAdvertisements(completion: @escaping СompletionType)
    /// Метод для получения детальной информации о конкретном объявлении
    func fetchDetailAdvertisement(by id: String, completion: @escaping DetailСompletionType)
    /// Метод для получения картинки объявления
    func fetchImage(by urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
