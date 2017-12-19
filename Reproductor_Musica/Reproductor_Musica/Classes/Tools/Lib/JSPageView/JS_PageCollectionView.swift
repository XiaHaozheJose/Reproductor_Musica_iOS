//
//  JS_PageCollectionView.swift
//  pageView
//
//  Created by 浩哲 夏 on 2017/4/14.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//
/*
 (count - 1)/pageCount + 1 >>> 计算总页数
 index / pageCount >>>> 计算在第几页 计算Y
 index % pageCount >>>> 计算X
 */

import UIKit

// MARK: - 数据源协议
protocol JS_PageCollectionViewDataSource:class {
    //组
    func numberOfSectionInPageCollectionView(_ pageCollectionView: JS_PageCollectionView) -> Int
    //每组的item
    func pageCollectionView(_ pageCollectionView: JS_PageCollectionView, numberOfItemsInSection section: Int) -> Int
    //Item样式
    func pageCollectionView(_ pageCollectionView: JS_PageCollectionView,_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}


class JS_PageCollectionView: UIView {
    // MARK: - 属性
    weak var dataSource : JS_PageCollectionViewDataSource?
    fileprivate var titles : [String]
    fileprivate var style : JS_PageStyle
    fileprivate var collectionView : UICollectionView?
    fileprivate var layout : JS_PageFlowLayout
    fileprivate var pageControl : UIPageControl?
    fileprivate var currentIndex = IndexPath(item: 0, section: 0)
    fileprivate var titleView: JS_TitleView?
    // MARK: - 构造函数
    init(frame: CGRect,titles: [String], style: JS_PageStyle, layout: JS_PageFlowLayout) {
        self.titles = titles
        self.style = style
        self.layout = layout
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

// MARK: - 创建UI
extension JS_PageCollectionView {
    fileprivate func setupUI(){
        // 设置TitileView
        let titleY = style.isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        let titleView = JS_TitleView(frame: titleFrame, titles: titles, style: style)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.randomColor()
        self.titleView = titleView
        addSubview(titleView)
        
        //设置CollectionView
        let collectionY = style.isTitleInTop ? style.titleHeight : 0
        let collectionH = bounds.height - style.titleHeight - style.pageControlHeight
        let collectionFrame = CGRect(x: 0, y: collectionY, width: bounds.width, height: collectionH)
        let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        self.collectionView = collectionView
        addSubview(collectionView)
        
        //设置PageControl
        let pageFrame = CGRect(x: 0, y: collectionFrame.maxY, width: bounds.width, height: style.pageControlHeight)
        let pageControl = UIPageControl(frame: pageFrame)
        pageControl.backgroundColor = UIColor.randomColor()
        self.pageControl = pageControl
        addSubview(pageControl)
        
    }
}


// MARK: - 对外暴漏的方法
extension JS_PageCollectionView{
    func register(cellClass: AnyClass?, ReuseIdentifier: String){
        collectionView?.register(cellClass, forCellWithReuseIdentifier: ReuseIdentifier)
    }
    func register(nib: UINib?, ReuseIdentifier: String){
        collectionView?.register(nib, forCellWithReuseIdentifier: ReuseIdentifier)
    }
    func reloadData(){
        collectionView?.reloadData()
    }
}

// MARK: - 系统数据源方法
extension JS_PageCollectionView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionInPageCollectionView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            pageControl?.numberOfPages = (sectionItemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return sectionItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (dataSource?.pageCollectionView(self, collectionView, cellForItemAt: indexPath))!// 只有有值才会进这个方法(可以强转)
    }
}

// MARK: - 系统代理方法
extension JS_PageCollectionView: UICollectionViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            guard let indexPath = collectionView?.indexPathsForVisibleItems.min() else { return }
            scrollViewEndScroll(indexPath: indexPath)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //获取第一个item
        guard let indexPath = collectionView?.indexPathsForVisibleItems.min() else { return }
        scrollViewEndScroll(indexPath: indexPath)
    }
    //滑动结束调用
    fileprivate func scrollViewEndScroll(indexPath: IndexPath){
        //获取最大的item
        guard let maxIndex = collectionView?.indexPathsForVisibleItems.max() else { return }
        if currentIndex.section != maxIndex.section {
            titleView?.titleView(targetIndex: maxIndex.section)
            _ = calculatePageNumber(section: indexPath.section)
            currentIndex = maxIndex
        }
        pageControl?.currentPage = ( maxIndex.item) / (layout.cols * layout.rows)
    }
}

// MARK: - TitleView代理
extension JS_PageCollectionView: JS_TitleViewDelegate{
    
    func titleView(titleView: JS_TitleView, targetIndex: Int) {
        //获取对应组的IndexPath
        let indexPath = IndexPath(item: 0, section: targetIndex)
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: false)
        renovateOffsetBug(targetIndex: indexPath.section)
        pageControl?.currentPage = ( indexPath.item) / (layout.cols * layout.rows)
        
    }
    
    //修复偏移BUG
    fileprivate func renovateOffsetBug(targetIndex : Int){
        //修改ScrollItem<Bug>
        let sectionNum = dataSource?.numberOfSectionInPageCollectionView(self) ?? 0
        let sectionItemNum = calculatePageNumber(section: targetIndex)
        if targetIndex == sectionNum - 1 && sectionItemNum <= layout.cols * layout.rows { return }
        collectionView?.contentOffset.x -= layout.sectionInset.left
    }
    //计算当前页码
    fileprivate func calculatePageNumber(section:Int) -> Int {
        let sectionItemNum = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        pageControl?.numberOfPages = (sectionItemNum - 1 ) / (layout.cols * layout.rows) + 1
        return sectionItemNum
    }
    
}







