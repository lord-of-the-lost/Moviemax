//
//  FilterView.swift
//  Moviemax
//
//  Created by Penkov Alexander on 11.04.2025.
//


import UIKit
import SnapKit

final class FilterView: UIView {
    
    // MARK: - Public Properties
    var closeButtonAction: (() -> Void)?
    var selectedCategoryChanged: ((String) -> Void)?
    var selectedRatingChanged: ((Int) -> Void)?
    
    // MARK: - Private Properties
    private let categories = [
        TextConstants.Genres.all.localized(),
        TextConstants.Genres.action.localized(),
        TextConstants.Genres.adventure.localized(),
        TextConstants.Genres.mystery.localized(),
        TextConstants.Genres.fantasy.localized(),
        TextConstants.Genres.others.localized()
    ]
    private var categoryLabels: [UILabel] = []
    private var selectedLabel: UILabel?
    
    private var ratingViews: [UIView] = []
    private var selectedRatingView: UIView?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .close), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleFilter: UILabel = {
        let label = UILabel()
        label.text = TextConstants.FilterView.filterTitle.localized()
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaSemiBold.withSize(18)
        return label
    }()
    
    private lazy var resetFiltersButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextConstants.FilterView.resetFilters.localized(), for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = AppFont.plusJakartaSemiBold.withSize(14)
        button.addTarget(self, action: #selector(resetFiltersButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoriesTitle: UILabel = {
        let label = UILabel()
        label.text = TextConstants.FilterView.categories.localized()
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        return label
    }()
    
    private lazy var categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var firstRowStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(UIView())
        return stackView
    }()
    
    private lazy var secondRowStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(UIView())
        return stackView
    }()
    
    private lazy var starRatingTitle: UILabel = {
        let label = UILabel()
        label.text = TextConstants.FilterView.starRating.localized()
        label.textColor = .adaptiveTextMain
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var firstRatingRow: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(UIView())
        return stackView
    }()
    
    private lazy var secondRatingRow: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(UIView())
        return stackView
    }()
    
    private lazy var applyFiltersButton: CommonButton = {
        let button = CommonButton(title: TextConstants.FilterView.applyFilterButton.localized())
        button.addTarget(self, action: #selector(applyFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
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
}

// MARK: - Private Methods
private extension FilterView {
    private func setupUI() {
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 24
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        addSubviews(closeButton, resetFiltersButton, titleFilter, categoriesTitle, categoriesStackView, starRatingTitle, ratingStackView, applyFiltersButton)
        
        categoriesStackView.addArrangedSubview(firstRowStack)
        categoriesStackView.addArrangedSubview(secondRowStack)
        
        ratingStackView.addArrangedSubview(firstRatingRow)
        ratingStackView.addArrangedSubview(secondRatingRow)
        
        setupCategoryLabels()
        setupRatingViews()
        
        self.snp.makeConstraints {
            $0.height.equalTo(460)
        }

        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview().offset(22)
            $0.width.height.equalTo(20)
        }
        
        resetFiltersButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-35)
            $0.height.equalTo(22)
        }
        
        titleFilter.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.leading.equalTo(closeButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        categoriesTitle.snp.makeConstraints {
            $0.top.equalTo(titleFilter.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(22)
            $0.height.equalTo(26)
        }
        
        categoriesStackView.snp.makeConstraints {
            $0.top.equalTo(categoriesTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        starRatingTitle.snp.makeConstraints {
            $0.top.equalTo(categoriesStackView.snp.bottom).offset(21)
            $0.leading.equalToSuperview().offset(22)
            $0.height.equalTo(26)
        }
        
        ratingStackView.snp.makeConstraints {
            $0.top.equalTo(starRatingTitle.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        applyFiltersButton.snp.makeConstraints {
            $0.top.equalTo(ratingStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
            $0.height.equalTo(56)
        }
    }
    
    private func setupCategoryLabels() {
        for (index, category) in categories.enumerated() {
            let label = createCategoryLabel(with: category)
            categoryLabels.append(label)
            
            let container = UIView()
            container.addSubview(label)
            
            container.snp.makeConstraints {
                $0.width.equalTo(label.intrinsicContentSize.width + 48)
            }
            
            label.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            if index < 3 {
                firstRowStack.insertArrangedSubview(container, at: firstRowStack.arrangedSubviews.count - 1)
            } else {
                secondRowStack.insertArrangedSubview(container, at: secondRowStack.arrangedSubviews.count - 1)
            }
            
            if index == 0 {
                label.backgroundColor = .accent
                label.textColor = .white
                label.layer.borderColor = UIColor.accent.cgColor
                selectedLabel = label
            }
        }
    }
    
    private func createCategoryLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = AppFont.plusJakartaMedium.withSize(14)
        label.textColor = .adaptiveTextMain
        label.backgroundColor = .white
        label.layer.cornerRadius = 20
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        
        let horizontalPadding: CGFloat = 24
        label.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        label.layoutMargins = UIEdgeInsets(top: 0, left: horizontalPadding, bottom: 0, right: horizontalPadding)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryLabelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }
    
    private func createRatingView(starsCount: Int) -> UIView {
        let container = UIButton()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        container.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        
        container.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        for _ in 0..<starsCount {
            let starImageView = UIImageView(image: UIImage(resource: .star))
            stackView.addArrangedSubview(starImageView)
            
            starImageView.snp.makeConstraints {
                $0.width.height.equalTo(16)
            }
        }
        
        container.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        return container
    }
    
    private func setupRatingViews() {
        for stars in 1...3 {
            let ratingView = createRatingView(starsCount: stars)
            ratingViews.append(ratingView)
            firstRatingRow.insertArrangedSubview(ratingView, at: firstRatingRow.arrangedSubviews.count - 1)
        }
        
        for stars in 4...5 {
            let ratingView = createRatingView(starsCount: stars)
            ratingViews.append(ratingView)
            secondRatingRow.insertArrangedSubview(ratingView, at: secondRatingRow.arrangedSubviews.count - 1)
        }
    }
    
    @objc private func closeButtonTapped() {
        closeButtonAction?()
    }
    
    @objc private func resetFiltersButtonTapped() {
        selectedRatingView?.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        selectedRatingView = nil
        
        selectedLabel?.backgroundColor = .white
        selectedLabel?.textColor = .adaptiveTextMain
        selectedLabel?.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        if let firstLabel = categoryLabels.first {
            firstLabel.backgroundColor = .accent
            firstLabel.textColor = .white
            firstLabel.layer.borderColor = UIColor.accent.cgColor
            selectedLabel = firstLabel
            selectedCategoryChanged?(firstLabel.text ?? "")
        }
        
        selectedRatingChanged?(0)
    }
    
    @objc private func categoryLabelTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedLabel = gesture.view as? UILabel else { return }
        
        if tappedLabel == selectedLabel {
            return
        }
        
        selectedLabel?.backgroundColor = .white
        selectedLabel?.textColor = .adaptiveTextMain
        selectedLabel?.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        tappedLabel.backgroundColor = .accent
        tappedLabel.textColor = .white
        tappedLabel.layer.borderColor = UIColor.accent.cgColor
        
        selectedLabel = tappedLabel
        selectedCategoryChanged?(tappedLabel.text ?? "")
    }
    
    @objc private func ratingButtonTapped(_ button: UIButton) {
        if button == selectedRatingView {
            return
        }
        
        selectedRatingView?.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        button.layer.borderColor = UIColor.accent.cgColor
        
        selectedRatingView = button
        
        if let index = ratingViews.firstIndex(of: button) {
            selectedRatingChanged?(index + 1)
        }
    }
    
    @objc private func applyFilterButtonTapped() {
        closeButtonAction?()
    }
}
