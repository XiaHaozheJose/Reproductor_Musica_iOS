//
//  JS_SongsHeaderView.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/27.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_SongsHeaderView: UIView {

    
    
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var otherMessage: UILabel!
    @IBOutlet weak var autor: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        albumImage.layer.cornerRadius = 5
        albumImage.layer.masksToBounds = true
    }

}
