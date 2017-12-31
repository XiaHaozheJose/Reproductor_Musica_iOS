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
    
    
    fileprivate var isLoaded: Bool = false
    
    fileprivate var localMusics: [JS_LocalMusic]?{
        didSet{
            tableView.reloadData()
        }
    }
    fileprivate var previousCell: JS_LocalLetterCell?
    
    fileprivate lazy var player: JS_AVPlayer = {
        let play = JS_AVPlayer.shared
        play.delegate = self
        return play
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加CollctionView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        inicialTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(isClickedMusic), name: notificationClickedMusic, object: nil)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isLoaded = false
    }
    
   @objc private func isClickedMusic(){
    if previousCell != nil {
        previousCell?.removeAnimation()
    }}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    fileprivate func getData(){
        let manager = JS_FileManager.shared
        manager.getAllSongs(directoryPath: "".documentDir()) { (localMusics) in
            self.localMusics = localMusics
        }
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
        isMusiciTunes = false
        gestionCellAnimation(cell: cell)
        gestionPlayBar(model: model)
        addHistoryMusics(objet: model)
        player.startPlay(item: URL(fileURLWithPath: model.filePath), index: indexPath.row, localMusics: localMusics!) { [weak self] (row: Int) in
            let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as! JS_LocalLetterCell
            guard let model = self?.localMusics?[row] else {return}
            self?.gestionCellAnimation(cell: cell)
            self?.gestionPlayBar(model: model)
            self?.addHistoryMusics(objet: model)
        }
        if !isLoaded {
            loadMusicToPlayer()
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
        JS_LibraryController.mainTabBarController.playTool.localMusic = model
        JS_LibraryController.mainTabBarController.isHidden = false
    }
    
    private func addHistoryMusics(objet: JS_LocalMusic){
        
        let data = UserDefaults.standard.value(forKey: khistoryMusic) as? Data
        
        if let musicData = data {
            let musicArray = NSKeyedUnarchiver.unarchiveObject(with: musicData) as? [JS_LocalMusic]
            
            if var musics = musicArray {
                for music in musics{
                    if music.filePath == objet.filePath{
                        return
                    }
                }
                musics.insert(objet, at: 0)
                if musics.count > 10 {
                    musics.removeLast()
                }
                UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: musics), forKeyPath: khistoryMusic)
                
            }
        }else{
            for music in historyMusics{
                if music.filePath == objet.filePath{
                    return
                }
            }
            historyMusics.insert(objet, at: 0)
            if historyMusics.count > 10 {
                historyMusics.removeLast()
            }
            UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: historyMusics), forKeyPath: khistoryMusic)
            
        }
        
        
      
    }
    
    private func loadMusicToPlayer(){
        var items: [String] = [String]()
        for file in localMusics!{
            items.append(file.filePath)
        }
        player.musicItems = items
        isLoaded = true
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


