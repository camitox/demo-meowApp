//
//  MeowCell.swift
//  MeowApp
//
//  Created by Camilo Vera Bezmalinovic on 10/21/15.
//  Copyright © 2015 Camilo Vera Bezmalinovic. All rights reserved.
//

import Foundation
import UIKit

class MeowCell : UICollectionViewCell {
    
    class var identifier: String { return "meow.cell.id" }
    
    weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Create stuff
    private func setup() {
        configContentView()
        createImageView()
    }
    
    private func configContentView() {
        contentView.autoresizingMask   = [.FlexibleWidth, .FlexibleHeight]
        contentView.backgroundColor    = UIColor.meowGreyColor()
        contentView.clipsToBounds      = true
        contentView.layer.cornerRadius = 8
    }
    
    private func createImageView() {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode      = .ScaleAspectFill
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        contentView.addSubview(imageView)
        self.imageView = imageView
    }
}