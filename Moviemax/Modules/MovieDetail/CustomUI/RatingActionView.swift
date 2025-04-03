//
//  RatingActionView.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit
import SnapKit

final class RatingActionView: UIView {
    private let maxRating: Int = 5
    private var starViews: [UIImageView] = []
    
    var rating: Double = 0 {
        didSet {
            updateStars()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStars()
    }
    
    private func setupStars() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        for _ in 0..<maxRating {
            let starView = UIImageView()
            starView.contentMode = .scaleAspectFit
            starView.tintColor = .systemGray4
            starView.image = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
            starViews.append(starView)
            stackView.addArrangedSubview(starView)
        }
        
        updateStars()
    }
    
    private func updateStars() {
        let roundedRating = Int(round(rating))
        
        for (index, starView) in starViews.enumerated() {
            starView.tintColor = index < roundedRating ? .systemYellow : .systemGray4
        }
    }
} 
