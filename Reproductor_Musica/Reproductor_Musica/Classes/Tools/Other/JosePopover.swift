//
//  JosePopover.swift
//  QQMusic
//
//  Created by 浩哲 夏 on 2017/3/23.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JosePopover: NSObject {
    var isPresented : Bool = false
    var isSelected:((_ : Bool)->())?
    init(callBack : @escaping (_ presented : Bool)->()) {
        self.isSelected = callBack
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate
extension JosePopover:UIViewControllerTransitioningDelegate{
    ///自定义弹出View
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return JosePresentationView(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        if let selected = isSelected{
            selected(isPresented)
        }
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        if let selected = isSelected{
            selected(isPresented)
        }
        return self
    }
    
}


extension JosePopover:UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext):animationForDismissedView(transitionContext)
    }
    
    func animationForPresentedView(_ transitionContext : UIViewControllerContextTransitioning ){
        //获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //将弹出的View 添加到containerView上
        transitionContext.containerView.addSubview(presentedView)
       
        //执行动画present
        presentedView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        presentedView.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.transform = CGAffineTransform.identity
            presentedView.alpha = 1
        }, completion: { (true) in
            transitionContext.completeTransition(true)
        })
    }
    
    /// DissMiss
    func animationForDismissedView(_ transitionContext : UIViewControllerContextTransitioning ){
    let dissMissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dissMissView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            dissMissView.alpha = 0
        }, completion: { (true) in
            dissMissView.removeFromSuperview()
            dissMissView.alpha = 1
            transitionContext.completeTransition(true)
        })
        
    }
 
    
}
