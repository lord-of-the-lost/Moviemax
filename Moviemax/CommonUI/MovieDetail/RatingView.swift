//
//  RatingView.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit

final class RatingView: UIView {
    private var rating: Double = 0
    private let maxRating: Int = 5
    private var backgroundStars: [UIImageView] = []
    private var foregroundStars: [UIImageView] = []
    private let starSize: CGSize = CGSize(width: 14, height: 14)
    private let spacing: CGFloat = 4
    private lazy var contentView = UIView()
    private lazy var filledStar: UIImage = UIImage(resource: .star).withRenderingMode(.alwaysTemplate)
    private lazy var emptyStar: UIImage = UIImage(resource: .star).withRenderingMode(.alwaysTemplate)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for index in 0..<maxRating {
            let x = CGFloat(index) * (starSize.width + spacing)
            let frame = CGRect(x: x, y: 0, width: starSize.width, height: starSize.height)
            
            backgroundStars[safe: index]?.frame = frame
            foregroundStars[safe: index]?.frame = frame
            
            let current = CGFloat(index) + 1
            if rating >= current {
                foregroundStars[safe: index]?.layer.mask = nil
                foregroundStars[safe: index]?.isHidden = false
            } else if rating > CGFloat(index) {
                let percent = rating - CGFloat(index)
                let maskLayer = CALayer()
                maskLayer.frame = CGRect(x: 0, y: 0, width: starSize.width * percent, height: starSize.height)
                maskLayer.backgroundColor = UIColor.black.cgColor
                foregroundStars[safe: index]?.layer.mask = maskLayer
                foregroundStars[safe: index]?.isHidden = false
            } else {
                foregroundStars[safe: index]?.isHidden = true
            }
        }
    }
    
    func configure(with rating: Double) {
        self.rating = rating
        setupStars()
    }
}

// MARK: - Private Methods
private extension RatingView {
    func setupStars() {
        addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        for _ in 0..<maxRating {
            let background = UIImageView()
            background.tintColor = .gray
            background.image = emptyStar
            background.contentMode = .scaleAspectFit
            contentView.addSubview(background)
            backgroundStars.append(background)
            
            let foreground = UIImageView()
            foreground.tintColor = .systemYellow
            foreground.image = filledStar
            foreground.contentMode = .scaleAspectFit
            foreground.clipsToBounds = true
            contentView.addSubview(foreground)
            foregroundStars.append(foreground)
        }
    }
}
