//
//  ProfileView.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import UIKit

final class ProfileView: UIView {

    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView(frame: .zero)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = Constants.cornerRadius
        return photoImageView
    }()
    
    
    private lazy var pencilImageView: UIImageView = {
        let imageview = UIImageView(frame: .zero)
        imageview.image = UIImage(named: Constants.pencilImageName)
        return imageview
    }()
    
    init(photoImage: UIImage, isEditable: Bool) {
        super.init(frame: .zero)
        setupUI(photoImage: photoImage, isEditable: isEditable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Private methods
private extension ProfileView {
    
    func setupUI(photoImage: UIImage, isEditable: Bool) {
        photoImageView.image = photoImage
        addSubview(photoImageView)
        
        if isEditable {
            addSubview(pencilImageView)
            pencilImageView.snp.makeConstraints { make in
                make.height.equalTo(Constants.pencilHeight)
                make.width.equalTo(Constants.pencilWidth)
                make.bottom.equalTo(photoImageView)
                make.right.equalTo(photoImageView)
            }
        }
                
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.photoWidth)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.height.equalTo(Constants.photoHeight)
            make.width.equalTo(Constants.photoWidth)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

//MARK: - Constants
private extension ProfileView {
    enum Constants {
        static let photoWidth: CGFloat = 100
        static let photoHeight: CGFloat = 100
        static let pencilWidth: CGFloat = 32
        static let pencilHeight: CGFloat = 32
        static let cornerRadius: CGFloat = photoWidth / 2
        static let pencilImageName: String = "pencil"
    }
}
