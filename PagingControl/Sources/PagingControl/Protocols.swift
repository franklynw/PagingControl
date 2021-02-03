//
//  Protocols.swift
//  PagingControl
//
//  Created by Franklyn Weber on 03/02/2021.
//

import SwiftUI


public protocol PagingViewModel: ObservableObject {
    associatedtype PagingItem: PageableItem
    var pagingControlColors: [PagingItem] { get }
    var currentPage: Int { get set }
}

public protocol PageableItem: Identifiable {
    var pageIndex: Int { get }
    var backgroundColor: UIColor { get }
    var borderColor: UIColor { get }
}

public extension PageableItem {
    
    var backgroundColor: UIColor {
        .systemGray5
    }
    
    var borderColor: UIColor {
        .label
    }
}
