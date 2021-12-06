//
//  LocalizationService.swift
//  adultTok-macos
//
//  Created by mac on 6.12.21.
//

import Foundation

struct AppLocalize {
    static func forKey(_ key: String) -> String {
        return LocalizationService.shared.localizedString(for: key)
    }
}

protocol Localizable: AnyObject {
    func applyLocalization()
}

extension Localizable {
    func applyLocalization() {}
}

protocol LocalizationChangeHandler: AnyObject {
    func localizationDidChange()
}

class LocalizationService {
    static let shared = LocalizationService()
    var language: Language = .english {
        didSet {
            changeHandler?.localizationDidChange()
        }
    }
    private var changeHandler: LocalizationChangeHandler?

    enum Language: String {
        case english = "en"
    }
    private struct Constants {
        static let localizationExtension = "lproj"
        static let tableName = "Localizable"
    }

    private init() {
        guard let appLocalization = Bundle.main.preferredLocalizations.first,
              let language = Language(rawValue: appLocalization) else {
            self.language = .english
            return
        }
        self.language = language
    }

    func localizedString(for key: String) -> String {
        guard let bundlePath = Bundle.path(
            forResource: language.rawValue,
            ofType: Constants.localizationExtension,
            inDirectory: Bundle.main.bundlePath
        ),
        let bundle = Bundle(path: bundlePath) else {
            return key
        }

        let localizedString = NSLocalizedString(key,
                                                tableName: Constants.tableName,
                                                bundle: bundle,
                                                comment: "")

        if key == localizedString, localizedString.contains(".") {
            guard let defaultBundlePath = Bundle.path(forResource: Language.english.rawValue,
                                                      ofType: Constants.localizationExtension,
                                                      inDirectory: Bundle.main.bundlePath),
            let defaultBundle = Bundle(path: defaultBundlePath)
            else {
                return key
            }

            let defaultString = NSLocalizedString(key, tableName: Constants.tableName, bundle: defaultBundle, comment: "")
            return defaultString.replacingOccurrences(of: "%@", with: "")
        }

        return NSLocalizedString(
            key,
            tableName: Constants.tableName,
            bundle: bundle,
            comment: ""
        )
    }

    func setLocalizationChangeHandler(changeHandler: LocalizationChangeHandler) {
        self.changeHandler = changeHandler
    }
}

extension String {
    func localize() -> String {
        guard !self.isEmpty else { return "" }
        return AppLocalize.forKey(self)
    }
}
