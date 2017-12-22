//
//  JS_PageView.swift
//  pageView


import UIKit

class JS_PageView: UIView {
    // MARK: - 属性
    var titles : [String]
    var style : JS_PageStyle
    var childController : [UIViewController]
    var parentController : UIViewController
    
    
    
    // MARK: - 构造函数
    init(frame: CGRect,titles:[String],style:JS_PageStyle,childController:[UIViewController],parentController:UIViewController) {
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
extension JS_PageView{
    
    fileprivate func setupUI(){
        //TitleView
        let titleFrame = CGRect(x: 0, y: 0, width:bounds.width, height: style.titleHeight)
        let titleView = JS_TitleView(frame: titleFrame, titles: titles, style: style)
        titleView.layer.contents = #imageLiteral(resourceName: "titlebackground").cgImage
        addSubview(titleView)
        
        //ContentView
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = JS_ContentView(frame: contentFrame, childController: childController, parentController: parentController)
//        contentView.backgroundColor = UIColor.randomColor()
        addSubview(contentView)
        
        //交互
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}





