//,
//  JS_MainNavigationController.swift
//  Reproductor_Musica
//
//  Created by 浩哲 夏 on 2017/12/16.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_MainNavigationController: UINavigationController,UIGestureRecognizerDelegate {

  

    
    override func viewDidLoad() {
        super.viewDidLoad()
         sistemTopHeight = self.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
  
//               //实现全局滑动PoP 第二中方法
//               let pan = UIPanGestureRecognizer.init(target:interactivePopGestureRecognizer?.delegate, action:"handleNavigationTransition:")
//                view.addGestureRecognizer(pan)
//                pan.delegate = self
//                self.interactivePopGestureRecognizer?.isEnabled = false
//                //触发边缘拖拽返回功能
//                self.interactivePopGestureRecognizer?.delegate = self;
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !(childViewControllers.count > 0) {
            setNavigationBarHidden(true, animated: true)
        }else{
            setNavigationBarHidden(false, animated: true)
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print(gestureRecognizer.delegate.debugDescription)
//        print(childViewControllers.count)
//        return childViewControllers.count == 2 ? false : true
//    }
    

}

