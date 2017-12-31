//
//  JosePresentationView.swift
//  QQMusic
//
//  Created by 浩哲 夏 on 2017/3/23.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit
class JosePresentationView: UIPresentationController {
    
    fileprivate lazy var HudView : UIView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.containerView?.frame = CGRect.init(x:0 ,y: 0, width: kScreenWidth, height: kScreenHeight - 120)
        presentedView?.frame = CGRect.init(x:kScreenWidth * 0.1, y:kScreenHeight * 0.5 - 120, width: kScreenWidth * 0.8, height:kScreenHeight * 0.5)
        setupHudView()
    }
}

extension JosePresentationView{
    func setupHudView(){
        containerView?.insertSubview(HudView, at: 0)
        HudView.frame = containerView!.bounds
        HudView.backgroundColor = UIColor.init(white:1, alpha: 0.001)
        // 3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(JosePresentationView.hudViewClick))
        HudView.addGestureRecognizer(tapGes)
    }
}
// MARK:- 事件监听
extension JosePresentationView {
    @objc fileprivate func hudViewClick() {
            self.presentedViewController.dismiss(animated: true, completion: nil)

        
    }
}
