//
//  JS_LocalViewController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/17.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_LocalViewController: UIViewController {

    let titles = ["All Music","Album"]
    
    var childVC = [UIViewController]()
    
    var nombre: String?{
        didSet{
            self.title = nombre
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childVC.append(JS_LocalLetterController())
        childVC.append(JS_LocalAlbumController())
        setBaseView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension JS_LocalViewController{
    
    func setBaseView(){
        // must be Set False
//        self.automaticallyAdjustsScrollViewInsets = false
        var style = JS_PageStyle()
        style.isNeedScale = true
        style.isShowBottomLine = true
        style.titleSelectedColor = .red
        style.bottomLineColor = .red
        let pageFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - sistemTopHeight)
        let pageView = JS_PageView(frame: pageFrame, titles: titles, style: style, childController: childVC, parentController: self)
        view.addSubview(pageView)
    }
}
