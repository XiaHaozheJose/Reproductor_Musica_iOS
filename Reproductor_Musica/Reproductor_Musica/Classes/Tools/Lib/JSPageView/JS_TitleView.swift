//
//  JS_TitleView.swift
//  pageView


import UIKit

// 协议
protocol JS_TitleViewDelegate : class {
    func titleView(titleView:JS_TitleView,targetIndex:Int)
}

fileprivate let kScreenW = UIScreen.main.bounds.width
class JS_TitleView: UIView {
    // MARK: - 属性
    weak var delegate : JS_TitleViewDelegate?
    fileprivate var titles : [String]
    fileprivate var style : JS_PageStyle
    fileprivate var currentIndex = 0
    // 存放标题Label的数组
    fileprivate lazy  var labels : [UILabel] = [UILabel]()
    // ScrollView
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollview : UIScrollView = UIScrollView(frame: self.bounds)
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.scrollsToTop = false
        scrollview.bounces = false
        return scrollview
    }()
    // 普通状态RGB
    fileprivate lazy var normalRGB : (CGFloat,CGFloat,CGFloat) = self.style.titleNolmalColor.getRGBWithColor()
    // 选中RGB
    fileprivate lazy var selectRGB : (CGFloat,CGFloat,CGFloat) = self.style.titleSelectedColor.getRGBWithColor()
    // RGB 颜色差值
    fileprivate lazy var disRGB : (CGFloat,CGFloat,CGFloat) = {
        let disR = self.normalRGB.0 - self.selectRGB.0
        let disG = self.normalRGB.1 - self.selectRGB.1
        let disB = self.normalRGB.2 - self.selectRGB.2
        return (disR,disG,disB)
    }()
    // bottomLine
    fileprivate lazy var bottomLine : UIView = {
        let line = UIView()
        line.backgroundColor = self.style.bottomLineColor
        return line
    }()
    // cover遮盖
    fileprivate lazy var coverView : UIView = {
        let cover = UIView()
        cover.backgroundColor = self.style.coverColor
        cover.alpha = self.style.coverAlpha
        cover.isUserInteractionEnabled = false
        return cover
    }()
    
    /*-----------------------------分割线----------------------------- */
    
    // MARK: - 构造函数
    init(frame: CGRect,titles:[String],style:JS_PageStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI
extension JS_TitleView{
    fileprivate func setupUI(){
        //添加scrollView
        addSubview(scrollView)
        //初始化titleLabel
        setupTitleLabel()
        //初始化底部line
        if style.isShowBottomLine { setupBottomLine() }
        //设置遮盖
        if style.isShowCover { setupCover() }
    }
    /* 设置Cover */
    private func setupCover(){
        guard  let firstLabel = labels.first else { return }
        let coverW = style.isScrollEnable ? firstLabel.frame.width + style.coverPadding
            : firstLabel.frame.width - style.coverPadding
        let coverH = style.coverHeight
        let coverX = style.isScrollEnable ? firstLabel.frame.origin.x : 0 + style.coverPadding
        let coverY = (firstLabel.frame.height - style.coverHeight) * 0.5
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        coverView.center = labels.first!.center
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
        scrollView.addSubview(coverView)
    }
    
    /* 设置底部Line */
    private func setupBottomLine(){
        bottomLine.frame = labels.first!.frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = style.titleHeight - style.bottomLineHeight
        scrollView.addSubview(bottomLine)
    }
    
    /* 设置TitleLabe */
    private func setupTitleLabel(){
        
        for (i,title) in titles.enumerated(){
            let titleLabel = UILabel()
            //设置Label属性
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ?
                style.titleSelectedColor:
                style.titleNolmalColor
            titleLabel.font = style.titleFont
            
            //添加titleLabel到scrollView
            scrollView.addSubview(titleLabel)
            //给Label添加手势
            let tapGes = UITapGestureRecognizer(target: self,
                                                action:#selector(clickTitleLabel(tap:)))
            titleLabel.addGestureRecognizer(tapGes)
            labels.append(titleLabel)
        }
        
        //设置LabelFrame
        let labelH : CGFloat = style.titleHeight
        let labelY : CGFloat = 0
        var labelW : CGFloat = bounds.width / CGFloat(titles.count)
        var labelX : CGFloat = 0
        for (i,label)in labels.enumerated(){
            //如果需要滚动
            if style.isScrollEnable  {
                labelW = (label.text! as NSString).boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: 0), options:.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : style.titleFont], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (labels[i-1].frame.maxX) + style.titleMargin
                //不需要滚动
            } else{ labelX = labelW * CGFloat(i) }
            //给label赋值,并且开始交互
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            label.isUserInteractionEnabled = true
        }
        
        //设置ScrollView ContentSize
        if style.isScrollEnable {
            scrollView.contentSize = CGSize(width:labels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
        
        //设置缩放
        if style.isNeedScale{
            labels.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
    }
}
// MARK: - 监听方法
extension JS_TitleView:UIGestureRecognizerDelegate{
    @objc fileprivate func clickTitleLabel(tap:UITapGestureRecognizer){
        //校验是否点中
        guard let targetLabel = tap.view as? UILabel else { return }
        //校验是否重复点击
        guard targetLabel.tag != currentIndex else { return  }
        
        //通知代理
        delegate?.titleView(titleView: self, targetIndex: targetLabel.tag)
        
        justTitlePosition(targetLabel: targetLabel)
        
    }
    
    //调整点击Label的位置 处于Center
    fileprivate func offsetToCenter(targetLabel:UILabel){
        guard style.isScrollEnable else { return }
        var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
    //切换Title位置
    fileprivate func justTitlePosition(targetLabel:UILabel){
        //让点击Label选中
        let sourceLabel = labels[currentIndex]
        sourceLabel.textColor = style.titleNolmalColor
        targetLabel.textColor = style.titleSelectedColor
        //改变当前index
        currentIndex = targetLabel.tag
        offsetToCenter(targetLabel: targetLabel)
        
        
        //调整label缩放{ 必须先缩放,labelFrame 会改变 }
        if style.isNeedScale {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        //调整bottomLine 位置 { 必须放在缩放之后 }
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
        //调整coverView 位置
        if style.isShowCover {
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.origin.x =  self.style.isScrollEnable ?
                    targetLabel.frame.origin.x - self.style.coverPadding * 0.5 :
                    targetLabel.frame.origin.x + self.style.coverPadding * 0.5
                self.coverView.frame.size.width = self.style.isScrollEnable ?
                    targetLabel.frame.width + self.style.coverPadding :
                    targetLabel.frame.width - self.style.coverPadding
            })
        }
    }
    
}

// MARK: - 暴漏的通用方法
extension JS_TitleView{
    func titleView(targetIndex:Int){
        let targetLabel = labels[targetIndex]
        justTitlePosition(targetLabel: targetLabel)
    }
}


// MARK: - 滚动ContentView 代理
extension JS_TitleView : JS_ContentDelegate{
    //滑动结束
    func contentView(contentView: JS_ContentView, didEndScroll index: Int) {
        
        currentIndex = index
        let targetLabel = labels[index]
        offsetToCenter(targetLabel: targetLabel)
        _ = labels.map{
            if ($0 != labels[index]){
                $0.textColor = style.titleNolmalColor
            }
        }
    }
    
    //颜色渐变,bottomLine
    func contentView(contentView: JS_ContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        let targetLabel = labels[targetIndex]
        let sourceLabel = labels[sourceIndex]
        
        sourceLabel.textColor = UIColor(r: selectRGB.0 + disRGB.0 * progress, g:  selectRGB.1 + disRGB.1 * progress, b:  selectRGB.2 + disRGB.2 * progress, alpha: 1.0)
        targetLabel.textColor = UIColor(r: normalRGB.0 - disRGB.0 * progress, g: normalRGB.1 - disRGB.1 * progress, b: normalRGB.2 - disRGB.2 * progress, alpha: 1.0)
        
        // 缩放渐变 { 先缩放 }
        if style.isNeedScale {
            let deltaScale = (style.maxScale - 1.0) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: style.maxScale - deltaScale, y: style.maxScale - deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScale, y: 1.0 + deltaScale)
        }
        
        // bottomLine 渐变 { 后该bottomLine }
        let deltaWidh = targetLabel.frame.width - sourceLabel.frame.width
        let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaWidh * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
        }
        
        // coverView渐变
        if style.isShowCover {
            coverView.frame.origin.x = style.isScrollEnable ?
                (sourceLabel.frame.origin.x - style.coverPadding * 0.5) + deltaX * progress :
                (sourceLabel.frame.origin.x + style.coverPadding * 0.5) + deltaX * progress
            coverView.frame.size.width = style.isScrollEnable ?
                (sourceLabel.frame.width + style.coverPadding) + deltaWidh * progress :
                (sourceLabel.frame.width - style.coverPadding) + deltaWidh * progress
        }
        
        
        
    }
}


