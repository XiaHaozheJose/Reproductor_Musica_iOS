//
//  JS_LibraryCell.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/17.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_LibraryCell: UICollectionViewCell {

    
    
    @IBOutlet weak var music: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var musicIcon: UIImageView!
    var localMusic: JS_LocalMusic?{
        didSet{
            music.text = localMusic?.music
            autor.text = localMusic?.autor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        musicIcon.layer.cornerRadius = 20
        musicIcon.layer.masksToBounds = true
        // Initialization code
    }

}
