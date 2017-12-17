//
//  JSPageView.swift
//  pageView


import UIKit

class JSPageView: UIView {
    // MARK: - 属性
    var titles : [String]
    var style : JSPageStyle
    var childController : [UIViewController]
    var parentController : UIViewController
    
    
    
// MARK: - 构造函数
    init(frame: CGRect,titles:[String],style:JSPageStyle,childController:[UIViewController],parentController:UIViewController) {
        self.titles = titles
        self.style = style
        self.childController = childController
        self.parentController = parentController
        super.init(frame: frame)
        
        //设置UI<需要在super 之后>
        setupUI()
     }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - 设置UI
extension JSPageView{
    
    fileprivate func setupUI(){
        //TitleView
        let titleFrame = CGRect(x: 0, y: 0, width:bounds.width, height: style.titleHeight)
        let titleView = JSTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        addSubview(titleView)
       
        //ContentView
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = JSContentView(frame: contentFrame, childController: childController, parentController: parentController)
        contentView.backgroundColor = UIColor.randomColor()
        addSubview(contentView)
       
        //交互
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}




