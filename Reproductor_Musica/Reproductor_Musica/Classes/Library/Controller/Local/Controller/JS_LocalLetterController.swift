//
//  JS_LocalLetterController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/17.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import  AVFoundation
fileprivate let identifier = "letterCell"
class JS_LocalLetterController: UITableViewController {

    fileprivate var localMusics: [JS_LocalMusic]?{
        didSet{
            tableView.reloadData()
            var items: [String] = [String]()
            for file in localMusics!{
                items.append(file.filePath)
            }
            player.musicItems = items
        }
    }
    fileprivate var previousCell: JS_LocalLetterCell?

    fileprivate var mainTabBarController: JS_MainTabBarController!
    
    lazy var player: JS_AVPlayer = {
        let play = JS_AVPlayer.shared
        play.delegate = self
        return play
    }()
    
    fileprivate var isCallBack: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       mainTabBarController = self.tabBarController.customMirror.children.first?.value as! JS_MainTabBarController
        
        //添加CollctionView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        inicialTableView()
        let manager = JS_FileManager.shared
            manager.getAllSongs(directoryPath: "".documentDir()) { (localMusics) in
            self.localMusics = localMusics
        }
    }
    
    
    
}


// MARK: - UI
extension JS_LocalLetterController{
    fileprivate func inicialTableView(){
        tableView.rowHeight = 49
        let imageView = UIImageView(frame: kScreen)
        imageView.image = #imageLiteral(resourceName: "localbackground")
        tableView.backgroundView = imageView
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "JS_LocalLetterCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
}


// MARK: - UITableViewDataSource
extension JS_LocalLetterController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localMusics?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! JS_LocalLetterCell
       
        if let musics = localMusics{
            cell.localMusic = musics[indexPath.row]
        }
        return cell
    }
}



// MARK: - UITableViewDelegate
extension JS_LocalLetterController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! JS_LocalLetterCell
        guard let model = localMusics?[indexPath.row] else {return}
        
        gestionCellAnimation(cell: cell)
        gestionPlayBar(model: model)
       
        player.startPlay(item: URL(fileURLWithPath: model.filePath), index: indexPath.row) { [weak self] (row: Int) in
            let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as! JS_LocalLetterCell
            guard let model = self?.localMusics?[row] else {return}
            self?.gestionCellAnimation(cell: cell)
            self?.gestionPlayBar(model: model)
        }
        
    }
    
    private func gestionCellAnimation(cell: JS_LocalLetterCell){
        if previousCell != nil {
            previousCell!.removeAnimation()
        }
        previousCell = cell
        cell.playAnimation()
    }
    
    private func gestionPlayBar(model: JS_LocalMusic){
        mainTabBarController.playTool.localMusic = model
        mainTabBarController.isHidden = false
    }
}

extension JS_LocalLetterController: JS_AudioPlayerDelegate{
    func audioPlayerState(isPlaying: Bool) {
        if isPlaying == true {
            previousCell?.repleLayer.resumeAnimation()
        }else{
            previousCell?.repleLayer.pauseAnimation()
        }
    }
}


