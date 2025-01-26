//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/26/25.
//

import UIKit

class FavoriteCell: UITableViewCell {
    static let reuseIdentifier = "FavoriteCell"

    lazy var avatarImageView: GFAvatarImageView = {
        return GFAvatarImageView(frame: .zero)
    }()

    lazy var usernameLabel: GFTitleLabel = {
        return GFTitleLabel(textAlignment: .left, fontSize: 26)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func set(favorite: Follower) {
        avatarImageView.setImage(from: favorite.avatarUrl)
        usernameLabel.text = favorite.login
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        accessoryType = .disclosureIndicator

        let padding: CGFloat = 12
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
