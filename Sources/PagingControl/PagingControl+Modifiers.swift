//
//  PagingControl+Modifiers.swift
//  PagingControl
//
//  Created by Franklyn Weber on 03/02/2021.
//

import SwiftUI


public extension PagingControl {
    
    /// Set the minimum diameter the circles can reach
    /// - Parameter minDiameter: the diameter in pixels
    func minDiameter(_ minDiameter: CGFloat) -> Self {
        var copy = self
        copy.minDiameter = minDiameter
        return copy
    }
    
    /// Set the maximum diameter the circles can reach
    /// - Parameter maxDiameter: the diameter in pixels
    func maxDiameter(_ maxDiameter: CGFloat) -> Self {
        var copy = self
        copy.maxDiameter = maxDiameter
        return copy
    }
    
    /// The maximum number of circles the control will display
    /// - Parameter maxItems: the maximum number of circles
    func maxItems(_ maxItems: Int) -> Self {
        var copy = self
        copy.maxItems = maxItems
        return copy
    }
    
    /// Controls how the circle sizes reduce either side of the current page circle
    /// - Parameter sizeTailOff: a SizeTailOff case
    func sizeTailOff(_ sizeTailOff: SizeTailOff) -> Self {
        var copy = self
        copy.sizeTailOff = sizeTailOff
        return copy
    }
    
    /// Controls how the circles magnify as you drag across the component
    /// - Parameter magnification: a Magnification case
    func magnification(_ magnification: Magnification) -> Self {
        var copy = self
        copy.magnification = magnification
        return copy
    }
}
