//
//  DetailViewController.swift
//  Animations
//
//  Created by macbookpro on 9/6/15.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController,UINavigationControllerDelegate {

    var imageIndex : Int!
    var imageView : UIImageView!
    
    var image : UIImage!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height

    
    //MARK: ViewLifeCycle
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.delegate = self
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.delegate = nil
        super.viewWillDisappear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.layer.backgroundColor = UIColor.yellowColor().CGColor

        self.view.backgroundColor = UIColor.yellowColor()
        self.view.contentMode  = UIViewContentMode.ScaleAspectFill

        imageView = UIImageView()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = image
        let imH = "H:[imageView(\(screenWidth/2.1))]"
        let imV = "V:|-150-[imageView(\(screenWidth/2.1))]"
        let viewDic = ["imageView":imageView]
        view.addSubview(imageView)

        setLocationAccrodingWithSuperViewAndCurrentViewSetLayoutAttributeCenterX(view, currentView: imageView, width: "\(screenWidth/2.1)")
        setConstraintsWithStringHandVWithCurrentView(imH, formatV: imV, superView: view, viewDic: viewDic)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: NavigationController Delegate Stuff
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if ((fromVC == self) && (toVC.isKindOfClass(ViewController)))
        {
            return TransitionAnimator (duration: 0.5, type: TransitionType.closing)
        }
        else
        {
            return nil
        }
    }
    
    
    //MARK: Constraints Stuff
    
    func setConstraintsWithStringWithCurrentView(format : String,superView : UIView,viewDic : NSDictionary)->Void{
        
        var constaraints = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views:viewDic as [NSObject : AnyObject])
        superView.addConstraints(constaraints)
        
    }
    
    
    func setLocationAccrodingWithSuperViewAndCurrentViewSetLayoutAttributeCenterX(superView :UIView,currentView:UIView,width:String)->Void{
        
        
        let dic = ["currentView":currentView]
        
        setConstraintsWithStringWithCurrentView("H:[currentView(\(width))]", superView: superView, viewDic: dic)
        
        let  constaraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        
        
        superView.addConstraint(constaraint)
        
    }
    
    func setConstraintsWithStringHandVWithCurrentView(formatH : String,formatV : String,superView : UIView,viewDic : NSDictionary)->Void{
        
        
        setConstraintsWithStringWithCurrentView(formatH, superView: superView, viewDic: viewDic)
        setConstraintsWithStringWithCurrentView(formatV, superView: superView, viewDic: viewDic)
        
    }
    
    


    
}
