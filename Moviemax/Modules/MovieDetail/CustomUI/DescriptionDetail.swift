//
//  DescriptionDetail.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit
import SnapKit

final class DescriptionDetail: UIView {
        
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .adaptiveTextMain
        return label
    }()
        
    init(text: String) {
        super.init(frame: .zero)
        setupUI()
        configure(with: text)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
        
    func configure(with text: String) {
        textLabel.text = text
    }
}

// MARK: - Private Methods
private extension DescriptionDetail {
    private func setupUI() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
