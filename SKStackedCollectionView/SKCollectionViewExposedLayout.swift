//
//  SKCollectionViewExposedLayout.swift
//  SKStackedCollectionView
//
//  Created by Personal Work on 4/12/15.
//  Copyright (c) 2015 Saqib. All rights reserved.
//

import UIKit

public class SKCollectionViewExposedLayout: UICollectionViewLayout {
   
    public var layoutMargin: UIEdgeInsets?
    public var itemSize: CGSize? = CGSizeZero
    public var topOverlap: CGFloat? = 0.0
    public var bottomOverlap: CGFloat? = 0.0
    public var bottomOverlapCount:Int? = 0
    
    private var exposedItemIndex: NSInteger? = 0
    private var layoutAttributes: NSDictionary = NSDictionary()
    
    public init(exposedItemIndex:NSInteger){
        super.init()
        
        self.layoutMargin = UIEdgeInsetsMake(40.0, 0.0, 0.0, 0.0);
        self.topOverlap = 20.0;
        self.bottomOverlap = 20.0;
        self.bottomOverlapCount = 1;
        self.exposedItemIndex = exposedItemIndex;
        
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func collectionViewContentSize() -> CGSize {
        
        var contentSize: CGSize = self.collectionView!.bounds.size
        contentSize.height -= self.collectionView!.contentInset.top + self.collectionView!.contentInset.bottom
        return contentSize
    }
    
    public override func prepareLayout() {
        
        var itemSize: CGSize = self.itemSize!
        
        if(CGSizeEqualToSize(itemSize, CGSizeZero)){
            var width = CGRectGetWidth(self.collectionView!.bounds) - self.layoutMargin!.left - self.layoutMargin!.right
            var height = CGRectGetHeight(self.collectionView!.bounds) - self.layoutMargin!.top - self.layoutMargin!.bottom - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom
            
            itemSize = CGSizeMake(width, height)
        }
        
        var layoutAttributes = NSMutableDictionary()
        var itemCount: NSInteger = self.collectionView!.numberOfItemsInSection(0)
        
        for item in 0...itemCount{
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            if(item < self.exposedItemIndex){
                attributes.frame = CGRectMake(self.layoutMargin!.left, self.layoutMargin!.top - self.topOverlap!, itemSize.width, itemSize.height)
                if(item < (self.exposedItemIndex! - 1)){
                    attributes.hidden = true
                }
            }else if(item == self.exposedItemIndex){
                attributes.frame = CGRectMake(self.layoutMargin!.left,self.layoutMargin!.top,itemSize.width,itemSize.height)
            }else if(item > (self.exposedItemIndex! + self.bottomOverlapCount!)){
                attributes.frame = CGRectMake(self.layoutMargin!.left,self.collectionViewContentSize().height,itemSize.width,itemSize.height
                )
                attributes.hidden = true
            }else{
                var count: NSInteger = min(self.bottomOverlapCount!+1, itemCount-self.exposedItemIndex!) - (item - self.exposedItemIndex!)
                attributes.frame = CGRectMake(self.layoutMargin!.left, self.layoutMargin!.top + itemSize.height - CGFloat(count) * self.bottomOverlap!, itemSize.width, itemSize.height)
            }
            
            attributes.zIndex = item
            layoutAttributes[indexPath] = attributes
        }
        
        self.layoutAttributes = layoutAttributes
        
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var layoutAttributes = NSMutableArray()
        
        self.layoutAttributes.enumerateKeysAndObjectsUsingBlock{(key,object,stop)-> Void in
            
            if(CGRectIntersectsRect(rect, object.frame)){
                layoutAttributes.addObject(object)
            }
            
            
        }
        
        return layoutAttributes as [AnyObject]

    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return self.layoutAttributes[indexPath] as! UICollectionViewLayoutAttributes
    }
    
    
}
