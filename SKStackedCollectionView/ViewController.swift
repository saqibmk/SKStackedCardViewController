//
//  ViewController.swift
//  SKStackedCollectionView
//
//  Created by Personal Work on 4/10/15.
//  Copyright (c) 2015 Saqib. All rights reserved.
//

import UIKit

let reuseIdentifier = "cell"

@IBDesignable class ViewController: SKStackedCollectionViewController {
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SKCollectionViewCell
        
        // Configure the cell
        cell.layer.cornerRadius = 15;
        cell.label?.text = "HELLO"
        cell.backgroundColor = getRandomColor()
        return cell
    }
    
    

}

