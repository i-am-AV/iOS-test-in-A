//
//  AdvertisementsListCompositionalLayout.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 28.08.2023.
//

import UIKit

enum AdvertisementsListCompositionalLayout {
    // MARK: - Nested types
    private enum Constants {
        enum Grid {
            static let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(100.0)
            )
            static let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100.0)
            )
            static let groupCount: Int = 2
            static let interItemSpacing: NSCollectionLayoutSpacing = .fixed(10)
            static let contentInsets = NSDirectionalEdgeInsets(
                top: .zero,
                leading: 16,
                bottom: .zero,
                trailing: 16
            )
        }
    }

    static func gridSectionLayout(
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = Constants.Grid.itemSize
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize: NSCollectionLayoutSize = Constants.Grid.groupSize
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: Constants.Grid.groupCount
        )
        group.interItemSpacing = Constants.Grid.interItemSpacing
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constants.Grid.contentInsets
        return section
    }
}
