//
//  ViewController.swift
//  Animations
//
//  Created by macbookpro on 9/6/15.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    
    var collectionImageCount : Int = 0
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.delegate = self

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.delegate = nil
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContentView()
    }
    
    func initContentView(){
        
        
        let cellNib = UINib(nibName: "AlbumImageView", bundle: nil)
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "albumCell")
        collectionImageCount = 4
        collectionView.reloadData()
        
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionImageCount
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumCell", forIndexPath: indexPath) as! AlbumImageView
        cell.tag = indexPath.row+1
        cell.imageView.image = UIImage(named:"image\(indexPath.row+1)")
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.row)
        
        self.performSegueWithIdentifier("pushDetail", sender: indexPath)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        if let indexPath = sender as? NSIndexPath {
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! AlbumImageView
            
            detailViewController.image = cell.imageView.image
            detailViewController.imageIndex = indexPath.row
        }
        
        
    }
    
    
    func clickEventWithImage(image: UIImage) {
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(screenWidth/2.1, screenWidth/2.1 )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionViewCellForIndexRow(row:Int)->AlbumImageView{
        
        
        return  collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: row, inSection: 0))as! AlbumImageView
        
    }
    
    
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        
        if ((fromVC == self) && (toVC.isKindOfClass(DetailViewController)))
        {
           let transition = TransitionAnimator (duration: 0.5, type: TransitionType.opening)
            self.navigationController?.delegate = nil
            return transition;
        }
        else
        {
            return nil
        }
    }

    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}