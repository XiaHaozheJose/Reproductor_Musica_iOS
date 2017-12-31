//
//  GestionFIleManager.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/17.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

final class JS_FileManager {
    
    static let shared = JS_FileManager()
    private init() {}
    
    let manager = FileManager.default
    
    func getAllSongs(directoryPath: String,finish: @escaping ((_ localMusic: [JS_LocalMusic])->())){
        var localMusics: [JS_LocalMusic] = [JS_LocalMusic]()
        
        var isDirectory: ObjCBool = false
        var isExist: Bool = false
        isExist = manager.fileExists(atPath:directoryPath,isDirectory: &isDirectory)
        if !isExist || !isDirectory.boolValue{
            let exeption: NSException = NSException(name: NSExceptionName(rawValue: "PathError"), reason: "Need a path and Effctive", userInfo: nil)
            exeption.raise()
        }
        
        
        OperationQueue().addOperation {
            guard  let subPaths =  self.manager.subpaths(atPath: directoryPath) else{return}
            if subPaths.count == 0 {return}
            for item in subPaths{
                
                var file = item
                let filePath = directoryPath + item
                if (filePath.contains(".DS")){ continue}
                
                var isDirectory: ObjCBool = false
                
                let isExist = self.manager.fileExists(atPath: filePath, isDirectory: &isDirectory)
                
                if (!isExist || isDirectory.boolValue) {continue}
                
                if (filePath.contains(".mp3")){
                    file.removeLast(4)
                    let split = file.split(separator: "-")
                    
                    let dict = [AUTOR : split.first!.description,
                                MUSIC : split.last!.description,
                                FILEPATH : filePath]
                    
                    let music = JS_LocalMusic(dict: dict as [String : AnyObject])
                    
                    localMusics.append(music)
                }
            }
            OperationQueue.main.addOperation({
                finish(localMusics)
            })
            
        }
    }
    
    func createDirectory(directoryPath: String){
        //        withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
        try? manager.createDirectory(atPath: directoryPath,
                                     withIntermediateDirectories: true, attributes: nil)
    }
    
    func removeDirectory(directoryPath: String, finish: ((_ isSuccess: Bool)->())){
        do {
            try manager.removeItem(atPath: directoryPath)
            finish(true)
        } catch {
            finish(false)
        }
    }
    
    func getAllDirectory(path: String, finish: @escaping ((_ filePath: [String])->())){
        var isDirectory: ObjCBool = false
        var isExist: Bool = false
        isExist = manager.fileExists(atPath:path,isDirectory: &isDirectory)
        if !isExist || !isDirectory.boolValue{
            let exeption: NSException = NSException(name: NSExceptionName(rawValue: "PathError"), reason: "Need a path and Effctive", userInfo: nil)
            exeption.raise()
        }
        DispatchQueue.main.async {
            guard let subPaths = self.manager.subpaths(atPath: path) else{return}
            var files = [String]()
            for item in subPaths {
                var isDirectory: ObjCBool = false
                let isExist = self.manager.fileExists(atPath: path + item, isDirectory: &isDirectory)
                if !isExist || !isDirectory.boolValue{continue}
                files.append(item)
            }
            finish(files)
        }
    }
    
}
