//
//  ViewController+extension.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit

extension UIViewController {
    func showAlert(message: String, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            if let action = action {
                action()
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
