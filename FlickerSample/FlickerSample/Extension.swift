//
//  Extension.swift
//  FlickerSample
//
//  Created by Kamal Harariya on 9/3/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation

extension Array {
    mutating func replaceObjectAtIndex(index: NSInteger, withObject newObject: Element) {
        removeAtIndex(index)
        insert(newObject, atIndex: index)
    }
}