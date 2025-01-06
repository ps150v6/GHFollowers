//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/6/25.
//

import UIKit

extension UIViewController {
    func presentGFAlertOnMainThread(
        title: String, message: String, buttonTitle: String
    ) {
        DispatchQueue.main.async { [weak self] in
            let alertVC = GFAlertVC(
                title: title, message: message, buttonTitle: buttonTitle)

            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self?.present(alertVC, animated: true, completion: nil)
        }
    }
}
