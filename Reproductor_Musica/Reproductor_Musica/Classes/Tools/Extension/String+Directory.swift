//
//  String+Directory.swift
//  WB
//
//  Created by 浩哲 夏 on 2017/1/11.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

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
