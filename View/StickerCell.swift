//
//  StickerCell.swift
//  GEM-ART
//
//  Created by Truman Tang on 9/13/20.
//  Copyright © 2020 Truman Tang. All rights reserved.
// Cart
// menu - ABOUT US/ CATEGORIES / CONTACT / 
//

import UIKit

class StickerCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var stickers: Stickers!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
func configureCell(stickers: Stickers){
        self.stickers = stickers

    nameLbl.text = self.stickers.name.capitalized
    nameLbl.font = UIFont(name: "Orange Juice", size: 24)
    thumbImg.image = UIImage(named: "\(self.stickers.Id ?? 1)")

    }
    
}
