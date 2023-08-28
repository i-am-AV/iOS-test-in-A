//
//  AppDelegate.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 26.08.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: UIViewController())
        window?.makeKeyAndVisible()

        #warning("Тестирование NetworkManager. Будет удалено")
        let networkManager: NetworkManagerProtocol = NetworkManager()
        networkManager.fetchAdvertisements { result in
            switch result {
            case .success(let list):
                print(list)
                print("\n\n\n")
            case .failure(let error):
                print(error)
            }
        }
        networkManager.fetchDetailAdvertisement(by: "1") { result in
            switch result {
            case .success(let item):
                print(item)
                print("\n\n\n")
            case .failure(let error):
                print(error)
            }
        }
        networkManager.fetchImage(by: "https://www.avito.st/s/interns-ios/images/1.png") { result in
            switch result {
            case .success(let item):
                print(item)
                print(UIImage(data: item))
            case .failure(let error):
                print(error)
            }
        }

        return true
    }
}
