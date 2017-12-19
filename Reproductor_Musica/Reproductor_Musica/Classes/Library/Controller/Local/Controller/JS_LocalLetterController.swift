//
//  JS_LocalLetterController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/17.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

fileprivate let identifier = "letterCell"
class JS_LocalLetterController: UITableViewController {

    fileprivate var localMusics: [JS_LocalMusic]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加CollctionView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            // Fallback on earlier versions
        }
             let manager = JS_FileManager.shared
            manager.getAllSongs(directoryPath: "".documentDir()) { (localMusics) in
            self.localMusics = localMusics
        }
    }
}

extension JS_LocalLetterController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localMusics?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        if let musics = localMusics{
            cell?.imageView?.image = #imageLiteral(resourceName: "placeholder")
            cell?.textLabel?.text = musics[indexPath.row].music
            cell?.detailTextLabel?.text = musics[indexPath.row].autor
        }
        return cell!
    }
}
