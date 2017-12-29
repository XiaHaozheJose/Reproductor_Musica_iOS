//
//  JS_SongsWithAlbum.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/27.
//  Copyright © 2017年 浩哲 夏. All rights reserved.

import UIKit
import MediaPlayer

fileprivate let identifier = "songsCell"
fileprivate let headerHeight: CGFloat = (kScreenWidth - (CGFloat(2) + 1) * margin) / CGFloat(2) + (margin * 2)

class JS_SongsWithAlbum: UIViewController {

    var album: MPMediaItemCollection?{
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate let tableView: UITableView = {
        let tab = UITableView(frame:CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - sistemBottomHeight - sistemTopHeight))
        tab.register(UINib(nibName: "JS_SongsCell", bundle: nil), forCellReuseIdentifier: identifier)
        return tab
    }()
    
    lazy var headerView: JS_SongsHeaderView = {
        let header = Bundle.main.loadNibNamed("JS_SongsHeaderView", owner: nil, options: nil)?.first as! JS_SongsHeaderView
        header.frame.size.height = headerHeight
        return header
    }()
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


// MARK: - UI
extension JS_SongsWithAlbum{
    fileprivate func setUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
        
    }
}



// MARK: - UITableViewDelegate
extension JS_SongsWithAlbum: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isMusiciTunes = true
        JS_SistemMusicPlayer.shared.startPlayMusic(items: album!.items, index: indexPath.row) { (item) in
            JS_LibraryController.mainTabBarController.playTool.localMusic = JS_LocalMusic(dict:([MUSIC: item.title!, AUTOR: item.artist!, ExistImage: true]) as [String: AnyObject])
            JS_LibraryController.mainTabBarController.playTool.musicImage = item.artwork?.image(at: JS_LibraryController.mainTabBarController.playTool.musicIcon.frame.size)
        }
        showPlayBar()
        
    }
    
    private func showPlayBar(){
        JS_LibraryController.mainTabBarController.isHidden = false
        isMusiciTunes = true
    }

    
}


// MARK: - UITableViewDataSource
extension JS_SongsWithAlbum: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! JS_SongsCell
        if let item = album?.items[indexPath.row] {
            cell.item = item
            cell.index.text = "\(indexPath.row + 1)"
        }
        return cell
    }
}


// MARK: - Notification
extension JS_SongsWithAlbum{

    
}



