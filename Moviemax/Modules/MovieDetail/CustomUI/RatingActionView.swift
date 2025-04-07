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
    private var starViews: [UIImageView] = []
    private let rating: Double
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    init(rating: Double = 0) {
        self.rating = rating
        super.init(frame: .zero)
        setupStars()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
} 

// MARK: - Private Methods
private extension RatingView {
    func setupStars() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        for _ in 0..<maxRating {
            let starView = UIImageView()
            starView.contentMode = .scaleAspectFit
            starView.tintColor = .systemGray4
            starView.image = UIImage(resource: .star).withRenderingMode(.alwaysTemplate)
            starViews.append(starView)
            stackView.addArrangedSubview(starView)
        }
        
        updateStars()
    }
    
    func updateStars() {
        let roundedRating = Int(round(rating))
        
        for (index, starView) in starViews.enumerated() {
            starView.tintColor = index < roundedRating ? .systemYellow : .systemGray4
        }
    }
}
