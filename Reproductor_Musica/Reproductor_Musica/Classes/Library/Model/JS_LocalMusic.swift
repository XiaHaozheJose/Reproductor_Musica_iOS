//
//  JS_LocalMusic.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/18.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_LocalMusic: NSObject {

   @objc var music: String = ""
   @objc var autor: String = ""
   @objc var filePath: String = ""
    
    
    init(dict:  [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
}
