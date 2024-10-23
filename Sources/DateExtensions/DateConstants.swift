//
//  DateConstants.swift
//  DateExtensions
//
//  Created by Thomas Benninghaus on 26.03.24.
//

import Foundation

public struct DateConstants {
    public static var `default`: DateConstants.Default { DateConstants.Default() }
    public struct Default {
//        public var localeIdentifier: LocaleIdentifier { locale.identifier }
//        public var languageIdentifier: LanguageIdentifier { language.identifier }
        public var timeZone = TimeZone(identifier: "UTC")
//        public var language: Language { locale.language }
//        public var locale = LocaleFormatting(
//            id: UUID(),
//            name: "Default Locale",
//            identifier: .de_DE,
//            longName: "default locale de_DE",
//            language: Language(id: UUID(), name: "german", identifier: .de, longName: "Deutsch"),
//            localization: { _ in "not implemented" }
//        )
    }
}
