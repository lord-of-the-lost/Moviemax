//
//  BorderView.swift
//  Moviemax
//
//  Created by Volchanka on 03.04.2025.
//

import UIKit

final class BorderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.borderColor = UIColor.accent.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 24
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
