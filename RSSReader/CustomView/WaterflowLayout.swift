//
//  WaterflowLayout.swift
//  SwiftCollection
//
//  Created by 王洋 on 2019/2/15.
//  Copyright © 2019 wannayoung. All rights reserved.
//

import UIKit

protocol WaterFlowLayoutDelegate {
    func itemHeightLayOut(layout: WaterflowLayout, indexPath: IndexPath) -> CGFloat
}

class WaterflowLayout: UICollectionViewFlowLayout {
    var colNum:NSInteger = 2
    var interSpace:CGFloat = 5
    var edgeInsets:UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    var columHeightArray:NSMutableArray = NSMutableArray()
    var attributeArray:NSMutableArray = NSMutableArray()
    
    var delegate:WaterFlowLayoutDelegate?
    
    
    override func prepare() {
        columHeightArray = NSMutableArray(capacity: colNum)
        
        for index in 0  ..< colNum {
            columHeightArray[index] = edgeInsets.top
        }
        //从总宽度
        let totalWidth:CGFloat = self.collectionView!.bounds.size.width
        //每行所有的item
        let totalItemWidth:CGFloat = totalWidth - edgeInsets.left - edgeInsets.right - interSpace * CGFloat(colNum-1)
        //每个item
        let itemwidth:CGFloat = totalItemWidth / CGFloat(colNum)        //拿到每个分区所有item的个数
        let totalItems:NSInteger = (self.collectionView?.numberOfItems(inSection: 0))!
        
        for i in 0  ..< totalItems {
            let currentCol:NSInteger = self.minCuttentCol()
            
            let xPos:CGFloat = edgeInsets.left + (itemwidth + interSpace) * CGFloat(currentCol)
            let yPos:CGFloat = CGFloat(truncating: columHeightArray[currentCol] as! NSNumber)
            
            let indexPath:IndexPath = IndexPath(item: i, section: 0)
            var itemHeight:CGFloat = 0.0
            itemHeight = (delegate?.itemHeightLayOut(layout: self, indexPath: indexPath))!
            let frame:CGRect = CGRect(x: xPos, y: yPos, width: itemwidth, height: itemHeight)
            let attribute:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = frame
            attributeArray.add(attribute)
            let upDateY:CGFloat = CGFloat(truncating: columHeightArray[currentCol] as! NSNumber) + itemHeight + interSpace
            columHeightArray[currentCol] = upDateY
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultArray = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributeArray {
            let rect1:CGRect = (attributes as! UICollectionViewLayoutAttributes).frame
            if(rect1.intersects(rect)) {
                resultArray.append(attributes as! UICollectionViewLayoutAttributes)
            }
        }
        return resultArray
    }
    
    override var collectionViewContentSize: CGSize {
        let width:CGFloat = self.collectionView!.frame.size.width
        let index:NSInteger = self.maxCuttentCol()
        let height:CGFloat = CGFloat(truncating: columHeightArray[index] as! NSNumber)
        return CGSize(width: width, height: height)
    }
    
    func configColNum(number:NSInteger) {
        if (colNum != number) {
            colNum = number
            self.invalidateLayout()
        }
    }
    
    func configInterSpace(space:CGFloat) {
        if (interSpace != space) {
            interSpace = space
            self.invalidateLayout()
        }
    }
    
    func configEdgeInsets(edge:UIEdgeInsets) {
        if (edgeInsets != edge) {
            edgeInsets = edge
            self.invalidateLayout()
        }
    }
    
    
    func maxCuttentCol() -> NSInteger {
        var maxHeight:CGFloat = 0.0
        var maxIndex:NSInteger = 0
        
        for (index, _) in columHeightArray.enumerated() {
            let heightInArray:CGFloat = CGFloat(truncating: columHeightArray[index] as! NSNumber)
            if (heightInArray > maxHeight) {
                maxHeight = heightInArray
                maxIndex = index
            }
        }
        return maxIndex
    }
    
    //每次取最小y的列
    func minCuttentCol() -> NSInteger {
        var minHeight:CGFloat = CGFloat(MAXFLOAT)
        var minIndex:NSInteger = 0
        
        for (index, _) in columHeightArray.enumerated() {
            let heightInArray:CGFloat = CGFloat(truncating: columHeightArray[index] as! NSNumber)
            if (heightInArray < minHeight) {
                minHeight = heightInArray
                minIndex = index
            }
        }
        return minIndex
    }
    
}
