//
//  DateFormatterHelper.swift
//  iOS test in A
//
//  Created by Alex Vasilyev on 30.08.2023.
//

import Foundation

final class DateFormatterHelper {
    // MARK: - Nested types
    private enum Constants {
        static let sourceDateFormat: String = "yyyy-MM-dd"
        static let currentDateFormat: String = "dd MMMM"
        static let localeId: String = "ru_RU"
    }

    static let shared: DateFormatterHelper = DateFormatterHelper()
    private init() {}

    // MARK: - Private properties
    private lazy var sourceDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.sourceDateFormat
        dateFormatter.locale = Locale(identifier: Constants.localeId)
        return dateFormatter
    }()

    private lazy var currentDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.currentDateFormat
        dateFormatter.locale = Locale(identifier: Constants.localeId)
        return dateFormatter
    }()

    // MARK: - Internal methods
    func getFormattedString(from string: String) -> String {
        guard let date = sourceDateFormatter.date(from: string) else { return string }
        return currentDateFormatter.string(from: date)
    }
}
