//
//  ProfileView.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import UIKit

final class ProfileView: UIView {

    // MARK: Properties
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView(frame: .zero)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    
    private lazy var pencilImageView: UIImageView = {
        let imageview = UIImageView(frame: .zero)
        imageview.image = UIImage(named: Constants.pencilImageName)
        return imageview
    }()
    
    // MARK: Init
    init(photoImage: UIImage?, isEditable: Bool) {
        super.init(frame: .zero)
        setupUI(photoImage: photoImage, isEditable: isEditable)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.bounds.width.half
    }
}

//MARK: - Private methods
private extension ProfileView {
    func setupUI(photoImage: UIImage?, isEditable: Bool) {
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
        
        photoImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

//MARK: - Constants
private extension ProfileView {
    enum Constants {
        static let pencilWidth: CGFloat = 32
        static let pencilHeight: CGFloat = 32
        static let pencilImageName: String = "pencil"
    }
}
