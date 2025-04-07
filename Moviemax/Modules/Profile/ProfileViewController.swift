//
//  ProfileViewController.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    // MARK: Properties
    private let presenter: ProfilePresenter
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var profilePhotoContainerView = UIView()
    
    private lazy var profilePhotoView = AvatarView(
        photoImage: .profilePlaceholder,
        isEditable: true
    )
    
    private lazy var firstNameTextField = CustomTextEditView(
        text: Constants.Text.firstName,
        labelName: Constants.Text.firstNameLabel,
        type: .textField
    )
    
    private lazy var lastNameTextField = CustomTextEditView(
        text: Constants.Text.lastName,
        labelName: Constants.Text.lastNameLabel,
        type: .textField
    )
    
    private lazy var emailTextField = CustomTextEditView(
        text: Constants.Text.email,
        labelName: Constants.Text.emailLabel,
        type: .textField
    )
    
    private lazy var dateOfBirthTextField = CustomTextEditView(
        text: Constants.Text.dateOfBirth,
        labelName: Constants.Text.dateOfBirthLabel,
        type: .date
    )
    
    private lazy var locationTextView = CustomTextEditView(
        text: Constants.Text.location,
        labelName: Constants.Text.locationLabel,
        type: .textView
    )
    
    // TODO: Get the gender from the model
    private lazy var genderSelectorView = GenderSelectorView(selectedGender: .male)
    
    private lazy var saveButton: CommonButton = {
        let button = CommonButton(title: Constants.Text.saveButtonTitle)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Constraints.stackViewSpacing
        return stackView
    }()
    
    
    //MARK: Init
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        setupUI()
        setupConstraints()
    }
}

// MARK: - Private Methods
private extension ProfileViewController {
    func setupUI() {
        navigationItem.title = Constants.Text.screenName
        view.backgroundColor = .appBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        profilePhotoContainerView.addSubview(profilePhotoView)
        
        stackView.addArrangedSubviews(
            profilePhotoContainerView,
            firstNameTextField,
            lastNameTextField,
            emailTextField,
            dateOfBirthTextField,
            genderSelectorView,
            locationTextView,
            saveButton
        )
        
        saveButton.isEnabled = false
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.Constraints.stackViewOffsetInset)
            make.right.equalToSuperview().inset(Constants.Constraints.stackViewOffsetInset)
            make.top.bottom.equalToSuperview()
        }
        
        profilePhotoContainerView.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.photoSize)
        }
        
        profilePhotoView.snp.makeConstraints { make in
            make.size.equalTo(Constants.Constraints.photoSize)
            make.center.equalToSuperview()
        }
        
        firstNameTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.textFieldHeight)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.textFieldHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.textFieldHeight)
        }
        
        dateOfBirthTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.textFieldHeight)
        }
        
        genderSelectorView.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.textFieldHeight)
        }
        
        locationTextView.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.locationTextViewHeight)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.saveButtonHeight)
        }
    }
    
    @objc func saveButtonTapped() {
        showAlert(title: "Сохранение", message: "Изменения сохранены")
    }
}

// MARK: - Constants
private extension ProfileViewController {
    enum Constants {
        enum Text {
            static let saveButtonTitle: String = "Сохранить изменения"
            static let screenName: String = "Profile"
            
            static let firstNameLabel: String = "First Name"
            static let lastNameLabel: String = "Last Name"
            static let emailLabel: String = "E-mail"
            static let dateOfBirthLabel: String = "Date of Birth"
            static let locationLabel: String = "Location"
            
            //TODO: Get it from the model:
            static let firstName: String = "Andy"
            static let lastName: String = "Lexsian"
            static let email: String = "Andylexian22@gmail.com"
            static let dateOfBirth: String = "24 february 1996"
            static let location: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        }
        
        enum Constraints {
            static let stackViewSpacing: CGFloat = 16
            static let stackViewOffsetInset: CGFloat = 24
            static let textFieldHeight: CGFloat = 82
            static let locationTextViewHeight: CGFloat = 162
            static let saveButtonHeight: CGFloat = 56
            static let photoSize: CGFloat = 100
        }
    }
}
