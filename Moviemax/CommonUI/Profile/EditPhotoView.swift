//
//  EditPhotoView.swift
//  Moviemax
//
//  Created by Volchanka on 11.04.2025.
//

import UIKit

protocol EditPhotoViewDelegate: AnyObject {
    func editPhotoViewDidTapTakePhoto(_ view: EditPhotoView)
    func editPhotoViewDidTapChoosePhoto(_ view: EditPhotoView)
    func editPhotoViewDidTapDeletePhoto(_ view: EditPhotoView)
}

final class EditPhotoView: UIView {
    
    //MARK: Properties
    weak var delegate: EditPhotoViewDelegate?
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.title
        label.font = AppFont.plusJakartaSemiBold.withSize(20)
        label.textColor = .adaptiveTextMain
        label.textAlignment = .center
        return label
    }()
    
    private lazy var deviderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var takePhotoButtonView = ButtonView(
        title: Constants.Text.takeTitle,
        color: .adaptiveTextMain,
        icon: .cameraIcon
    )
    
    private lazy var choosePhotoButtonView = ButtonView(
        title: Constants.Text.chooseTitle,
        color: .adaptiveTextMain,
        icon: .folderIcon
    )
    
    private lazy var deletePhotoButtonView = ButtonView(
        title: Constants.Text.deleteTitle,
        color: .red,
        icon: .trashbinIcon
    )
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTapGestures()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Private methods
private extension EditPhotoView {
    func setupUI() {
        addSubview(blurEffectView)
        addSubview(contentView)
        contentView.addSubviews(
            titleLabel,
            deviderView,
            takePhotoButtonView,
            choosePhotoButtonView,
            deletePhotoButtonView
        )
        setupConstraints()
    }
    
    func setupConstraints() {
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(340)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(32)
        }
        
        deviderView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        takePhotoButtonView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(deviderView.snp.bottom).offset(20)
            make.height.equalTo(60)
        }
        
        choosePhotoButtonView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(takePhotoButtonView.snp.bottom).offset(20)
            make.height.equalTo(60)
        }
        
        deletePhotoButtonView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(choosePhotoButtonView.snp.bottom).offset(20)
            make.height.equalTo(60)
        }
    }
    
    func addTapGestures() {
        takePhotoButtonView.isUserInteractionEnabled = true
        choosePhotoButtonView.isUserInteractionEnabled = true
        deletePhotoButtonView.isUserInteractionEnabled = true
        
        takePhotoButtonView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(didTapTakePhoto)
            )
        )
        choosePhotoButtonView
            .addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(didTapChoosePhoto)
                )
            )
        deletePhotoButtonView
            .addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(didTapDeletePhoto)
                )
            )
    }
    
    @objc
    func didTapTakePhoto() {
        delegate?.editPhotoViewDidTapTakePhoto(self)
    }
    
    @objc
    func didTapChoosePhoto() {
        delegate?.editPhotoViewDidTapChoosePhoto(self)
    }
    
    @objc
    func didTapDeletePhoto() {
        delegate?.editPhotoViewDidTapDeletePhoto(self)
    }
}

//MARK: - Constants
private extension EditPhotoView {
    enum Constants {
        enum Text {
            static let title = "Change your picture"
            static let takeTitle = "Take a photo"
            static let chooseTitle = "Choose from your file"
            static let deleteTitle = "Delete Photo"
        }
        enum Constraints {
            
        }
    }
}
