//
//  ChipView.swift
//  Moviemax
//
//  Created by Volchanka on 08.04.2025.
//

import UIKit

final class ChipViewCell: UICollectionViewCell {
    static let identifier = ChipViewCell.description()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaRegular.withSize(12)
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with text: String, selected: Bool) {
        label.text = text
        contentView.backgroundColor = selected ? .accent : .appBackground
        label.textColor = selected ? .strictWhite : .adaptiveTextSecondary
    }
}

// MARK: - Private methods
private extension ChipViewCell {
   func setupView() {
       contentView.backgroundColor = .accent
       contentView.layer.cornerRadius = 16
       contentView.layer.borderWidth = 1
       contentView.layer.borderColor = UIColor.accent.cgColor
       contentView.layer.masksToBounds = true
       contentView.addSubview(label)
    }
    
    func setupConstrains() {
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().offset(24)
            $0.top.bottom.equalToSuperview().offset(9)
        }
    }
}
