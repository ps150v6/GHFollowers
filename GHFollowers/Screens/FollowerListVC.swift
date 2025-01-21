//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/5/25.
//

import UIKit

class FollowerListVC: UIViewController {

    enum Section {
        case main
    }

    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view)
        )
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            FollowerCell.self,
            forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func getFollowers(username: String, page: Int, perPage: Int = 10) {
        showLoadingView()
        NetworkManager.shared.getFollowers(
            for: username, page: page, perPage: perPage
        ) {
            [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingViewOnMainThread()

            switch result {
            case .success(let followers):
                // For pagination
                if followers.count < perPage {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    DispatchQueue.main.async {
                        let message =
                            "This user doesn't have any followers. Go follow them 😀."
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(
                    title: "Bad Stuff Happened", message: error.rawValue,
                    buttonTitle: "OK")
            }
        }
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: FollowerCell.reuseIdentifier,
                        for: indexPath) as? FollowerCell
                cell?.set(follower: itemIdentifier)
                return cell
            })
    }

    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    @objc func addButtonTapped() {
        showLoadingView()

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingViewOnMainThread()

            switch result {
            case .success(let user):
                let favorite = Follower(
                    login: user.login, avatarUrl: user.avatarUrl)

                PersistenceManager.updateWith(
                    favorite: favorite, actionType: .add
                ) { [weak self] error in
                    guard let self = self else { return }
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(
                            title: "Success!",
                            message:
                                "You have successfully favorited this user 🥳",
                            buttonTitle: "Hooray!")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                }

            case .failure(let error):
                self.presentGFAlertOnMainThread(
                    title: "Something went wrong", message: error.rawValue,
                    buttonTitle: "OK")
            }
        }

    }
}

extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView, willDecelerate decelerate: Bool
    ) {
        let offsetY: CGFloat = scrollView.contentOffset.y
        let contentHeight: CGFloat = scrollView.contentSize.height
        let height: CGFloat = scrollView.frame.size.height

        if offsetY > (contentHeight - height) {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let destinationVC = UserInfoVC()
        destinationVC.delegate = self
        destinationVC.username = follower.login
        let navController = UINavigationController(
            rootViewController: destinationVC)
        present(navController, animated: true, completion: nil)
    }
}

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty
        else {
            isSearching = false
            updateData(on: followers)
            return
        }

        filteredFollowers = followers.filter({ follower in
            return follower.login.lowercased().contains(filter.lowercased())
        })
        isSearching = true
        updateData(on: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(_ userInfoVC: UserInfoVC, for username: String) {
        self.username = username
        self.title = username

        followers.removeAll()
        filteredFollowers.removeAll()
        page = 1
        hasMoreFollowers = true
        // collectionView.setContentOffset(.zero, animated: true)
        collectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0), at: .top, animated: true)

        if isSearching {
            navigationItem.searchController?.searchBar.text = ""
            navigationItem.searchController?.searchBar.resignFirstResponder()
            navigationItem.searchController?.dismiss(animated: true)
            isSearching = false
        }
        getFollowers(username: username, page: page)
    }
}
