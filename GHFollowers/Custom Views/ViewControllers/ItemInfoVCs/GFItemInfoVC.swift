//
//  GFItemInfoVC.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/11/25.
//

import UIKit

protocol GFItemInfoVCDelegate: AnyObject {
    func didTapGitHubProfile(_ gfItemInfoVC: GFItemInfoVC, for user: User)
    func didTapViewFollowers(_ gfItemInfoVC: GFItemInfoVC, for user: User)
}

class GFItemInfoVC: UIViewController {

    let stackView = UIStackView()
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton = GFButton()

    var user: User!
    weak var delegate: GFItemInfoVCDelegate?

    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        layoutUI()
        configureStackView()
        configureActionButton()
    }

    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }

    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }

    private func configureActionButton() {
        actionButton.addTarget(
            self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc func actionButtonTapped() {
        // Stub to be overriden by subclasses.
    }

    private func layoutUI() {
        view.addSubview(stackView)
        view.addSubview(actionButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),

            actionButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
