//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/6/25.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeholderImage = UIImage(named: "avatar-placeholder")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure() {
        layer.cornerRadius = 48
        clipsToBounds = true  // because we have a cornerRadius
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}

//#Preview {
//    let imageView = GFAvatarImageView(frame: .zero)
//    imageView.layer.borderColor = UIColor.systemRed.cgColor
//    imageView.layer.borderWidth = 2
//    return imageView
//}
