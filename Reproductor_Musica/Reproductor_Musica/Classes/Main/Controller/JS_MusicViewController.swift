//
//  JS_MusicViewController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/23.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
import DeckTransition

class JS_MusicViewController: UIViewController,DeckTransitionViewControllerProtocol {
    
    
    var localMusic: JS_LocalMusic?
  
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: kScreen)
        scroll.delegate = self
        return scroll
    }()
    
   fileprivate lazy var basicView: JS_MusicBasicView = {
        let basic = Bundle.main.loadNibNamed("JS_MusicBasicView", owner: nil, options: nil)?.first as! JS_MusicBasicView
        basic.frame = self.view.bounds
        basic.frame.size.height = kScreenHeight - kStatusBarHeight
        return basic
    }()
    
   fileprivate lazy var selectTypeView: UIView = {
        let typeView = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 64))
        typeView.backgroundColor = .red
        return typeView
    }()
    
   override var preferredStatusBarStyle: UIStatusBarStyle{get { return.lightContent}}
   
  var scrollViewForDeck: UIScrollView{
        get{ return scrollView}
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.modalPresentationCapturesStatusBarAppearance = true
        setUI()
        setData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
   

    
   
    
}

// MARK: - UI
extension JS_MusicViewController{
    fileprivate func setUI(){
        scrollView.addSubview(basicView)
        scrollView.addSubview(selectTypeView)
        scrollView.contentSize.height = scrollView.frame.height + selectTypeView.frame.height
        view.addSubview(scrollView)
    }
    
    fileprivate func setData(){
        if let localMusic = self.localMusic {
            basicView.localMusic = localMusic
        }
    }
    
}



extension JS_MusicViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
    }
}




