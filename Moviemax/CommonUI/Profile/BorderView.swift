//
//  BorderView.swift
//  Moviemax
//
//  Created by Volchanka on 03.04.2025.
//

import UIKit
import SnapKit

final class BorderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.borderColor = UIColor.accent.cgColor
        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = Constants.cornerRadius
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BorderView {
    enum Constants {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 24
    }
}
