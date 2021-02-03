//
//  PagingControl+Modifiers.swift
//  PagingControl
//
//  Created by Franklyn Weber on 03/02/2021.
//

import SwiftUI


public extension PagingControl {
    
    func minDiameter(_ minDiameter: CGFloat) -> Self {
        var copy = self
        copy.minDiameter = minDiameter
        return copy
    }
    
    func maxDiameter(_ maxDiameter: CGFloat) -> Self {
        var copy = self
        copy.maxDiameter = maxDiameter
        return copy
    }
    
    func maxItems(_ maxItems: Int) -> Self {
        var copy = self
        copy.maxItems = maxItems
        return copy
    }
    
    func sizeTailOff(_ sizeTailOff: SizeTailOff) -> Self {
        var copy = self
        copy.sizeTailOff = sizeTailOff
        return copy
    }
    
    func magnification(_ magnification: Magnification) -> Self {
        var copy = self
        copy.magnification = magnification
        return copy
    }
}
