//
//  DynamicHeightFlowLayout.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 25/09/2024.
//

import UIKit

class DynamicHeightFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                let indexPath = layoutAttribute.indexPath
                if let newFrame = layoutAttributesForItem(at: indexPath)?.frame {
                    layoutAttribute.frame = newFrame
                }
            }
        }
        return attributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }

        if let collectionView = collectionView {
            let contentSize = collectionView.bounds.width - sectionInset.left - sectionInset.right
            let targetWidth = contentSize / 2
            let size = sizeForItem(at: indexPath, targetWidth: targetWidth)
            attributes.frame.size = size
        }
        return attributes
    }

    private func sizeForItem(at indexPath: IndexPath, targetWidth: CGFloat) -> CGSize {
        let height: CGFloat = 350
        return CGSize(width: targetWidth, height: height)
    }
}
