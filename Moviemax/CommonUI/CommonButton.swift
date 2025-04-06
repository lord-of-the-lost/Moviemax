//
//  CommonButton.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

final class CommonButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(isEnabled ? 1.0 : 0.5)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            }
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension CommonButton {
    func setupButton(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = AppFont.plusJakartaSemiBold.withSize(16)
        backgroundColor = UIColor(resource: .accent)
        setTitleColor(UIColor(resource: .strictWhite), for: .normal)
        layer.cornerRadius = 24
    }
}
