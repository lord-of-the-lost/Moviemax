//
//  RatingActionView.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit
import SnapKit

final class RatingView: UIView {
    private let maxRating: Int = 5
    private var backgroundStars: [UIImageView] = []
    private var foregroundStars: [UIImageView] = []
    private var starSize: CGSize = CGSize(width: 14, height: 14)
    private let spacing: CGFloat = 4
    
    var rating: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private lazy var contentView = UIView()
    
    private let filledStar: UIImage = {
        let image = UIImage(resource: .star).withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    private let emptyStar: UIImage = {
        let image = UIImage(resource: .star).withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    init(rating: Double = 0) {
        super.init(frame: .zero)
        self.rating = rating
        setupStars()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for index in 0..<maxRating {
            let x = CGFloat(index) * (starSize.width + spacing)
            let frame = CGRect(x: x, y: 0, width: starSize.width, height: starSize.height)
            
            backgroundStars[index].frame = frame
            foregroundStars[index].frame = frame
            
            let current = CGFloat(index) + 1
            if rating >= current {
                foregroundStars[index].layer.mask = nil
                foregroundStars[index].isHidden = false
            } else if rating > CGFloat(index) {
                let percent = rating - CGFloat(index)
                let maskLayer = CALayer()
                maskLayer.frame = CGRect(x: 0, y: 0, width: starSize.width * percent, height: starSize.height)
                maskLayer.backgroundColor = UIColor.black.cgColor
                foregroundStars[index].layer.mask = maskLayer
                foregroundStars[index].isHidden = false
            } else {
                foregroundStars[index].isHidden = true
            }
        }
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
            let bg = UIImageView()
            bg.tintColor = .gray
            bg.image = emptyStar
            bg.contentMode = .scaleAspectFit
            contentView.addSubview(bg)
            backgroundStars.append(bg)
            
            let fg = UIImageView()
            fg.tintColor = .systemYellow
            fg.image = filledStar
            fg.contentMode = .scaleAspectFit
            fg.clipsToBounds = true
            contentView.addSubview(fg)
            foregroundStars.append(fg)
        }
    }
}
