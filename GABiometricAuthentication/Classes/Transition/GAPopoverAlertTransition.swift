//
//  GAPopoverAlertTransition.swift
//  Evrit-ios
//
//  Created by Menahem Barouk on 21/02/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import UIKit

public class GAPopoverAlertTransition: NSObject
{
    // MARK: - Public Properties
    var animationDuration = TimeInterval(0.5)
    
    // MARK: - Private Properties
    fileprivate var isPresenting = true
    fileprivate var dimmedBackground: UIView?
    fileprivate weak var toViewController: UIViewController?
    public var dismissOnBackgroundViewDidPrass = true
}

extension GAPopoverAlertTransition: UIViewControllerTransitioningDelegate
{
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = false
        return self
    }
}

extension GAPopoverAlertTransition: UIViewControllerAnimatedTransitioning
{
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return animationDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        switch isPresenting
        {
        case true : animateTransitionForPresentation(transitionContext)
        case false: animateTransitionForDismissal   (transitionContext)
        }
    }
}

// MARK: - Private methods
fileprivate extension GAPopoverAlertTransition
{
    func animateTransitionForPresentation(_ transitionContext: UIViewControllerContextTransitioning)
    {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        guard let animableView = (toViewController as? PopoverTransitionAnimationProtocol)?.viewForTransitionAnimation else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        animableView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        dimmedBackground = UIView()
        guard let dimmedBackground = dimmedBackground else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        
        let containerView       = transitionContext.containerView
        self.toViewController   = toViewController
        
        containerView.addSubview(toView)
        containerView.isOpaque = false
        
        toView.insertSubview(dimmedBackground, at: 0)
        toView.frame = containerView.frame
        
        configureDimmedBackground()
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .allowUserInteraction,
                       animations: {
                        
                        self.dimmedBackground?.alpha = 0.6
                        animableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) },
                       
                       completion: { (success) in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func animateTransitionForDismissal   (_ transitionContext: UIViewControllerContextTransitioning)
    {
        guard let popAlertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        guard let animableView = (popAlertViewController as? PopoverTransitionAnimationProtocol)?.viewForTransitionAnimation else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        guard let dimmedBackground = dimmedBackground else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        
        /// Animate the transition
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        
                        popAlertViewController.view.alpha = 0.0
                        dimmedBackground.alpha = 0.0
                        animableView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)},
                       
                       completion: { (finished) in
                        // Clean up after animation finished
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        dimmedBackground.removeFromSuperview()
                        self.dimmedBackground = nil})
    }
    
    
    func configureDimmedBackground()
    {
        dimmedBackground?.backgroundColor = UIColor.black
        dimmedBackground?.alpha = 0.0
        dimmedBackground?.isOpaque = false
        dimmedBackground?.addConstraintsToFillSuperView()
        addTapGesture()
    }
    
    func addTapGesture()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureDidTap))
        tapGesture      .numberOfTapsRequired = 1
        tapGesture      .delegate             = self
        dimmedBackground?.addGestureRecognizer(tapGesture)
    }
}

extension UIView
{
    func addConstraintsToFillSuperView()
    {
        guard superview != nil else { return }
        
        let views = ["self":self]
        translatesAutoresizingMaskIntoConstraints = false
        let   verticalConstraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[self]-0-|", metrics: nil, views: views)
        let horizontalConstraints   = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[self]-0-|", metrics: nil, views: views)
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
}

//MARK: - UIGestureRecognizerDelegate
extension  GAPopoverAlertTransition: UIGestureRecognizerDelegate
{
    @objc func tapGestureDidTap()
    {
        guard dismissOnBackgroundViewDidPrass else { return }
        toViewController?.dismiss(animated: true)
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        return gestureRecognizer is UITapGestureRecognizer && touch.view == dimmedBackground
    }
}
