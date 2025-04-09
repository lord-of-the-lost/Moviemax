//
//  ChipView.swift
//  Moviemax
//
//  Created by Volchanka on 08.04.2025.
//

import UIKit
import SnapKit


final class ChipViewCell: UICollectionViewCell {
    static let identifier = ChipViewCell.description()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaRegular.withSize(Constants.FontSizes.label)
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
   func setupUI() {
       contentView.backgroundColor = .accent
       contentView.layer.cornerRadius = 16
       contentView.layer.borderWidth = 1
       contentView.layer.borderColor = UIColor.accent.cgColor
       contentView.layer.masksToBounds = true
       contentView.addSubview(label)
       setupConstrains()
    }
    
    func setupConstrains() {
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Constraints.labelInset)
            make.trailing.equalToSuperview().inset(Constants.Constraints.labelInset)
           
            make.top.equalToSuperview().offset(Constants.Constraints.labelSmallInset)
            make.bottom.equalToSuperview().inset(Constants.Constraints.labelSmallInset)
        }
    }
}

// MARK: - Constants
private extension ChipViewCell {
    enum Constants {
        enum Constraints {
            static let labelSmallInset: CGFloat = 9
            static let labelInset: CGFloat = 24
            static let labelHeight: CGFloat = 34
        }
        enum FontSizes {
            static let label: CGFloat = 12
        }
    }
}
