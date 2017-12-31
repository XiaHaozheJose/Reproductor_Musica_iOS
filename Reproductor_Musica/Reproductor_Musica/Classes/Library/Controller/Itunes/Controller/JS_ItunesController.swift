//
//  JS_ItunesController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/26.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import MediaPlayer
fileprivate let cols = 2
fileprivate let identifier = "iTunesCell"
fileprivate let itemWidth: CGFloat = (kScreenWidth - (CGFloat(cols) + 1) * margin) / CGFloat(cols)
fileprivate let itemHeight: CGFloat = itemWidth * 4.5 / 3
fileprivate let topHeight: CGFloat = topTableRowHeight
class JS_ItunesController: UIViewController {
    
    //CollectionView
    fileprivate lazy var collection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        /*
         FlowLayout
         */
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = margin
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
        collection.register(UINib.init(nibName: "JS_ItunesCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        return collection
    }()
    
   fileprivate lazy var popover:JosePopover = JosePopover { (isSelected:Bool) in
        
    }

    fileprivate var artists: [MPMediaItemCollection]?{
        didSet{
            collection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if authorize() {
            print("allow Media")
        }
        setUI()
      
        
    }
    
    private func authorize()->Bool{
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            artists = MPMediaQuery.albums().collections
            return true
        case .notDetermined:
            MPMediaLibrary.requestAuthorization({ (libraryStatus) in
                _ = self.authorize()
            })
        default:
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Authorization For Library", message: "Click Setting ,Allow access to your media ", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            let setting = UIAlertAction(title: "Setting", style: .default, handler: { (action) in
                let url = URL.init(string: UIApplicationOpenSettingsURLString)
                if let url = url, UIApplication.shared.canOpenURL(url){
                    if #available(iOS 10, *){
                        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                            
                        })
                    }else{
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            alert.addAction(cancel)
            alert.addAction(setting)
            self.present(alert, animated: true, completion: nil)
            }
        }
        return false
        
    }
    
    

}


// MARK: - UI
extension JS_ItunesController{
    fileprivate func setUI(){
        let topView = JS_TopView(frame: CGRect.init(x: 0, y: -topHeight, width: kScreenWidth, height: topHeight), menus: ["随机播放"], withHeader: false)
        topView.delegate = self
        collection.contentInset.top = topHeight
        collection.addSubview(topView)
        view.addSubview(collection)
    }
}

// MARK: - UICollectionViewDelegate
extension JS_ItunesController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(artists![indexPath.row].persistentID)
        let songs = JS_SongsWithAlbum()
        songs.album = artists![indexPath.row]
        self.navigationController?.pushViewController(songs, animated: true)

    }
}

// MARK: - UICollectionViewDataSource
extension JS_ItunesController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! JS_ItunesCell
        if let items = artists {
            cell.item = items[indexPath.row].items.first
        }
        registerForPreviewing(with: self, sourceView: cell.contentView)
        return cell
    }
}


extension JS_ItunesController: TopViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, title: String) {
        print(title)
    }
    
    
}

extension JS_ItunesController: UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        let indexPath = self.collection.indexPath(for: previewingContext.sourceView.superview as! JS_ItunesCell)
        
        let songsVc = JS_SongsWithAlbum()
        return songsVc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        viewControllerToCommit.modalPresentationStyle = .custom
        viewControllerToCommit.transitioningDelegate = popover
        present(viewControllerToCommit, animated: true, completion: nil)
    }
    
}
