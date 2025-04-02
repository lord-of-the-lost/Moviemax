//
//  RatingActionView.swift
//  Moviemax
//
//  Created by Александр Пеньков on 02.04.2025.
//

import UIKit
import SnapKit

protocol RatingActionViewDelegate: AnyObject {
    func ratingActionView(_ view: RatingActionView, didChangeRating rating: Int)
}

final class RatingActionView: UIView {
        
    weak var delegate: RatingActionViewDelegate?
    
    var rating: Int = 0 {
        didSet {
            updateStars()
            delegate?.ratingActionView(self, didChangeRating: rating)
        }
    }
    
    var maxRating: Int = 5 {
        didSet {
            setupStars()
        }
    }
        
    private var starButtons: [UIButton] = []
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let selectedStarColor: UIColor = .systemYellow
    private let unselectedStarColor: UIColor = .systemGray
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
        
    private func setupUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupStars()
    }
    
    private func setupStars() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        starButtons.removeAll()
        
        guard let starImage = UIImage(named: "star") else { return }
        
        for index in 1...maxRating {
            let button = UIButton()
            let templateImage = starImage.withRenderingMode(.alwaysTemplate)
            button.setImage(templateImage, for: .normal)
            button.tintColor = unselectedStarColor
            starButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        updateStars()
    }
    
    private func updateStars() {
        starButtons.forEach { button in
            button.tintColor = button.tag <= rating ? selectedStarColor : unselectedStarColor
        }
    }
}
