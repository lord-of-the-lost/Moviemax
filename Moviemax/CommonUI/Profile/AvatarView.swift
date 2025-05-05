//
//  AvatarView.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import UIKit


protocol AvatarViewDelegate: AnyObject {
    func avatarViewDidTapOnPhoto(_ avatarView: AvatarView)
}

final class AvatarView: UIView {
    
    // MARK: Properties
    weak var delegate: AvatarViewDelegate?
    
    private lazy var pencilImageView = UIImageView(image: UIImage(resource: .pencil))
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView(frame: .zero)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    
    // MARK: Init
    init(photoImage: UIImage, isEditable: Bool) {
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
private extension AvatarView {
    func setupUI(photoImage: UIImage, isEditable: Bool) {
        setupPhotoImageView(with: photoImage)
        if isEditable {
            setupPencilImageView()
        }
    }
    
    func setupPhotoImageView(with image: UIImage) {
        photoImageView.image = image
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupPencilImageView() {
        addSubview(pencilImageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
        photoImageView.addGestureRecognizer(tap)
        photoImageView.isUserInteractionEnabled = true
        pencilImageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.bottom.right.equalTo(photoImageView)
        }
    }
    
    @objc
    func didTapPhoto() {
        delegate?.avatarViewDidTapOnPhoto(self)
    }
}

// MARK: - Public methods
extension AvatarView {
    func updatePhoto(image: UIImage) {
        photoImageView.image = image
    }
    
    func getPhotoData() -> Data? {
        guard let image = photoImageView.image else { return nil }
        return image.jpegData(compressionQuality: 0.8)
    }
}
