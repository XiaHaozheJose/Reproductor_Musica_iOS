//
//  JS_ItunesCell.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/27.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import MediaPlayer
class JS_ItunesCell: UICollectionViewCell {

    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var autor: UILabel!
   
    var item: MPMediaItem?{
        didSet{
            artist.text = item?.albumTitle
            autor.text = item?.albumArtist
           artistImage.image = item?.artwork?.image(at: artistImage.frame.size)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artistImage.layer.cornerRadius = 5
        artistImage.layer.masksToBounds = true
        
    }

}
