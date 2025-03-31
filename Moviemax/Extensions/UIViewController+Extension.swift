//
//  UIViewController+Extension.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
