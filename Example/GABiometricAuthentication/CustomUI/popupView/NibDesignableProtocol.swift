//
//  NibDesignableProtocol.swift
//  GAVideoPlayerKit
//
//  Created by arkadi on 30/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

public protocol NibDesignableProtocol : NSObjectProtocol
{
    /**
     Identifies the view that will be the superview of the contents loaded from
     the Nib. Referenced in setupNib().
     
     - returns: Superview for Nib contents.
     */
    var nibContainerView : UIView { get }
    // MARK: - Nib loading
    
    /**
     Called to load the nib in setupNib().
     
     - returns: UIView instance loaded from a nib file.
     */
    func loadNib() -> UIView?
    /**
     Called in the default implementation of loadNib(). Default is class name.
     
     - returns: Name of a single view nib file.
     */
    static var nibName : String { get }
    
    /**
     Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
     */
    func setupNib()
}
public extension NibDesignableProtocol where Self : UIView
{
    public var nibContainerView: UIView {
        return self
    }
    
    // MARK: - Nib loading
    static var nibName : String {
        return String(describing: self)
    }
    private static var classNib : UINib  {
        return UINib(nibName: nibName, bundle: Bundle(for: Self.classForCoder()))
    }
    
    /**
     Called to load the nib in setupNib().
     
     - returns: UIView instance loaded from a nib file.
     */
    public func loadNib() -> UIView? {
        return Self.classNib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    // MARK: - Nib loading
    
    /**
     Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
     */
    public func setupNib() {
        
        guard let view = loadNib() else { return }
        nibContainerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        UIView.addViewConstraintsForTopLevelView(View: view, superView: nibContainerView)
    }
}
fileprivate extension UIView
{
    fileprivate func constraintFrame(to superViewObject: UIView)
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let      topConstraint = NSLayoutConstraint(item: self, attribute: .top     , relatedBy: .equal, toItem: superViewObject, attribute: .top     , multiplier: 1.0, constant: 0.0)
        let   bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom  , relatedBy: .equal, toItem: superViewObject, attribute: .bottom  , multiplier: 1.0, constant: 0.0)
        let  leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading , relatedBy: .equal, toItem: superViewObject, attribute: .leading , multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superViewObject, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        superViewObject.addConstraints([topConstraint,bottomConstraint,leadingConstraint,trailingConstraint])
    }
    fileprivate static func addViewConstraintsForTopLevelView(View view : UIView, superView : UIView) -> Void
    {
        view.constraintFrame(to: superView)
    }
}
