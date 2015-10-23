//
//  ViewController.swift
//  MeowApp
//
//  Created by Camilo Vera Bezmalinovic on 10/21/15.
//  Copyright © 2015 Camilo Vera Bezmalinovic. All rights reserved.
//

import UIKit
import AlamofireImage
import JTSImageViewController
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    weak var collectionView: UICollectionView!
    var gridLayout: UICollectionViewFlowLayout!
    var meowLayout =  MeowLayout()
    
    weak var buttonAccept : UIButton?
    weak var buttonReject : UIButton?

    //datasource
    var cats : [NSURL] = []
    
    //MARK: Create Stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDataSource()
        createBarButtonItem()
        createCollectionView()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func fillDataSource() {
        //uses the index to prevent caching only one image..
        cats = (0..<30).map{ NSURL(string: "http://thecatapi.com/api/images/get?format=src&type=jpg&index=\($0)")! }
    }
    
    func createBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mode", style: .Plain, target: self, action: "didPressUpdateItem:")
    }
    
    func createCollectionView() {
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.itemSize                = CGSize(width: 119, height: 119)
        gridLayout.minimumInteritemSpacing = 4
        gridLayout.minimumLineSpacing      = 4
        gridLayout.sectionInset            = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.gridLayout = gridLayout
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: gridLayout)
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.registerClass(MeowCell.self, forCellWithReuseIdentifier: MeowCell.identifier)
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    func roundedButton(centerOffset: CGFloat) -> UIButton {
        let size    : CGFloat = 120
        let margin  : CGFloat = 80
        
        let button = UIButton()
        button.backgroundColor = UIColor.meowGreenColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = size/2
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 22)
        button.alpha = 0.0
        view.addSubview(button)
        
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .Width,   relatedBy: .Equal, toItem: nil,  attribute: .NotAnAttribute, multiplier: 1, constant: size))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .Height,  relatedBy: .Equal, toItem: nil,  attribute: .NotAnAttribute, multiplier: 1, constant: size))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .Bottom,  relatedBy: .Equal, toItem: view, attribute: .Bottom,         multiplier: 1, constant: -margin))
        view.addConstraint(NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX,        multiplier: 1, constant: centerOffset))
        
        return button
        
    }
    func createButtons() {
        
        let buttonAccept = roundedButton(100)
        buttonAccept.setTitle("MEOW!", forState: .Normal)
        buttonAccept.backgroundColor = UIColor.meowGreenColor()
        buttonAccept.addTarget(self, action: "didSelectAcceptButton:", forControlEvents: .TouchUpInside)
        self.buttonAccept = buttonAccept
        
        let buttonReject = roundedButton(-100)
        buttonReject.setTitle("WOOF!", forState: .Normal)
        buttonReject.backgroundColor = UIColor.meowRedColor()
        buttonReject.addTarget(self, action: "didSelectRejectButton:", forControlEvents: .TouchUpInside)
        self.buttonReject = buttonReject
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MeowCell.identifier, forIndexPath: indexPath) as! MeowCell
        cell.imageView.image = nil
        cell.imageView.af_setImageWithURL(cats[indexPath.item])
        return cell
    }
    
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MeowCell
//        
//        let imageInfo = JTSImageInfo()
//        imageInfo.image = cell.imageView.image
//        imageInfo.referenceRect = cell.imageView.frame
//        imageInfo.referenceView = cell.imageView.superview
//        imageInfo.imageURL      = cats[indexPath.item]
//        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .None)
//        imageViewer.showFromViewController(self, transition: .FromOriginalPosition)
//    }
//    
//    //workaround to fix iOS 9 issue, where the layout is not obeying the zIndex property
//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        cell.superview?.sendSubviewToBack(cell)
//    }
    
    
    
    //MARK: Actions
    func didPressUpdateItem(sender:AnyObject?) {
        if collectionView.collectionViewLayout == gridLayout {
            collectionView.setCollectionViewLayout(meowLayout, animated: true)
            if buttonAccept == nil {
                createButtons()
            }
            
            displayButtons(display: true)
        }
        else {
            collectionView.setCollectionViewLayout(gridLayout, animated: true)
            displayButtons(display: false)
        }
        
    }
    
    func displayButtons(display display:Bool) {
        let alpha : CGFloat = display ? 1.0 : 0.0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.buttonAccept?.alpha = alpha
            self.buttonReject?.alpha = alpha
        }
    }
    
    func didSelectAcceptButton(sender:UIButton) {
        meowLayout.deleteDirection = .Right
        removeFirstCat()
    }
    
    func didSelectRejectButton(sender:UIButton) {
        meowLayout.deleteDirection = .Left
        removeFirstCat()
    }
    
    func removeFirstCat() {
        if cats.count > 0 {
            cats.removeFirst()
            collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
        }
    }
    
}

