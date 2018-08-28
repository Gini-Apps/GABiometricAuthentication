//
//  PopAlertConfirmMethods.swift
//  Evrit-ios
//
//  Created by Alex Pinhasov on 23/04/2018.
//  Copyright © 2018 Gini-Apps. All rights reserved.
//

import Foundation

/// What kind of response do you want to recive after the user tapped a button inside the popup.
public typealias MethodPointer = () -> Void

/// Unified protocol to create abstraction.
public protocol CallBackDelegate {}

/// Each pop up will have its own set of responses.
public struct PopAlertConfirmMethods: CallBackDelegate
{
    public let confirm : MethodPointer
    
    public init(confirm: @escaping MethodPointer)
    {
        self.confirm = confirm
    }
}
