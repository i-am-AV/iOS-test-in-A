//
//  UIViewExtension.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 29.08.2023.
//

import UIKit

extension UIView {
    func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
