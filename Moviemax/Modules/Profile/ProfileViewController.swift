//
//  ProfileViewController.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    func setupUserAvatar(data: Data)
    func showEditPhotoView()
    func showAlert(title: String, message: String?)
    func updateUserData(
        firstName: String,
        lastName: String,
        email: String,
        birthDate: String,
        gender: User.Gender,
        notes: String
    )
}

final class ProfileViewController: UIViewController {
    private let presenter: ProfilePresenterProtocol
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var profilePhotoContainerView = UIView()
    private lazy var editPhotoView = EditPhotoView()
    
    private lazy var profilePhotoView = AvatarView(
        photoImage: .profilePlaceholder,
        isEditable: true
    )
    
    private lazy var firstNameTextField = CustomTextEditView(
        labelName: TextConstants.Profile.firstNameLabel.localized(),
        type: .textField
    )
    
    private lazy var lastNameTextField = CustomTextEditView(
        labelName: TextConstants.Profile.lastNameLabel.localized(),
        type: .textField
    )
    
    private lazy var emailTextField = CustomTextEditView(
        labelName: TextConstants.Profile.emailLabel.localized(),
        type: .textField
    )
    
    private lazy var dateOfBirthPicker = DatePickerView(
        labelName: TextConstants.Profile.dateOfBirthLabel.localized()
    )
    
    private lazy var locationTextView = CustomTextEditView(
        labelName: TextConstants.Profile.locationLabel.localized(),
        type: .textView
    )
    
    private lazy var genderSelectorView = GenderSelectorView(selectedGender: .male)
    
    private lazy var saveButton: CommonButton = {
        let button = CommonButton(title: TextConstants.Profile.saveButtonTitle.localized())
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
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
            title: TextConstants.Profile.cancelButtonTitle.localized(),
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
            title: TextConstants.Profile.doneButtonTitle.localized(),
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        toolbar.items = [cancelButton, flexSpace, doneButton]
        return toolbar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .arrowBack), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
        
    //MARK: Init
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        profilePhotoView.delegate = self
        editPhotoView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView(self)
        setupUI()
        setupConstraints()
        presenter.loadUserProfile()
    }
}

// MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {
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
    
    func setupUserAvatar(data: Data) {
        guard let image = UIImage(data: data) else { return }
        profilePhotoView.updatePhoto(image: image)
    }
    
    func showEditPhotoView() {
        setupEditPhotoView()
    }
}

// MARK: - DatePickerViewDelegate
extension ProfileViewController: DatePickerViewDelegate {
    func didTapDatePickerView() {
        datePickerContainer.isHidden = false
    }
}

// MARK: - AvatarViewDelegate
extension ProfileViewController: AvatarViewDelegate {
    func avatarViewDidTapOnPhoto(_ avatarView: AvatarView) {
        presenter.showEditPhotoView()
    }
}

// MARK: - EditPhotoViewDelegate
extension ProfileViewController: EditPhotoViewDelegate {
    func editPhotoViewDidTapTakePhoto(_ view: EditPhotoView) {
        openCamera()
    }
    
    func editPhotoViewDidTapChoosePhoto(_ view: EditPhotoView) {
        choosePhotoFromLibrary()
    }
    
    func editPhotoViewDidTapDeletePhoto(_ view: EditPhotoView) {
        deletePhoto()
    }
    
    func editPhotoViewDidTapCloseView(_ view: EditPhotoView) {
        closePhotoView()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profilePhotoView.updatePhoto(image: selectedImage)
            removeEditPhotoView()
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoLibraryFallback()
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    func choosePhotoFromLibrary() {
        presentPhotoLibraryFallback()
    }
    
    func deletePhoto() {
        profilePhotoView.updatePhoto(image: .profilePlaceholder)
        removeEditPhotoView()
    }
    
    func closePhotoView() {
        removeEditPhotoView()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func presentPhotoLibraryFallback() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}

// MARK: - Private Methods
private extension ProfileViewController {
    func setupUI() {
        navigationItem.title = TextConstants.Profile.screenName.localized()
        view.backgroundColor = .appBackground
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
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
    
    func setupEditPhotoView() {
        view.addSubview(editPhotoView)
        editPhotoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func removeEditPhotoView() {
        editPhotoView.removeFromSuperview()
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview()
        }
        
        profilePhotoContainerView.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        profilePhotoView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        firstNameTextField.snp.makeConstraints {
            $0.height.equalTo(82)
        }
        
        lastNameTextField.snp.makeConstraints {
            $0.height.equalTo(82)
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(82)
        }
        
        dateOfBirthPicker.snp.makeConstraints {
            $0.height.equalTo(82)
        }
        
        genderSelectorView.snp.makeConstraints {
            $0.height.equalTo(82)
        }
        
        locationTextView.snp.makeConstraints {
            $0.height.equalTo(162)
        }
        
        saveButton.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        datePickerContainer.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        datePickerToolbar.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        datePicker.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(datePickerToolbar.snp.bottom)
            $0.bottom.equalToSuperview()
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
            showAlert(title: TextConstants.Profile.errorTitle.localized(), message: TextConstants.Profile.errorEmptyFields.localized())
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
    
    @objc func backButtonTapped() {
        presenter.backButtonTapped()
    }
}
