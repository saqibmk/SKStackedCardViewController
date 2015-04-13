//
//  SKCollectionViewStackedLayout.swift
//  SKStackedCollectionView
//
//  Created by Personal Work on 4/10/15.
//  Copyright (c) 2015 Saqib. All rights reserved.
//

import UIKit

public class SKCollectionViewStackedLayout: UICollectionViewLayout {
    
    public var layoutMargin: UIEdgeInsets?
    public var itemSize: CGSize! = CGSizeMake(0.0, 0.0)
    public var topReveal: CGFloat?
    public var bounceFactor: CGFloat?
    public var fillHeight: Bool? = true
    public var alwaysBounce: Bool?
    public var overwriteContentOffset: Bool?
    public var contentOffset: CGPoint? = CGPointZero
    public var movingIndexPath: NSIndexSet?
    
    private var layoutAttributes: NSDictionary = NSDictionary()
    private var filling: Bool?
    
    
    public override init(){
        super.init()
        self.initLayout()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initLayout()
        
    }
    
    func initLayout(){
        self.layoutMargin = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        self.topReveal = 120.0
        self.bounceFactor = 0.2
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func collectionViewContentSize() -> CGSize {
        
        let calculatedHeight = self.layoutMargin!.top + (self.topReveal! * CGFloat(self.collectionView!.numberOfItemsInSection(0))) + self.layoutMargin!.bottom + self.collectionView!.contentInset.bottom
        
        var contentSize = CGSizeMake(CGRectGetHeight(self.collectionView!.bounds), calculatedHeight)
        
        if(contentSize.height < CGRectGetHeight(self.collectionView!.bounds)){
            contentSize.height = CGRectGetHeight(self.collectionView!.bounds) - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom;
            
            if(self.alwaysBounce == true){
                contentSize.height += 1.0
            }
        self.filling = self.fillHeight!

        }else{
            self.filling = false
        }
        
        return contentSize
    }
    
    public override func prepareLayout() {
        
        super.prepareLayout()
        
        self.collectionViewContentSize()
        
        var itemReveal = self.topReveal
        
        if(self.filling! == true){
                
            itemReveal = floor(CGRectGetHeight(self.collectionView!.bounds) - self.layoutMargin!.top - self.layoutMargin!.bottom - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom) / CGFloat(self.collectionView!.numberOfItemsInSection(0))
        }
        
        var itemSize = self.itemSize!
        
        if(CGSizeEqualToSize(itemSize, CGSizeZero)){
            
            itemSize = CGSizeMake(CGRectGetWidth(self.collectionView!.bounds) - self.layoutMargin!.left - self.layoutMargin!.right, CGRectGetHeight(self.collectionView!.bounds) - self.layoutMargin!.top - self.layoutMargin!.bottom - self.collectionView!.contentInset.top - self.collectionView!.contentInset.bottom)
        }
        
        
        if(self.overwriteContentOffset != nil){
            
            var contentOffset = self.collectionView!.contentOffset
            
        }else{

           var contentOffset = self.contentOffset!
        }
        
        println(contentOffset)
        
        self.overwriteContentOffset = false
        
        var layoutAttributes = NSMutableDictionary()
        var previousTopOverLappingAttributes = [UICollectionViewLayoutAttributes?](count: 2, repeatedValue: nil)
        let itemCount:NSInteger = self.collectionView!.numberOfItemsInSection(0)
        var firstCompressingItem: NSInteger = -1
        
        for item in 0...itemCount{
            
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.zIndex = item
            attributes.hidden = attributes.indexPath.isEqual(self.movingIndexPath)
            attributes.frame = CGRectMake(self.layoutMargin!.left, self.layoutMargin!.top + itemReveal! * CGFloat(item), itemSize.width, itemSize.height)
            
            if(contentOffset!.y + self.collectionView!.contentInset.top < 0.0){
                var frame = attributes.frame
                frame.origin.y -= self.bounceFactor! * (contentOffset!.y + self.collectionView!.contentInset.top) * CGFloat(item)
                attributes.frame = frame
                
            }else if(CGRectGetMinY(attributes.frame) < contentOffset!.y + self.layoutMargin!.top){
                var frame = attributes.frame
                frame.origin.y = contentOffset!.y + self.layoutMargin!.top
                attributes.frame = frame
                
                if(previousTopOverLappingAttributes[0] != nil){
                    previousTopOverLappingAttributes[1]?.hidden = true
                }
                
                previousTopOverLappingAttributes[1] = previousTopOverLappingAttributes[0]
                previousTopOverLappingAttributes[0] = attributes
            }else if (self.collectionViewContentSize().height > CGRectGetHeight(self.collectionView!.bounds) && contentOffset?.y > self.collectionViewContentSize().height - CGRectGetHeight(self.collectionView!.bounds)){
                
                if(firstCompressingItem < 0){
                    firstCompressingItem = item
                }else{
                    
                    
                    var frame = attributes.frame
                    var delta = contentOffset!.y + CGRectGetHeight(self.collectionView!.bounds) - self.collectionViewContentSize().height
                    frame.origin.y += CGFloat(self.bounceFactor!) * delta * CGFloat((firstCompressingItem - item))
                    frame.origin.y = max(frame.origin.y, contentOffset!.y + self.layoutMargin!.top)
                    attributes.frame = frame
                }
            }else{
                firstCompressingItem = -1
                
            }
            
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
