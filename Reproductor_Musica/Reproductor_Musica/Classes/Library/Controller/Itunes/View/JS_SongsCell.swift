//
//  JS_SongsCell.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/27.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import MediaPlayer
class JS_SongsCell: UITableViewCell {

    var item: MPMediaItem?{
        didSet{
            setData()
        }
    }
    
    
    @IBOutlet weak var index: UILabel!
    @IBOutlet weak var titulo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setData(){
        titulo.text = item?.title
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
