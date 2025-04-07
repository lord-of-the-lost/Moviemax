//
//  OnboardingViewController.swift
//  Moviemax
//
//  Created by Volchanka on 05.04.2025.
//

import UIKit
import SnapKit


final class OnboardingViewController: UIViewController {
    
    // MARK: Properties
    private let presenter: OnboardingPresenter
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage()
        )
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.Constraints.cornerRadius
        return view
    }()
    
 
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.pageIndicatorTintColor = .gray
        control.currentPageIndicatorTintColor = .accent
        return control
    }()
    
    private lazy var largeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaBold.withSize(Constants.FontSizes.largeLabel)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = ""
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaRegular.withSize(Constants.FontSizes.label)
        label.textColor = .adaptiveTextSecondary
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = ""
        return label
    }()
    
    private lazy var nextButton: CommonButton = {
        let button = CommonButton(title: "")
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: Init
    init(presenter: OnboardingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
        presenter.viewDidLoad()
    }
}

// MARK: - Methods
extension OnboardingViewController {
    
    func updateView(with model: PageModel) {
        pageControl.currentPage = model.id
        backgroundImageView.image = model.image
        largeTitleLabel.text = model.largeTitle
        descriptionLabel.text = model.text
        nextButton.setTitle(model.buttonTitle, for: .normal)
    }
}

// MARK: - Private methods
private extension OnboardingViewController {
    
    @objc func nextButtonTapped() {
        presenter.nextButtonTapped()
    }
    
    func setupUI() {
        view.backgroundColor = .accent
        contentView.backgroundColor = .appBackground
       
        view.addSubviews(
            backgroundImageView,
            contentView,
            descriptionLabel
        )
        
        contentView.addSubviews(
            pageControl,
            largeTitleLabel,
            descriptionLabel,
            nextButton
        )
        
        setupConstraints()
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.left
                .equalToSuperview()
                .offset(Constants.Constraints.labelOffsetInset)
            make.right
                .equalToSuperview()
                .inset(Constants.Constraints.labelOffsetInset)
            make.bottom
                .equalTo(view.safeAreaLayoutGuide)
                .inset(Constants.Constraints.safeAreaInset)
            make.height
                .equalTo(Constants.Constraints.contentViewHeight)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top
                .equalToSuperview()
                .offset(Constants.Constraints.labelOffsetInset)
            make.height.equalTo(Constants.Constraints.smallSpacing)
            make.width.equalTo(Constants.Constraints.pageControlWidth)
        }
        
        largeTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.Constraints.labelOffsetInset)
            make.right.equalToSuperview().inset(Constants.Constraints.labelOffsetInset)
            make.height.equalTo(Constants.Constraints.largeTtitleHeight)
            make.top.equalTo(pageControl.snp.bottom).offset(Constants.Constraints.labelOffsetInset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.Constraints.labelOffsetInset)
            make.right.equalToSuperview().inset(Constants.Constraints.labelOffsetInset)
            make.top.equalTo(largeTitleLabel.snp.bottom).offset(Constants.Constraints.smallSpacing)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.Constraints.mediumSpacing)
            make.top
                .equalTo(descriptionLabel.snp.bottom)
                .offset(Constants.Constraints.labelOffsetInset)
            make.height.equalTo(Constants.Constraints.nextButtonHeight)
            make.width.equalTo(Constants.Constraints.nextButtonWidth)
        }
    }
}

// MARK: - Constants
private extension OnboardingViewController {
    enum Constants {
        enum Text {
            static let nextButtonTitle: String = "Continue"
        }
        
        enum Constraints {
            static let nextButtonHeight: CGFloat = 56
            static let nextButtonWidth: CGFloat = 200
            static let largeTtitleHeight: CGFloat = 64
            static let labelOffsetInset: CGFloat = 24
            static let smallSpacing: CGFloat = 8
            static let mediumSpacing: CGFloat = 28
            static let cornerRadius: CGFloat = 16
            static let safeAreaInset: CGFloat = 20
            static let contentViewHeight: CGFloat = 325
            static let pageControlWidth: CGFloat = 100
        }
        
        enum FontSizes {
            static let largeLabel: CGFloat = 24
            static let label: CGFloat = 14
            static let textView: CGFloat = 16
        }
    }
}
