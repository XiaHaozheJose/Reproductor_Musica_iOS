//
//  JS_LocalMusic.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/18.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_LocalMusic: NSObject,NSCoding {
    
    struct PropertyKey {
        static let music = "music"
        static let autor = "autor"
        static let filePath = "filePath"
        static let existImage = "image"
    }
    
    
    
    
    @objc var music: String = ""
    @objc var autor: String = ""
    @objc var filePath: String = ""
    @objc var existImage: Bool = false
    
    
    
    init(dict:  [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(music, forKey: PropertyKey.music)
        aCoder.encode(autor, forKey: PropertyKey.autor)
        aCoder.encode(filePath, forKey: PropertyKey.filePath)
        aCoder.encode(existImage,forKey:PropertyKey.existImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        music = aDecoder.decodeObject(forKey: PropertyKey.music) as! String
        autor = aDecoder.decodeObject(forKey: PropertyKey.autor) as! String
        filePath = aDecoder.decodeObject(forKey: PropertyKey.filePath) as! String
        existImage = aDecoder.decodeBool(forKey: PropertyKey.existImage)
    }
    
}
