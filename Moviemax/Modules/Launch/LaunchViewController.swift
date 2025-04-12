//
//  LaunchViewController.swift
//  Moviemax
//
//  Created by Volchanka on 10.04.2025.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    // MARK: Properties
    private let presenter: LaunchPresenter
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: .logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var loadingImageView: UIImageView = {
        let imageView = UIImageView(image: .loading)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: Init
    init(presenter: LaunchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
    }
    
    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rotateImage()
        Timer.scheduledTimer(withTimeInterval: Constants.Animation.duration, repeats: false) { _ in
            self.presenter.viewDidFinishAnimate()
        }
    }
}

// MARK: - Private methods
private extension LaunchViewController {
    
    func rotateImage() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = Constants.Animation.duration
        rotation.repeatCount = .infinity
        loadingImageView.layer.add(rotation, forKey: "rotate")
    }
    
    func setupUI() {
        view.backgroundColor = .accent
        view.addSubviews(logoImageView, loadingImageView)
        setupConstraints()
    }
    
    func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(Constants.Constraints.Logo.multiplier)
            make.height.equalTo(Constants.Constraints.Logo.height)
            make.width.equalTo(Constants.Constraints.Logo.width)
        }
        
        loadingImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Constants.Constraints.Loading.offset)
            make.height.equalTo(Constants.Constraints.Loading.height)
            make.width.equalTo(Constants.Constraints.Loading.width)
        }
    }
}

// MARK: - Constants
private extension LaunchViewController {
    enum Constants {
        enum Animation {
            static let duration: TimeInterval = 1
        }
        enum Constraints {
            enum Logo {
                static let multiplier: CGFloat = 0.7
                
                static let height: CGFloat = 136
                static let width: CGFloat = 165
            }
            enum Loading {
                static let offset: CGFloat = 150
                
                static let height: CGFloat = 70
                static let width: CGFloat = 70
            }
        }
    }
}
