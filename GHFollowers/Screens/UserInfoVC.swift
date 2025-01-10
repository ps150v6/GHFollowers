//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/9/25.
//

import UIKit

class UserInfoVC: UIViewController {
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        print("Username: \(username!)")
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
