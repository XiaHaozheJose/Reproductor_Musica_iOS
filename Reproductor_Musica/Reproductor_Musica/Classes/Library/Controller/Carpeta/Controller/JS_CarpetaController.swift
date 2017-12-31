//
//  JS_CarpetaController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/29.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

fileprivate let identifier = "carpetaCell"

class JS_CarpetaController: UITableViewController {

    var files: [String]?{
        didSet{
            tableView.reloadData()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        if let fileNames = files {
            cell?.textLabel?.text = fileNames[indexPath.row]
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        JS_FileManager.shared.removeDirectory(directoryPath: "".documentDir()+files![indexPath.row]) { (isSuccess: Bool) in
            if isSuccess{
                setData()
            }
        }
    }
    
    private func setData(){
        JS_FileManager.shared.getAllDirectory(path: "".documentDir()) { (filePath: [String]) in
            self.files = filePath
        }
    }
 
}


