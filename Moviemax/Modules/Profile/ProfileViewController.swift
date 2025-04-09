//
//  ProfileViewController.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: ProfilePresenter
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var profilePhotoContainerView = UIView()
    
    private lazy var profilePhotoView = AvatarView(
        photoImage: .profilePlaceholder,
        isEditable: true
    )
    
    private lazy var firstNameTextField = CustomTextEditView(
        labelName: Constants.Text.firstNameLabel,
        type: .textField
    )
    
    private lazy var lastNameTextField = CustomTextEditView(
        labelName: Constants.Text.lastNameLabel,
        type: .textField
    )
    
    private lazy var emailTextField = CustomTextEditView(
        labelName: Constants.Text.emailLabel,
        type: .textField
    )
    
    private lazy var dateOfBirthPicker = DatePickerView(
        labelName: Constants.Text.dateOfBirthLabel
    )
    
    private lazy var locationTextView = CustomTextEditView(
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
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    private lazy var datePickerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .appBackground
        view.isHidden = true
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private lazy var datePickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        
        let cancelButton = UIBarButtonItem(
            title: Constants.Text.cancelButtonTitle,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            title: Constants.Text.doneButtonTitle,
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        toolbar.items = [cancelButton, flexSpace, doneButton]
        return toolbar
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadUserProfile()
    }
}

// MARK: - Public Methods
extension ProfileViewController {
    func updateUserData(
        firstName: String,
        lastName: String,
        email: String,
        birthDate: String,
        gender: User.Gender,
        notes: String
    ) {
        firstNameTextField.updateText(firstName)
        lastNameTextField.updateText(lastName)
        emailTextField.updateText(email)
        dateOfBirthPicker.setDateString(birthDate)
        locationTextView.updateText(notes)
        genderSelectorView.selectGender(gender)
        saveButton.isEnabled = true
    }
    
    func updateUserAvatar(data: Data) {
        guard let image = UIImage(data: data) else { return }
        profilePhotoView.updatePhoto(image: image)
    }
}

// MARK: - DatePickerViewDelegate
extension ProfileViewController: DatePickerViewDelegate {
    func didTapDatePickerView() {
        datePickerContainer.isHidden = false
    }
}

// MARK: - Private Methods
private extension ProfileViewController {
    func setupUI() {
        navigationItem.title = Constants.Text.screenName
        view.backgroundColor = .appBackground
        
        view.addSubviews(scrollView, datePickerContainer)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        profilePhotoContainerView.addSubview(profilePhotoView)
        datePickerContainer.addSubviews(datePickerToolbar, datePicker)
        
        stackView.addArrangedSubviews(
            profilePhotoContainerView,
            firstNameTextField,
            lastNameTextField,
            emailTextField,
            dateOfBirthPicker,
            genderSelectorView,
            locationTextView,
            saveButton
        )
        
        dateOfBirthPicker.delegate = self
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
        
        dateOfBirthPicker.snp.makeConstraints { make in
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
        
        datePickerContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        
        datePickerToolbar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        datePicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(datePickerToolbar.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func cancelButtonTapped() {
        datePickerContainer.isHidden = true
    }
    
    @objc func doneButtonTapped() {
        let selectedDate = datePicker.date
        let formattedDate = presenter.formatDateForDisplay(selectedDate)
        
        dateOfBirthPicker.setDateString(formattedDate)
        datePickerContainer.isHidden = true
    }
    
    @objc func saveButtonTapped() {
        let avatarData = profilePhotoView.getPhotoData()
        let birthDate = dateOfBirthPicker.getDateString()
        let gender = genderSelectorView.getSelectedGender()
        
        guard
            let firstName = firstNameTextField.getText(),
            let lastName = lastNameTextField.getText(),
            let email = emailTextField.getText(),
            let notes = locationTextView.getText(),
            !birthDate.isEmpty
        else {
            showAlert(title: Constants.Text.errorTitle, message: Constants.Text.errorEmptyFields)
            return
        }
        
        presenter.saveUserProfile(
            firstName: firstName,
            lastName: lastName,
            email: email,
            birthDate: birthDate,
            gender: gender,
            notes: notes,
            avatarData: avatarData
        )
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
            
            static let errorTitle: String = "Ошибка"
            static let errorEmptyFields: String = "Пожалуйста, заполните все поля"
            
            static let doneButtonTitle: String = "Готово"
            static let cancelButtonTitle: String = "Отмена"
        }
        
        enum Constraints {
            static let stackViewSpacing: CGFloat = 16
            static let stackViewOffsetInset: CGFloat = 24
            static let textFieldHeight: CGFloat = 82
            static let locationTextViewHeight: CGFloat = 162
            static let saveButtonHeight: CGFloat = 56
            static let photoSize: CGFloat = 100
            static let pickerHeight: CGFloat = 216
        }
    }
}
