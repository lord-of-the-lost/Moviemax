//
//  SettingsViewController.swift
//  Moviemax
//
//  Created by Penkov Alexander on 06.04.2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let presenter: SettingsPresenter
    
    private lazy var userImageView = AvatarView(photoImage: UIImage(), isEditable: false)
    
    private lazy var nameUserLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(18)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nicknameUserLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(14)
        label.textColor = .adaptiveTextSecondary
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var personalInfoLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaMedium.withSize(12)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = .profile.withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextMain)
        return view
    }()
    
    private lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var profileButtonImageView: UIImageView = {
        let view = UIImageView()
        view.image = .rightArrow.withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextSecondary)
        return view
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var securityInfoLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaMedium.withSize(12)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var changePassImageView: UIImageView = {
        let view = UIImageView()
        view.image = .changePass.withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextMain)
        return view
    }()
    
    private lazy var changePassLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var changePassButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(changePassButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPassImageView: UIImageView = {
        let view = UIImageView()
        view.image = .forgotPass.withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextMain)
        return view
    }()
    
    private lazy var forgotPassLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var forgotPassButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(forgotPassButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var darkModeImageView: UIImageView = {
        let view = UIImageView()
        view.image = .darkMode.withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextMain)
        return view
    }()
    
    private lazy var darkModeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var darkModeSwitch: UISwitch = {
        let darkModeSwitch = UISwitch()
        darkModeSwitch.onTintColor = .accent
        darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged), for: UIControl.Event.valueChanged)
        return darkModeSwitch
    }()
    
    private lazy var languageImageView: UIImageView = {
        let view = UIImageView()
        view.image = .darkMode.withRenderingMode(.alwaysOriginal).withTintColor(.adaptiveTextMain)
        return view
    }()
    
    private lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.plusJakartaSemiBold.withSize(16)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var languageSwitch: UISwitch = {
        let languageSwitch = UISwitch()
        languageSwitch.onTintColor = .accent
        languageSwitch.addTarget(self, action: #selector(languageSwitchChanged), for: UIControl.Event.valueChanged)
        return languageSwitch
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.accent, for: .normal)
        button.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.accent.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    init(presenter: SettingsPresenter) {
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
        setupConstraints()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        updateLocalizedTexts()
    }
}

// MARK: - Private Methods
private extension SettingsViewController {
    func setupUI() {
        view.backgroundColor = .appBackground
        
        view.addSubviews(
            userImageView,
            nameUserLabel,
            nicknameUserLabel,
            personalInfoLabel,
            profileImageView,
            profileLabel,
            profileButtonImageView,
            profileButton,
            securityInfoLabel,
            changePassImageView,
            changePassLabel,
            changePassButton,
            forgotPassImageView,
            forgotPassLabel,
            forgotPassButton,
            darkModeImageView,
            darkModeLabel,
            darkModeSwitch,
            languageImageView,
            languageLabel,
            languageSwitch,
            logOutButton
        )
    }
    
    func setupConstraints() {
        userImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            $0.left.equalToSuperview().offset(24)
            $0.height.width.equalTo(56)
        }
        
        nameUserLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.top)
            $0.left.equalTo(userImageView.snp.right).offset(12)
            $0.height.equalTo(30)
        }
        
        nicknameUserLabel.snp.makeConstraints {
            $0.bottom.equalTo(userImageView.snp.bottom)
            $0.left.equalTo(userImageView.snp.right).offset(12)
            $0.height.equalTo(26)
        }
        
        personalInfoLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(personalInfoLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.height.width.equalTo(24)
        }
        
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.left.equalTo(profileImageView.snp.right).offset(12)
            $0.height.equalTo(24)
        }
        
        profileButtonImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.right.equalToSuperview().offset(-24)
            $0.height.width.equalTo(24)
        }
        
        profileButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.bottom.equalTo(profileImageView.snp.bottom)
            $0.left.equalTo(profileImageView.snp.left)
            $0.right.equalTo(profileButtonImageView.snp.right)
        }
        
        securityInfoLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(20)
        }

        changePassImageView.snp.makeConstraints {
            $0.top.equalTo(securityInfoLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.height.width.equalTo(24)
        }
        
        changePassLabel.snp.makeConstraints {
            $0.top.equalTo(changePassImageView.snp.top)
            $0.left.equalTo(changePassImageView.snp.right).offset(12)
            $0.height.equalTo(24)
        }
        
        changePassButton.snp.makeConstraints {
            $0.top.equalTo(changePassImageView.snp.top)
            $0.bottom.equalTo(changePassImageView.snp.bottom)
            $0.left.equalTo(changePassImageView.snp.left)
            $0.right.equalToSuperview()
        }
        
        forgotPassImageView.snp.makeConstraints {
            $0.top.equalTo(changePassLabel.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.height.width.equalTo(24)
        }
        
        forgotPassLabel.snp.makeConstraints {
            $0.top.equalTo(forgotPassImageView.snp.top)
            $0.left.equalTo(forgotPassImageView.snp.right).offset(12)
            $0.height.equalTo(24)
        }
        
        forgotPassButton.snp.makeConstraints {
            $0.top.equalTo(forgotPassImageView.snp.top)
            $0.bottom.equalTo(forgotPassImageView.snp.bottom)
            $0.left.equalTo(forgotPassImageView.snp.left)
            $0.right.equalToSuperview()
        }
        
        darkModeImageView.snp.makeConstraints {
            $0.top.equalTo(forgotPassLabel.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.height.width.equalTo(24)
        }
        
        darkModeLabel.snp.makeConstraints {
            $0.top.equalTo(darkModeImageView.snp.top)
            $0.left.equalTo(darkModeImageView.snp.right).offset(12)
            $0.height.equalTo(24)
        }
        
        darkModeSwitch.snp.makeConstraints {
            $0.top.equalTo(darkModeImageView.snp.top)
            $0.bottom.equalTo(darkModeImageView.snp.bottom)
            $0.right.equalToSuperview().offset(-24)
        }
        
        languageImageView.snp.makeConstraints {
            $0.top.equalTo(darkModeLabel.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
            $0.height.width.equalTo(24)
        }
        
        languageLabel.snp.makeConstraints {
            $0.top.equalTo(languageImageView.snp.top)
            $0.left.equalTo(languageImageView.snp.right).offset(12)
            $0.height.equalTo(24)
        }
        
        languageSwitch.snp.makeConstraints {
            $0.top.equalTo(languageLabel.snp.top)
            $0.bottom.equalTo(languageLabel.snp.bottom)
            $0.right.equalToSuperview().offset(-24)
        }
        
        logOutButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-35)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(60)
        }
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeChanged),
            name: .themeChanged,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageChanged),
            name: .languageChanged,
            object: nil
        )
    }
    
    func updateLocalizedTexts() {
        navigationItem.title = TextConstants.Settings.screenTitle.localized()
        personalInfoLabel.text = TextConstants.Settings.personalInfo.localized()
        profileLabel.text = TextConstants.Settings.profile.localized()
        securityInfoLabel.text = TextConstants.Settings.securityInfo.localized()
        changePassLabel.text = TextConstants.Settings.changePassword.localized()
        forgotPassLabel.text = TextConstants.Settings.forgotPassword.localized()
        darkModeLabel.text = TextConstants.Settings.darkMode.localized()
        languageLabel.text = TextConstants.Settings.useRussian.localized()
        logOutButton.setTitle(TextConstants.Settings.logout.localized(), for: .normal)
    }
    
    @objc func profileButtonTapped() {
        presenter.showProfileTapped()
    }
    
    @objc func changePassButtonTapped() {
        presenter.showChangePassTapped()
    }
    
    @objc func forgotPassButtonTapped() {
        presenter.showForgotPassTapped()
    }
    
    @objc func darkModeSwitchChanged() {
        presenter.toggleDarkMode(isEnabled: darkModeSwitch.isOn)
    }
    
    @objc func languageSwitchChanged() {
        let language: AppLanguage = languageSwitch.isOn ? .russian : .english
        presenter.setLanguage(language: language)
    }
    
    @objc func logOutButtonTapped() {
        presenter.logOutTapped()
    }
    
    @objc private func themeChanged(_ notification: Notification) {
        guard let theme = notification.object as? AppTheme else { return }
        darkModeSwitch.isOn = (theme == .dark)
    }
    
    @objc private func languageChanged(_ notification: Notification) {
        guard let language = notification.object as? AppLanguage else { return }
        languageSwitch.isOn = (language == .russian)
        updateLocalizedTexts()
    }
}

// MARK: - Public Methods
extension SettingsViewController {
    func updateUserInfo(name: String, nickname: String) {
        nameUserLabel.text = name
        nicknameUserLabel.text = nickname
    }
    
    func updateUserAvatar(image: UIImage) {
        userImageView.updatePhoto(image: image)
    }
    
    func updateAppSettings(isDarkMode: Bool, language: AppLanguage) {
        darkModeSwitch.isOn = isDarkMode
        languageSwitch.isOn = (language == .russian)
        updateLocalizedTexts()
    }
}
