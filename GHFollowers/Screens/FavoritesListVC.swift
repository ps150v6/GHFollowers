//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/5/25.
//

import UIKit

class FavoritesListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                print("Favorites: \(favorites)")
            case.failure(let error):
                break
            }
        }
    }
}
