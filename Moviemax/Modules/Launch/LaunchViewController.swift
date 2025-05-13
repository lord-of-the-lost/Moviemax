//
//  LaunchViewController.swift
//  Moviemax
//
//  Created by Volchanka on 10.04.2025.
//

import UIKit

protocol LaunchViewControllerProtocol: AnyObject {}

final class LaunchViewController: UIViewController {
    private let presenter: LaunchPresenterProtocol
    
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
    init(presenter: LaunchPresenterProtocol) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rotateImage()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.presenter.viewDidFinishAnimate()
        }
    }
}

// MARK: - LaunchViewControllerProtocol
extension LaunchViewController: LaunchViewControllerProtocol {}

// MARK: - Private methods
private extension LaunchViewController {
    func rotateImage() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1
        rotation.repeatCount = .infinity
        loadingImageView.layer.add(rotation, forKey: "rotate")
    }
    
    func setupView() {
        view.backgroundColor = .accent
        view.addSubviews(logoImageView, loadingImageView)
    }
    
    func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(136)
            $0.width.equalTo(165)
        }
        
        loadingImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(150)
            $0.height.equalTo(70)
            $0.width.equalTo(70)
        }
    }
}
