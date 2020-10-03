//
//  StickerDetailVC.swift
//  GEM-ART
//
//  Created by Truman Tang on 9/27/20.
//  Copyright © 2020 Truman Tang. All rights reserved.
//

import UIKit

class StickerDetailVC: UIViewController {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    var stick: Stickers!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = stick.name
        image.image = UIImage(named: "\(self.stick.Id ?? 1)")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
