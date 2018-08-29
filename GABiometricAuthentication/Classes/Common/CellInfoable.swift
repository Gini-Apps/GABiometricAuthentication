//
//  CellInfoable.swift
//  GABiometricAuthentication
//
//  Created by ido meirov on 03/07/2017.
//  Copyright © 2017 Gini-Apps. All rights reserved.
//

import UIKit


public protocol ClassInfoable : NSObjectProtocol
{
    static var classID  : String { get }
    static var classNib : UINib  { get }
}

extension ClassInfoable
{
    public static var classID  : String
    {
        return String(describing: Self.self)
    }
    
    public static var classNib : UINib
    {
        return UINib(nibName: classID, bundle: nil)
    }
}
