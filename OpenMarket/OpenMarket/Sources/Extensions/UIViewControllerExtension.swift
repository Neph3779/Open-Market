//
//  UIViewControllerExtension.swift
//  OpenMarket
//
//  Created by 천수현 on 2022/10/28.
//

import UIKit

extension UIViewController {
    func showErrorAlert(error: OpenMarketError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: error.name, message: error.description, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "확인", style: .cancel) { _ in  self.dismiss(animated: true, completion: nil) }
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
