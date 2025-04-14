//
//  CarouselFlowLayout.swift
//  Moviemax
//
//  Created by Volchanka on 12.04.2025.
//


import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        scrollDirection = .horizontal
        minimumLineSpacing = Constants.Size.cellSpacing

        let width = Constants.Size.cellWidth
        let height = Constants.Size.cellHeight
        
        itemSize = CGSize(width: width, height: height)
        
        let inset = (collectionView.bounds.width - width) / 2
        sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect),
              let collectionView = collectionView else { return nil }
        
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        
        for attribute in attributes {
            let distance = attribute.center.x - centerX
            let normalized = distance / collectionView.bounds.width
            let scale = 1 - abs(normalized) * 0.2
            let angle = normalized * .pi / 10
            let verticalShift: CGFloat = abs(normalized) * 60
            
            attribute.transform = CGAffineTransform(rotationAngle: angle)
                .scaledBy(x: scale, y: scale)
            
            attribute.center.y = collectionView.bounds.midY + verticalShift
            attribute.zIndex = Int((1 - abs(normalized)) * 10)
        }
        
        return attributes
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let targetRect = CGRect(origin: proposedContentOffset, size: collectionView.bounds.size)
        guard let attributes = super.layoutAttributesForElements(in: targetRect)
        else {
            return proposedContentOffset
        }
        
        let centerX = proposedContentOffset.x + collectionView.bounds.size.width / 2
        let closest = attributes.min(
            by: {
                abs($0.center.x - centerX) < abs($1.center.x - centerX)
            }
        )
        let offsetX = (closest?.center.x ?? 0) - collectionView.bounds.size.width / 2
        
        return CGPoint(x: offsetX, y: proposedContentOffset.y)
    }
}


enum Constants {
    enum Size {
        static let cellWidth: CGFloat = 188
        static let cellHeight: CGFloat = 250
        static let cellSpacing: CGFloat = 20
    }
}
