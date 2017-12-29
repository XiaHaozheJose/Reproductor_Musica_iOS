//
//  JS_MainTabBarController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/16.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import DeckTransition
class JS_MainTabBarController: UITabBarController {
    
    override func loadView() {
        super.loadView()
        let tab = UITabBarItem.appearance()
        tab.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)], for: .normal)
        tab.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)], for: .selected)
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.isTranslucent = false
    }
    
    fileprivate let childVC = [JS_LibraryController(),JS_FavoriteController(),JS_BrowseController(),JS_RadioController(),JS_SearchController()]
    
    fileprivate lazy var playBar: JS_PlayBar = {
        let bar = Bundle.main.loadNibNamed("JS_PlayBar", owner: nil, options: nil)?.first as! JS_PlayBar
        return bar
    }()
    
    fileprivate lazy var effectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .extraLight)
        let effectView = UIVisualEffectView(effect: blur)
        return effectView
    }()
    
    fileprivate lazy var transitionBackground: UIColor = {
        let color = UIColor.init(patternImage: #imageLiteral(resourceName: "iosBackground"))
        return color
    }()
    
    var playTool: JS_PlayBar!
    
    var isHidden: Bool?{
        didSet{
            effectView.isHidden = isHidden!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChildViewController()
        self.view.backgroundColor = transitionBackground
        setPlayerView()
        sistemBottomHeight = self.tabBar.frame.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


extension JS_MainTabBarController{
    fileprivate func setChildViewController(){
        
        for(index,child) in childVC.enumerated(){
            let navigation = JS_MainNavigationController(rootViewController: child)
            navigation.tabBarItem = UITabBarItem(title: TabTitles[index], image: tabNorImage[index], selectedImage: tabSelecImage[index])
            navigation.view.frame = kScreen
            addChildViewController(navigation)
        }
    }
    
    fileprivate  func setPlayerView(){
        let tabBarHeight = self.tabBar.frame.size.height;
        effectView.frame = CGRect(x: 0, y: kScreenHeight - (tabBarHeight + playBarHeight), width: kScreenWidth, height: playBarHeight)
        playBar.frame = effectView.bounds
        effectView.contentView.addSubview(playBar)
        self.playTool = playBar
        view.addSubview(effectView)
        effectView.isHidden = true
        
        playBar.callback = { (musicView: UIViewController) in
            self.present(musicView, animated: true) {
                if let transition = UIApplication.shared.keyWindow?.subviews[1]{
                    if let subTransition = transition.subviews.first{
                        subTransition.backgroundColor = self.transitionBackground
                    }
                }
            }
        }
    }
    
    
    
    
    
}
