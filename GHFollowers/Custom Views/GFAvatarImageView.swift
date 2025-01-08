//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/6/25.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let cache = NetworkManager.shared.cache
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
    
    func setImage(from urlString: String) {
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                print("In main thread: \(Thread.current)... updating image view")
                self?.image = image
            }
        }
    }
}

//#Preview {
//    let imageView = GFAvatarImageView(frame: .zero)
//    imageView.layer.borderColor = UIColor.systemRed.cgColor
//    imageView.layer.borderWidth = 2
//    return imageView
//}
