//
//  AlbumImageView.swift
//  Animations
//
//  Created by macbookpro on 9/6/15.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

import UIKit

class AlbumImageView: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       imageView.contentMode = UIViewContentMode.ScaleAspectFit
    }

    @IBAction func clickEvent(sender: AnyObject) {
        
        
    }

}
