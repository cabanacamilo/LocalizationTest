//
//  ViewController.swift
//  LocalizationTest
//
//  Created by Camilo Cabana on 6/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello".localized()
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let changeLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("select language".localized(), for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(helloLabel)
        helloLabel.frame = view.bounds
        view.addSubview(changeLanguageButton)
        changeLanguageButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        changeLanguageButton.addTarget(self, action: #selector(didPressChangeLanguageButton), for: .touchUpInside)
    }
    
    @objc func didPressChangeLanguageButton() {
        let message = "Change language of this app including its content."
        let sheetCtrl = UIAlertController(title: "Choose language", message: message, preferredStyle: .actionSheet)

        for languageCode in Bundle.main.localizations.filter({ $0 != "Base" }) {
            let langName = Locale.current.localizedString(forLanguageCode: languageCode)
            let action = UIAlertAction(title: langName, style: .default) { _ in
                self.changeToLanguage(languageCode) // see step #2
            }
            sheetCtrl.addAction(action)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = self.view
        sheetCtrl.popoverPresentationController?.sourceRect = self.changeLanguageButton.frame
        present(sheetCtrl, animated: true, completion: nil)
    }
    
    private func changeToLanguage(_ langCode: String) {
        if Bundle.main.preferredLocalizations.first != langCode {
            let message = "In order to change the language, the App must be closed and reopened by you."
            let confirmAlertCtrl = UIAlertController(title: "App restart required", message: message, preferredStyle: .alert)

            let confirmAction = UIAlertAction(title: "Close now", style: .destructive) { _ in
                UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(EXIT_SUCCESS)
            }
            confirmAlertCtrl.addAction(confirmAction)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            confirmAlertCtrl.addAction(cancelAction)

            present(confirmAlertCtrl, animated: true, completion: nil)
        }
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

