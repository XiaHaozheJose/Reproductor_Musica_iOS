//
//  JS_LibraryController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/16.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
fileprivate let height = topTableRowHeight * topTableRowCount + topTableHeaderHeight
fileprivate let cols = 2
fileprivate let identifier: String = "itemCell"
fileprivate let identifierTopCell: String = "topCell"
fileprivate let sectionHeader: String = "sectionHeader"
fileprivate let itemWidth: CGFloat = (kScreenWidth - (CGFloat(cols) + 1) * margin) / CGFloat(cols)
fileprivate let itemHeight: CGFloat = itemWidth * 4.5 / 3
fileprivate let headerHeight: CGFloat = 35

class JS_LibraryController: UIViewController{
    
    
    
    
    static var mainTabBarController: JS_MainTabBarController!
    
    fileprivate var isLoaded: Bool = false
    fileprivate var flowLayout: UICollectionViewFlowLayout?
    
    /// music datas
    fileprivate var localMusics: [JS_LocalMusic]?{
        didSet{
            collection.reloadData()
        }
    }

    //CollectionView
    fileprivate lazy var collection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        self.flowLayout = flowLayout

        /*
         FlowLayout
         */
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.headerReferenceSize = CGSize(width: kScreenWidth, height: headerHeight)
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin)
        flowLayout.scrollDirection = .vertical
        
        /*
         Collection
         */
        let collection: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collection.backgroundColor = .white
        collection.showsVerticalScrollIndicator = false
        collection.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collection.contentInset.bottom = playBarHeight
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(UINib.init(nibName: "JS_LibraryCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        collection.register(UINib.init(nibName: "JS_LibraryReusableHeader", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeader)
        return collection
    }()
    
    lazy var localView: JS_LocalViewController = {
        let vc = JS_LocalViewController()
        vc.view.frame = self.view.bounds
        return vc
    }()
    
    fileprivate var topView: JS_TopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JS_LibraryController.mainTabBarController = self.tabBarController.customMirror.children.first?.value as! JS_MainTabBarController
        
        self.view.backgroundColor = .white
        setCollectionView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        view.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        localMusics = getHistoryMusics()
    }
    
}


// MARK: - UI
extension JS_LibraryController{
  
    fileprivate func setCollectionView(){
        collection.contentInset.top = height + margin
        view.addSubview(collection)
        let topFrame = CGRect(x: 0, y: -( height + margin), width: collection.bounds.width, height:height)
        topView = JS_TopView(frame: topFrame, menus: ["Local Music","iTunes","Dropbox"],withHeader: true)
        topView.delegate = self
        collection.addSubview(topView)
        topView.setTopTitle(Title: "Library", Edit: "Edit")
    }
    
    fileprivate func getHistoryMusics()->[JS_LocalMusic]{
        let data = UserDefaults.standard.value(forKey: khistoryMusic) as? Data
        
        if let musicData = data {
            let musicArray = NSKeyedUnarchiver.unarchiveObject(with: musicData) as? [JS_LocalMusic]
            
            if let musics = musicArray {
                return musics
            }
        }
        return [JS_LocalMusic]()
    }
}


// MARK: - Logico
extension JS_LibraryController{
    
    fileprivate func gestionPlayBar(model: JS_LocalMusic){
        JS_LibraryController.mainTabBarController.isHidden = false
        JS_LibraryController.mainTabBarController.playTool.localMusic = model
    }
    
    
    fileprivate func loadMuicToPlayer(){
        var items: [String] = [String]()
        for file in localMusics!{
            items.append(file.filePath)
        }
        JS_AVPlayer.shared.musicItems = items
    }
}


// MARK: - UICollectionViewDelegate
extension JS_LibraryController: UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let model = localMusics?[indexPath.row] else {return}
        gestionPlayBar(model: model)
       
        JS_AVPlayer.shared.startPlay(item: URL.init(fileURLWithPath: model.filePath), index: indexPath.row, localMusics: localMusics!) { (index) in
            guard let model = self.localMusics?[index] else {return}
            self.gestionPlayBar(model: model)
        }
        if !isLoaded {
            loadMuicToPlayer()
        }
        
        NotificationCenter.default.post(name: notificationClickedMusic, object: nil)
        
    }
}


// MARK: - UICollectionViewDataSource
extension JS_LibraryController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return localMusics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collection.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! JS_LibraryCell
        if let musics = localMusics{
            cell.localMusic = musics[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeader, for: indexPath) as! JS_LibraryReusableHeader
        return header
    }
}


// MARK: - TopViewDelegate
extension JS_LibraryController: TopViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, title: String) {
        
        if title == "iTunes"{
            let vc = JS_ItunesController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        localView.nombre = title
        self.navigationController?.pushViewController(localView, animated: true)
    }
    
}


