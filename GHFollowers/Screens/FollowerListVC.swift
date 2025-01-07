//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/5/25.
//

import UIKit

class FollowerListVC: UIViewController {
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        NetworkManager.shared.getFollowers(for: username, page: 1) {
            [weak self] followers, errorMessage in
            guard let followers = followers else {
                self?.presentGFAlertOnMainThread(
                    title: "Bad Stuff Happened",
                    message: errorMessage?.rawValue ?? "", buttonTitle: "OK")
                return
            }

            print("Followers.count = \(followers.count)")
            print("Followers = \(followers)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
