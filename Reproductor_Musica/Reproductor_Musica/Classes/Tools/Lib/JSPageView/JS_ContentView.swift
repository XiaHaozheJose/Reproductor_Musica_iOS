//
//  JS_ContentView.swift
//  pageView


import UIKit

protocol JS_ContentDelegate:class {
    func contentView(contentView : JS_ContentView , didEndScroll index : Int)
    func contentView(contentView : JS_ContentView, sourceIndex : Int , targetIndex : Int ,progress : CGFloat)
}

private let kContentCell = "contentCell"
class JS_ContentView: UIView {
    // MARK: - 属性
    fileprivate var sourceIndex = 0
    fileprivate var targetIndex = 0
    weak var delegate : JS_ContentDelegate?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var childsVC : [UIViewController]
    fileprivate var parentVC : UIViewController
    fileprivate var isForbidDelegate : Bool = false
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collection : UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCell)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.bounces = false
        collection.backgroundColor = .white
//        collection.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        return collection
    }()
    
    
    // MARK: - 构造函数
    init(frame: CGRect,childController:[UIViewController],parentController:UIViewController) {
        childsVC = childController
        parentVC = parentController
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK: - 设置UI
extension JS_ContentView{
    fileprivate func setupUI(){
        for child in childsVC{
            parentVC.addChildViewController(child)
        }
        
        addSubview(collectionView)
    }
}

// MARK: - 代理
extension JS_ContentView:UICollectionViewDelegate{
    
    //即将拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.bounds.width * CGFloat(targetIndex)
    }
    //滑动监听
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionWidth = collectionView.bounds.width
        let contentOffsetX = scrollView.contentOffset.x
        if isForbidDelegate { return }
        guard contentOffsetX != startOffsetX  else { return }
        
        let temp = contentOffsetX / collectionWidth
        
        var progress : CGFloat = temp - floor(temp)
        
        if contentOffsetX - startOffsetX >= 0 {//左滑
            sourceIndex = Int(contentOffsetX / collectionWidth)
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childsVC.count {
                targetIndex = childsVC.count - 1
            }
            if contentOffsetX - startOffsetX == collectionWidth {
                progress = 1.0
                targetIndex = sourceIndex
            }
        }else{//右滑
            targetIndex = Int( contentOffsetX / collectionWidth)
            sourceIndex = targetIndex + 1
            progress = 1.0 - progress
            if contentOffsetX / CGFloat(targetIndex) == collectionWidth{
                progress = 1.0
                sourceIndex = targetIndex
            }
        }
        //调用代理 传值
        delegate?.contentView(contentView: self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    //结束减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    //结束拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if scrollView.contentOffset.x < 0{
            return
        }
            if !decelerate {
            let targetIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
            if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.bounds.width {
                if self.targetIndex != targetIndex {
                    scrollViewDidEndScroll()
                }
            }
        }
    }
    private func scrollViewDidEndScroll(){
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentView(contentView: self, didEndScroll: index)
    }
    
}

// MARK: - 数据源
extension JS_ContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childsVC.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        //获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            kContentCell, for: indexPath)
        
        //先将之前的删除
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
        }
        //再添加新的
        let child = childsVC[indexPath.item]
        child.view.frame = self.bounds
        cell.contentView.addSubview(child.view)
        return cell
    }
}
// MARK: - 点击title代理
extension JS_ContentView:JS_TitleViewDelegate{
    func titleView(titleView: JS_TitleView, targetIndex: Int) {
        //禁止代理方法
        isForbidDelegate = true
        //切换CollectionItem
        let index =  IndexPath(item: targetIndex, section: 0)
        collectionView.selectItem(at: index, animated: false, scrollPosition: UICollectionViewScrollPosition.right)
    }
}






