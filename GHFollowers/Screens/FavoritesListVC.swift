//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/5/25.
//

import UIKit

class FavoritesListVC: UIViewController {

    let tableView = UITableView()
    var favorites = [Follower]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove any Empty State Views.
        let subViews = view.subviews
        subViews.forEach { view in
            if let view = view as? GFEmptyStateView {
                view.removeFromSuperview()
            }
        }
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            FavoriteCell.self,
            forCellReuseIdentifier: FavoriteCell.reuseIdentifier)
    }

    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result -> Void in
            guard let self = self else { return }

            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(
                        with: "No Favorites?\n Add one on the Follower screen.",
                        in: self.view)
                } else {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.favorites = favorites
                        self.tableView.reloadData()

                        // Edge case. If empty state -> Then added a favorite -> Empty state view is still rendered.
                        // Need to bring tableView to the front.
                        self.view.bringSubviewToFront(tableView)
                    }
                }

            case .failure(let error):
                self.presentGFAlertOnMainThread(
                    title: "Something weng wrong", message: error.rawValue,
                    buttonTitle: "OK")
            }
        }
    }
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: FavoriteCell.reuseIdentifier) as? FavoriteCell

        let favorite = favorites[indexPath.row]
        cell?.set(favorite: favorite)

        return cell
            ?? FavoriteCell(
                style: .default, reuseIdentifier: FavoriteCell.reuseIdentifier)
    }

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let favorite = favorites[indexPath.row]
        let destinationVC = FollowerListVC()
        destinationVC.username = favorite.login
        destinationVC.title = favorite.login
        navigationController?.pushViewController(destinationVC, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }

        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        if favorites.isEmpty {
            self.showEmptyStateView(
                with: "No Favorites?\n Add one on the Follower screen.",
                in: self.view)
        }
        tableView.deleteRows(at: [indexPath], with: .left)

        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) {
            [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }

            self.presentGFAlertOnMainThread(
                title: "Unable to remove", message: error.rawValue,
                buttonTitle: "OK")
        }
    }
}
