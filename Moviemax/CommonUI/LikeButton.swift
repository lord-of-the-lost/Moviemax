//
//  LikeButton.swift
//  Moviemax
//
//  Created by Николай Игнатов on 02.04.2025.
//

import UIKit

final class LikeButton: UIButton {
    private var isLiked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateImage()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLiked(_ isLiked: Bool) {
        self.isLiked = isLiked
    }
    
    func toggleLike() {
        isLiked.toggle()
    }
}

// MARK: - Private Methods
private extension LikeButton {
    func updateImage() {
        let imageResource: ImageResource = isLiked ?  .heartFilled : .heartEmpty
        let image = UIImage(resource: imageResource)
        setImage(image, for: .normal)
    }
}
