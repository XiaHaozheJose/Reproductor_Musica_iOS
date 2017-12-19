//
//  JS_PageFlowLayout.swift
//  pageView
//
//  Created by 浩哲 夏 on 2017/4/14.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import UIKit

class JS_PageFlowLayout: UICollectionViewFlowLayout {
    var cols: Int = 4
    var rows: Int = 2
    fileprivate lazy var attributes: [UICollectionViewLayoutAttributes] = []
    fileprivate(set) var ContentWidth:CGFloat = 0
    
    
}

// MARK: - 布局
extension JS_PageFlowLayout{
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        let sections = collectionView.numberOfSections
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing  * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        var previousPage = 0
        //遍历组
        for section in 0..<sections{
            let items = collectionView.numberOfItems(inSection: section)
            //遍历所有items
            for item in 0..<items{
                //获取当前indexPath
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                //设置属性
                let currentPage = item / (cols * rows)
                let currentIndex = item % (cols * rows)
                let itemX: CGFloat = CGFloat(previousPage + currentPage) * collectionView.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(currentIndex % cols)
                let itemY: CGFloat = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(currentIndex / cols)
                attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                attributes.append(attribute)
            }
            previousPage += (items - 1) / (cols * rows) + 1
        }
        ContentWidth = CGFloat(previousPage) * collectionView.bounds.width
    }
}

// MARK: - 返回布局
extension JS_PageFlowLayout{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}

// MARK: - 设置ContentSize
extension JS_PageFlowLayout{
    override var collectionViewContentSize: CGSize{
        return CGSize(width:ContentWidth, height:0)
    }
}

