//
//  TransitionAnimator.swift
//  Animations
//
//  Created by macbookpro on 9/6/15.
//  Copyright (c) 2015 myCompany. All rights reserved.
//

import UIKit
//import ViewController


public enum TransitionType{
    
    case opening //
    case closing
    
}

class TransitionAnimator: NSObject , UIViewControllerAnimatedTransitioning{
    
    var duration : NSTimeInterval = 0.5
    var type : TransitionType!
    
    convenience init(duration:NSTimeInterval,type:TransitionType) {
        
        self.init()
        self.duration = duration
        self.type = type
        
    }
    
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    
    
    func cancelAnimation(){
        
        self.transitionContext?.cancelInteractiveTransition()
        self.transitionContext?.completeTransition(self.transitionContext!.transitionWasCancelled())
        
    }

    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //1 Get Transition Context
        self.transitionContext = transitionContext
        
        //2 Get Container view
        var containerView = transitionContext.containerView()
        
        switch type! {

            case .opening:
                //3 Get From View controller to get imageview
                var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ViewController
                //4 Get To ViewController to set in the imageview
                var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
                
                self.OpeningAnimation(toViewController, fromViewController: fromViewController, transitionContext: transitionContext, containerView: containerView)
            
            case .closing:
                //3 Get From View controller to get imageview
                var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! DetailViewController
                //4 Get To ViewController to set in the imageview
                var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ViewController
            
                self.closingAnimation(toViewController, fromViewController: fromViewController, transitionContext: transitionContext, containerView: containerView)
            
            
            default:
                print("")
        }
        
    }
    
    
    
    func OpeningAnimation (toViewController:DetailViewController, fromViewController:ViewController, transitionContext: UIViewControllerContextTransitioning, containerView:UIView){

        let indexpath =  fromViewController.collectionView.indexPathsForSelectedItems().first as! NSIndexPath
        
        let cell = fromViewController.collectionView.cellForItemAtIndexPath(indexpath) as! AlbumImageView
        
        let imageView = cell.imageView
        
        
        let imageSnapshot = imageView.snapshotViewAfterScreenUpdates(false)
        
        imageSnapshot.frame = containerView.convertRect(imageView.frame, fromView: imageView.superview)
        
        imageView.hidden = true
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        toViewController.view.alpha = 0
        toViewController.imageView.hidden = true
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(imageSnapshot)
        
        
        toViewController.imageView.layoutIfNeeded()
        
        
        //=========================   COLOR EFFECR AS AN WHOLE
        
        var circleMaskPathInitial = UIBezierPath(ovalInRect: imageView.frame)
        
        var extremePoint = CGPoint(x: imageView.center.x - 0, y: imageView.center.y - CGRectGetHeight(toViewController.view.bounds))
        
        print("\(extremePoint.x) + \(extremePoint.y)")
        
        var radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y*extremePoint.y))
        
        var circleMaskPathFinal = UIBezierPath(ovalInRect:  CGRectInset(imageView.frame, -radius, -radius))
        
        //5
        var maskLayer = CAShapeLayer()
        
        
        var maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayer.path = circleMaskPathFinal.CGPath
        maskLayerAnimation.fromValue =  circleMaskPathInitial.CGPath
        maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
        
        
        toViewController.view.layer.mask = maskLayer
        maskLayerAnimation.duration = self.transitionDuration(transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: nil)
        
        //========================
        
        
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            toViewController.view.alpha = 1
            let  frame = containerView.convertRect(toViewController.imageView.frame, fromView: toViewController.view)
            imageSnapshot.frame = frame
            toViewController.imageView.layoutIfNeeded()
            //            containerView.layoutIfNeeded()
            }) { (Bool) -> Void in
                
                toViewController.imageView.hidden = false
                imageView.hidden = false
                imageSnapshot.removeFromSuperview()
                self.cancelAnimation()
        }
        
    }
    
    
    func closingAnimation (toViewController:ViewController, fromViewController:DetailViewController, transitionContext: UIViewControllerContextTransitioning, containerView:UIView){
        let imageSnapshot = fromViewController.imageView.snapshotViewAfterScreenUpdates(false)
        
        
        fromViewController.imageView.layoutIfNeeded()
        
        imageSnapshot.frame = containerView.convertRect(fromViewController.imageView.frame, fromView: fromViewController.imageView.superview)
        
        fromViewController.imageView.hidden = true
        
        let imageCell = toViewController.collectionViewCellForIndexRow(fromViewController.imageIndex)
        imageCell.imageView.hidden = true
        
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        containerView.addSubview(imageSnapshot)
        
        //=================== 

        
        var circleMaskPathFinal = UIBezierPath(ovalInRect:fromViewController.imageView.frame)
        
        var extremePoint = CGPoint(x: fromViewController.imageView.center.x - 0, y: fromViewController.imageView.center.y - CGRectGetHeight(fromViewController.view.bounds))
        
        var radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y*extremePoint.y))
        
        
        
        var circleMaskPathInitial = UIBezierPath(ovalInRect:  CGRectInset(fromViewController.imageView.frame, -radius, -radius))
        
        var maskLayer = CAShapeLayer()
        
        
        var maskLayerAnimation = CABasicAnimation(keyPath: "path")
        
        
        maskLayer.path = circleMaskPathInitial.CGPath
        fromViewController.view.layer.mask = maskLayer
        
        
        maskLayerAnimation.fromValue =  circleMaskPathInitial.CGPath
        maskLayerAnimation.toValue =   circleMaskPathFinal.CGPath
        
        
        maskLayerAnimation.duration = self.transitionDuration(transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")

        
        //===================
        
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            fromViewController.view.alpha = 0
            imageSnapshot.frame =  containerView.convertRect(imageCell.imageView.frame, fromView: imageCell.imageView.superview)
            }, completion: { (Bool) -> Void in
                
                imageSnapshot.removeFromSuperview()
                fromViewController.imageView.hidden = false
                imageCell.imageView.hidden = false
                
                self.cancelAnimation()
                
                
        })
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
        self.transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
        
    }
    
}

