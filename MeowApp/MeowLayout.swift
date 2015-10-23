//
//  MeowLayout.swift
//  MeowApp
//
//  Created by Camilo Vera Bezmalinovic on 10/21/15.
//  Copyright © 2015 Camilo Vera Bezmalinovic. All rights reserved.
//

import Foundation
import UIKit

enum MeowLayoutDeleteDirection {
    case None
    case Right
    case Left
}

class MeowLayout: UICollectionViewLayout {

    var deleteDirection = MeowLayoutDeleteDirection.None
    var itemInsets      = UIEdgeInsets(top: 20, left: 20, bottom: 240, right: 20)
    
    private var _itemsToDisplay = 5
    var itemsToDisplay: Int {
        set {
            _itemsToDisplay = min(newValue,count)
        }
        get {
            _itemsToDisplay = min(_itemsToDisplay,count)
            return _itemsToDisplay
        }
    }

    private var cellLayoutAttributes: [NSIndexPath:UICollectionViewLayoutAttributes] = [:]
    
    //convenient forwarding
    var count : Int {
        return collectionView?.numberOfItemsInSection(0) ?? 0
    }
    var bounds: CGRect {
        return collectionView?.bounds ?? CGRectZero
    }
    
    var itemSize : CGSize {
        return  UIEdgeInsetsInsetRect(bounds, itemInsets).size
    }
    
    override func prepareLayout() {
        //create the setup for the views here..
        for i in 0..<count {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            cellLayoutAttributes[indexPath] = customLayoutAttributesForItemAtIndexPath(indexPath)!
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return bounds.size
    }
    
    func customLayoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let scale      = 1.0 - CGFloat(indexPath.item)*0.01
        let transform  = CATransform3DMakeScale(scale, scale, 1)
        var frame      = UIEdgeInsetsInsetRect(bounds, itemInsets)
        frame.origin.y += 5.0*CGFloat(indexPath.item)
        //force the zIndex.. it doesn't work all the times..
        attributes.zIndex      = count - indexPath.item
        print("index: \(indexPath.item) z: \(attributes.zIndex)")
        attributes.transform3D = CATransform3DTranslate(transform, 0, 0, CGFloat(attributes.zIndex))
        attributes.alpha       = 1.0 - CGFloat(indexPath.item)/CGFloat(itemsToDisplay + 1)
        attributes.frame       = frame
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cellLayoutAttributes[indexPath]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellLayoutAttributes.filter{ $0.0.item <  itemsToDisplay }.map{ $0.1 }
        //return cellLayoutAttributes.filter{ CGRectIntersectsRect($0.1.frame, rect) }.map{ $0.1 }
    }
    
    var deleteIndexPaths : [NSIndexPath]?
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        deleteIndexPaths = updateItems.filter { $0.updateAction == .Delete }.map{ $0.indexPathBeforeUpdate }
    }
    override func finalizeCollectionViewUpdates() {
        deleteIndexPaths = nil
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let deleteIndexPaths = deleteIndexPaths where deleteIndexPaths.contains(itemIndexPath) {
            let attributes = customLayoutAttributesForItemAtIndexPath(itemIndexPath)!
            let center     = attributes.center
            var transform  = CATransform3DMakeTranslation(0, 0,  CGFloat(attributes.zIndex))
            
            switch deleteDirection {
            case .Right:
                attributes.center = CGPoint(x: center.x + 400, y: center.y - 100)
                transform = CATransform3DRotate(transform, CGFloat(M_PI_4), 0, 0, 1)
                break
            case .Left:
                attributes.center = CGPoint(x: center.x - 400, y: center.y - 100)
                transform = CATransform3DRotate(transform, -CGFloat(M_PI_4), 0, 0, 1)
                break
            default:
                attributes.center = center
                break
            }
            attributes.alpha       = 0.0
            attributes.transform3D = transform
            return attributes
        }
        
        return super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
    }
    
}