//
//  AvatarView.swift
//  Moviemax
//
//  Created by Volchanka on 01.04.2025.
//

import UIKit

final class AvatarView: UIView {
    // MARK: Properties
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
        pencilImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.pencilSize)
            $0.bottom.right.equalTo(photoImageView)
        }
    }
}

//MARK: - Constants
private extension AvatarView {
    enum Constants {
        static let pencilSize: CGFloat = 32
    }
}
