//
//  SKStackedCollectionViewController.swift
//  SKStackedCollectionView
//
//  Created by Personal Work on 4/10/15.
//  Copyright (c) 2015 Saqib. All rights reserved.
//

import UIKit

enum ScrollDirections: NSInteger{
    case ScrollDirectionNone = 0
    case ScrollDirectionDown
    case ScrollDirectionUp
}

class SKStackedCollectionViewController: UICollectionViewController {
    
    let stackeLayout:SKCollectionViewStackedLayout = SKCollectionViewStackedLayout()
    var stackedContentOffset: CGPoint? = CGPointZero
    var exposedLayoutMargin: UIEdgeInsets?
    var exposedItemSize: CGSize?
    var exposedTopOverlap: CGFloat?
    var exposedBottomOverlap: CGFloat?
    var exposedBottomOverlapCount: Int?
    var unexposedItemAreSelectable: Bool? = true
    
    var exposedItemIndexPath: NSIndexPath!{
        didSet{
            
            if(exposedItemIndexPath == nil){
                self.collectionView!.deselectItemAtIndexPath(oldValue, animated: true)
                self.stackeLayout.overwriteContentOffset = true
                self.stackeLayout.contentOffset = self.stackedContentOffset
                self.collectionView!.performBatchUpdates({
                    self.collectionView!.setContentOffset(self.stackedContentOffset!, animated: true)
                    self.collectionView!.setCollectionViewLayout(self.stackeLayout, animated: true)
                    }, completion: nil)

            }
            
            else if(!exposedItemIndexPath.isEqual(oldValue)){
                
                
                if(exposedItemIndexPath != nil){
                    self.collectionView!.selectItemAtIndexPath(exposedItemIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.None)
                    self.stackedContentOffset! = self.collectionView!.contentOffset
                    
                    var exposedLayout: SKCollectionViewExposedLayout = SKCollectionViewExposedLayout(exposedItemIndex: exposedItemIndexPath!.item)
                    
                    exposedLayout.layoutMargin = self.exposedLayoutMargin
                    exposedLayout.itemSize = self.exposedItemSize
                    exposedLayout.topOverlap = self.exposedTopOverlap
                    exposedLayout.bottomOverlap = self.exposedBottomOverlap
                    exposedLayout.bottomOverlapCount = self.exposedBottomOverlapCount
                    
                    self.collectionView!.setCollectionViewLayout(exposedLayout, animated: true)
                    
                }
                
            }
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initController()
    }
    
    
    
    
    func initController(){
        
        self.exposedLayoutMargin = UIEdgeInsetsMake(40.0, 0.0, 0.0, 0.0)
        self.exposedItemSize = CGSizeZero
        self.exposedTopOverlap = 20.0
        self.exposedBottomOverlap = 20.0
        self.exposedBottomOverlapCount = 1
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.collectionViewLayout = self.stackeLayout
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func setExposedItemIndexPath(exposedItemIndexPath:NSIndexPath?){
        if(!(exposedItemIndexPath!.isEqual(self.exposedItemIndexPath))){
            
            
            if(exposedItemIndexPath != nil){
                self.collectionView!.selectItemAtIndexPath(exposedItemIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.None)
                self.stackedContentOffset! = self.collectionView!.contentOffset
                
                var exposedLayout: SKCollectionViewExposedLayout = SKCollectionViewExposedLayout(exposedItemIndex: exposedItemIndexPath!.item)
                
                exposedLayout.layoutMargin = self.exposedLayoutMargin
                exposedLayout.itemSize = self.exposedItemSize
                exposedLayout.topOverlap = self.exposedTopOverlap
                exposedLayout.bottomOverlap = self.exposedBottomOverlap
                exposedLayout.bottomOverlapCount = self.exposedBottomOverlapCount
                
                self.collectionView!.setCollectionViewLayout(exposedLayout, animated: true)
                
            }else{
                self.collectionView!.deselectItemAtIndexPath(self.exposedItemIndexPath!, animated: true)
                self.stackeLayout.overwriteContentOffset = true
                self.stackeLayout.contentOffset = self.stackedContentOffset
                self.collectionView!.performBatchUpdates({
                    self.collectionView!.setContentOffset(self.stackedContentOffset!, animated: true)
                    self.collectionView!.setCollectionViewLayout(self.stackeLayout, animated: true)
                }, completion: nil)
            }
            
            self.exposedItemIndexPath = exposedItemIndexPath
            
        }
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }

    
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
        return self.unexposedItemAreSelectable! || indexPath.isEqual(self.exposedItemIndexPath) || !(self.exposedItemIndexPath != nil)
    }
 

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.isEqual(self.exposedItemIndexPath)){
            self.exposedItemIndexPath = nil
        }else if((self.unexposedItemAreSelectable!) || !(self.exposedItemIndexPath != nil)){
            self.exposedItemIndexPath = indexPath
        }
        
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
