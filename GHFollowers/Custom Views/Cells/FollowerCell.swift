//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/6/25.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let reuseIdentifier = "FollowerCell"

    let avatarImageView: GFAvatarImageView = {
        return GFAvatarImageView(frame: .zero)
    }()

    let usernameLabel: GFTitleLabel = {
        return GFTitleLabel(textAlignment: .center, fontSize: 12)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func set(follower: Follower) {
        usernameLabel.text = follower.login
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        usernameLabel.text = "Placeholder user"
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}

//#Preview {
//    return FollowerCell(frame: .zero)
//}
