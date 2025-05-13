//
//  OnboardingViewController.swift
//  Moviemax
//
//  Created by Volchanka on 05.04.2025.
//

import UIKit

protocol OnboardingViewControllerProtocol: AnyObject {
    func updateView(with model: PageModel)
}

final class OnboardingViewController: UIViewController {
    private let presenter: OnboardingPresenterProtocol
    
    private lazy var swipeLeft = UISwipeGestureRecognizer()
    private lazy var swipeRight = UISwipeGestureRecognizer()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
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
        label.font = AppFont.plusJakartaBold.withSize(24)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaRegular.withSize(14)
        label.textColor = .adaptiveTextSecondary
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var nextButton: CommonButton = {
        let button = CommonButton(title: "")
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    init(presenter: OnboardingPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView(self)
        setupView()
        setupConstraints()
        setupGestures()
        presenter.viewDidLoad()
    }
}

// MARK: - OnboardingViewControllerProtocol
extension OnboardingViewController: OnboardingViewControllerProtocol {
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
    func setupView() {
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
    }
    
    func setupGestures() {
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(325)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
            $0.height.equalTo(8)
            $0.width.equalTo(100)
        }
        
        largeTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().inset(24)
            $0.height.equalTo(64)
            $0.top.equalTo(pageControl.snp.bottom).offset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().inset(24)
            $0.top.equalTo(largeTitleLabel.snp.bottom).offset(8)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(28)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.height.equalTo(56)
            $0.width.equalTo(200)
        }
    }
    
    @objc func nextButtonTapped() {
        presenter.nextButtonTapped()
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture == swipeLeft {
            presenter.nextButtonTapped()
        } else {
            presenter.prevButtonTapped()
        }
    }
}
