//
//  DescriptionDetail.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit
import SnapKit

final class DescriptionDetail: UIView {
        
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
        
    func configure(with text: String) {
        textLabel.text = text
    }
        
    private func setupUI() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
