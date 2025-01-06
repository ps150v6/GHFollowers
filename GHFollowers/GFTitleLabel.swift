//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Matthew Rodriguez on 1/5/25.
//

import UIKit

class GFTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        // .systemFont instead of .preferredFont so this is not a dynamic text label since it
        // is already a title that is intended to be large and bold.
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        configure()
    }

    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90  // Shrink to 90% at most.
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
