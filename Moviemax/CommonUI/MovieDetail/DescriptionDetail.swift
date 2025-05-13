//
//  DescriptionDetail.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit

final class DescriptionDetail: UIView {
    private let maxLines: Int = 6
    private var isExpanded: Bool = false
    private var fullText: String = ""
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = maxLines
        label.font = .systemFont(ofSize: 14)
        label.textColor = .adaptiveTextMain
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        return gesture
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
        fullText = text
        textLabel.addGestureRecognizer(tapGesture)
        updateText()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateText()
    }
}

// MARK: - Private Methods
private extension DescriptionDetail {
    func setupUI() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func handleTap() {
        isExpanded.toggle()
        updateText()
    }
    
    func updateText() {
        if isExpanded {
            textLabel.numberOfLines = 0
            textLabel.text = fullText
        } else {
            textLabel.numberOfLines = maxLines
            let textWithShowMore = fullText + TextConstants.MovieDetail.showMoreText.localized()
            
            let tempLabel = UILabel()
            tempLabel.font = textLabel.font
            tempLabel.numberOfLines = maxLines
            tempLabel.text = textWithShowMore
            tempLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: .greatestFiniteMagnitude)
            tempLabel.sizeToFit()
            
            let textHeight = tempLabel.frame.height
            let lineHeight = textLabel.font.lineHeight
            let estimatedLines = Int(ceil(textHeight / lineHeight))
            
            if estimatedLines > maxLines {
                var truncatedText = fullText
                while truncatedText.count > 0 {
                    let testText = truncatedText + "... " + TextConstants.MovieDetail.showMoreText.localized()
                    tempLabel.text = testText
                    tempLabel.sizeToFit()
                    
                    if Int(ceil(tempLabel.frame.height / lineHeight)) <= maxLines {
                        let attributedString = NSMutableAttributedString(string: testText)
                        let showMoreRange = NSRange(location: testText.count - TextConstants.MovieDetail.showMoreText.localized().count, length: TextConstants.MovieDetail.showMoreText.localized().count)
                        attributedString.addAttribute(.foregroundColor, value: UIColor.accent, range: showMoreRange)
                        textLabel.attributedText = attributedString
                        break
                    }
                    
                    truncatedText = String(truncatedText.prefix(truncatedText.count - 1))
                }
            } else {
                textLabel.text = fullText
            }
        }
    }
}
