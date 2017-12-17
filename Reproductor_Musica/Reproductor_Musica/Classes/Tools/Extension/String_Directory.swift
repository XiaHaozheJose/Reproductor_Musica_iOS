//
//  String_Directory.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/17.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import Foundation

extension String{
    
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        return (path?.appending("/\(self)"))!
    }
    
    func documentDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        return (path?.appending("/\(self)"))!
    }
    
    func TmpDir() -> String {
        let path = NSTemporaryDirectory()
        return (path.appending("/\(self)"))
    }
}
