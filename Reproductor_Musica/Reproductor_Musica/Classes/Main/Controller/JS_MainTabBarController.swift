//
//  JS_MainTabBarController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/16.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_MainTabBarController: UITabBarController {
    
    override func loadView() {
        super.loadView()
        let tab = UITabBarItem.appearance()
        
        tab.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)], for: .normal)
        tab.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)], for: .selected)
        
    }
    
    
    let childVC = [JS_LibraryController(),JS_FavoriteController(),JS_BrowseController(),JS_RadioController(),JS_SearchController()]
    
    lazy var toolBar: JS_PlayBar = {
       let bar = Bundle.main.loadNibNamed("JS_PlayBar", owner: nil, options: nil)?.first as! JS_PlayBar
        return bar
    }()
    
    lazy var effectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .prominent)
        let effectView = UIVisualEffectView(effect: blur)
        return effectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChildViewController()
        setPlayerView()
        sistemBottomHeight = self.tabBar.frame.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
}


extension JS_MainTabBarController{
    func setChildViewController(){
    
        for(index,child) in childVC.enumerated(){
            let navigation = JS_MainNavigationController(rootViewController: child)
            navigation.tabBarItem = UITabBarItem(title: TabTitles[index], image: tabNorImage[index], selectedImage: tabSelecImage[index])
            navigation.view.frame = kScreen
            addChildViewController(navigation)
        }
    }
    
    func setPlayerView(){
        let tabBarHeight = self.tabBar.frame.size.height;

        
        effectView.frame = CGRect(x: 0, y: kScreenHeight - (tabBarHeight + playBarHeight), width: kScreenWidth, height: playBarHeight)
        toolBar.frame = effectView.bounds
        effectView.contentView.addSubview(toolBar)
        view.addSubview(effectView)
        effectView.isHidden = true
    }
    
    
}
