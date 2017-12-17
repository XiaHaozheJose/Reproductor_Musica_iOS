//
//  JS_TopTableHeader.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/17.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_TopTableHeader: UIView {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var edit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("load topHeader")
    }

}
