//
//  JS_UserDefaults.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/23.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import Foundation

extension UserDefaults{
    func saveCustomObject(customObject object: Data, key: String) {
        self.set(data, forKey: key)
        self.synchronize()
    }
    
    func getCustomObject(forKey key: String) -> Any? {
        
        let decodedObject = self.object(forKey: key) as? Data
        if let decoded = decodedObject {
            let object = NSKeyedUnarchiver.unarchiveObject(with: decoded as Data)
            return object
        }
        
        return nil
    }
}
