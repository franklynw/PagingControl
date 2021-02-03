//
//  Translation.swift
//  PagingControl
//
//  Created by Franklyn Weber on 03/02/2021.
//

import SwiftUI


class Translation {
    
    // This is needed so that if the user pans beyond the control & the magnification has already reached max,
    // then we want the panning to begin working immediately they pan back again,
    // rather than waiting until the pan location is back to the max position
    // There needs to be only a single "instance" as well, due to the lifecycle of the view
    // which would cause the state of the translation to be lost (hence static)
    
    static var isBusy = false
    static var value: CGFloat = 0
    
    private static var minimum: CGFloat = 0
    private static var maximum: CGFloat = 0
    private static var startX: CGFloat = 0
    
    
    static func begin(_ gesture: DragGesture.Value, min: CGFloat, max: CGFloat) {
        startX = gesture.startLocation.x
        minimum = min
        maximum = max
        isBusy = true
    }
    
    static func update(_ gesture: DragGesture.Value) {
        
        let offset = gesture.location.x - startX
        
        startX += max((offset - maximum), 0)
        startX -= max((minimum - offset), 0)
        
        value = max(min(offset, maximum), minimum)
    }
    
    static func end() {
        isBusy = false
        value = 0
    }
}
