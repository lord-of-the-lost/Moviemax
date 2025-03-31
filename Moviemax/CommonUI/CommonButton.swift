//
//  CommonButton.swift
//  Moviemax
//
//  Created by Николай Игнатов on 31.03.2025.
//

import UIKit

final class CommonButton: UIButton {
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
        setTitle("Авторизоваться", for: .normal)
        titleLabel?.font = AppFont.plusJakartaSemiBold.withSize(16)
        backgroundColor = UIColor(resource: .accent)
        setTitleColor(UIColor(resource: .buttonTitle), for: .normal)
        layer.cornerRadius = 24
    }
}
