//
//  CellInfoable.swift
//  Evrit-ios
//
//  Created by ido meirov on 03/07/2017.
//  Copyright © 2017 Gini-Apps. All rights reserved.
//

import UIKit

public typealias ClassInfoable = CellInfoable

public protocol CellInfoable : NSObjectProtocol
{
    static var cellID  : String { get }
    static var cellNib : UINib  { get }
}

extension CellInfoable
{
    public static var cellID  : String
    {
        return String(describing: Self.self)
    }
    
    public static var cellNib : UINib
    {
        return UINib(nibName: cellID, bundle: nil)
    }
}
