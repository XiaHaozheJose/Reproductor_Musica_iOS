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


    fileprivate var flowLayout: UICollectionViewFlowLayout?
    fileprivate var localMusics: [JS_LocalMusic]?{
        didSet{
            collection.reloadData()
        }
    }

    lazy var collection: UICollectionView = {
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
        self.view.backgroundColor = .white
        setCollectionView()
        
//        let mirror =  self.tabBarController.customMirror
//        let mianTab =  mirror.children.first?.value as! JS_MainTabBarController

        
        let  filemanager = JS_FileManager.shared
        filemanager.getAllSongs(directoryPath: "".documentDir()) { (localMusics) in
            self.localMusics = localMusics
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}


// MARK: - UI
extension JS_LibraryController{
  
    func setCollectionView(){
        collection.contentInset.top = height + margin
        view.addSubview(collection)
        topView = JS_TopView(frame: CGRect(x: 0, y: -( height + margin), width: collection.bounds.width, height:height))
        topView.delegate = self
        collection.addSubview(topView)
        topView.setTopTitle(Title: "Library", Edit: "Edit")
    }
}


// MARK: - Ligico
extension JS_LocalViewController{
    func getSonsWithDocument(){
    }
}

extension JS_LibraryController: UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}

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


extension JS_LibraryController: TopViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, title: String) {
        localView.nombre = title
        self.navigationController?.pushViewController(localView, animated: true)
    }
    
}

extension JS_LibraryController: UICollectionViewDelegateFlowLayout{
    

}
