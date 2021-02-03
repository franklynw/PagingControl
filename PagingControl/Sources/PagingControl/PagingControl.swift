//
//  PagingControl.swift
//  PagingControl
//
//  Created by Franklyn Weber on 03/02/2021.
//

import SwiftUI


public struct PagingControl<V>: View where V: PagingViewModel {
    
    private typealias PagingItem = V.PagingItem
    public typealias Magnification = SizeTailOff
    
    @ObservedObject private var pagingViewModel: V
    @State private var startingPageIndex: Int
    @State private var isPanning = false
    
    private let defaultMaxDiameter: CGFloat = 22
    private let defaultMinDiameter: CGFloat = 0
    
    internal var maxDiameter: CGFloat!
    internal var minDiameter: CGFloat!
    internal var maxItems: Int?
    internal var sizeTailOff: SizeTailOff = .medium
    internal var magnification: Magnification = .medium
    
    public enum SizeTailOff {
        case max
        case medium
        case low
        case none
        case custom(CGFloat)
        
        fileprivate var tailOffValue: CGFloat {
            switch self {
            case .max: return 7
            case .medium: return 5
            case .low: return 3
            case .none: return 0
            case .custom(let tailOff): return tailOff
            }
        }
        
        fileprivate var magnificationValue: CGFloat {
            switch self {
            case .max: return 2
            case .medium: return 1.5
            case .low: return 1.2
            case .none: return 1
            case .custom(let magnification): return magnification
            }
        }
    }
    
    
    init(_ pagingViewModel: V) {
        
        self.pagingViewModel = pagingViewModel
        
        _startingPageIndex = State<Int>(wrappedValue: pagingViewModel.currentPage)
        
        self.maxDiameter = defaultMaxDiameter
        self.minDiameter = defaultMinDiameter
    }
    
    public var body: some View {
            
            GeometryReader { geometry in
                
                VStack {
                    Spacer()
                    HStack {
                        ForEach(pagingViewModel.pagingControlColors) {
                            circle(for: $0)
                        }
                    }
                    .scaleEffect(isPanning ? magnification.magnificationValue : 1)
                    .animation(.spring())
                }
                .frame(width: geometry.size.width) // we need the fixed width as the animations resize the HStack, which interferes with the values from the drag gesture
                .highPriorityGesture(pan())
            }
            .opacity(pagingViewModel.pagingControlColors.count > 1 ? 1 : 0)
    }

    private func circle(for item: PagingItem) -> AnyView {
        
        let diameter = self.diameter(for: item)
        
        guard diameter > 0 else {
            return AnyView(EmptyView())
        }

        return AnyView(
            Circle()
                .fill(Color(item.backgroundColor))
                .frame(width: diameter, height: diameter)
                .overlay(
                    Circle()
                        .stroke(Color(item.borderColor), lineWidth: 0.5)
                )
                .onTapGesture {
                    self.startingPageIndex = item.pageIndex
                    self.pagingViewModel.currentPage = item.pageIndex
                }
                .animation(.spring())
        )
    }
    
    private func pan() -> some Gesture {
        
        DragGesture(minimumDistance: 1)
            .onChanged { gesture in
                self.isPanning = true
                self.updatePageNumber(with: gesture)
            }
            .onEnded { gesture in
                Translation.end()
                self.isPanning = false
                self.startingPageIndex = self.pagingViewModel.currentPage
            }
    }
    
    private func updatePageNumber(with gesture: DragGesture.Value) {
        
        let count = pagingViewModel.pagingControlColors.count
        
        if !Translation.isBusy {
            startingPageIndex = pagingViewModel.currentPage
            let minimum = CGFloat(startingPageIndex) * -maxDiameter
            let maximum = CGFloat(count - startingPageIndex - 1) * maxDiameter
            Translation.begin(gesture, min: minimum, max: maximum)
        }
        
        Translation.update(gesture)
        
        let touchOffset = Translation.value / maxDiameter
        
        let pageOffset = Int(max(min(touchOffset, CGFloat(count - startingPageIndex - 1)), -CGFloat(startingPageIndex)))
        let updatedPageNumber = min(max(0, startingPageIndex + pageOffset), count - 1)
        
        pagingViewModel.currentPage = updatedPageNumber
    }
    
    private func diameter(for item: PagingItem) -> CGFloat {
        
        if let maxItems = maxItems, pagingViewModel.pagingControlColors.count > maxItems {
            let first = max(min(pagingViewModel.currentPage - maxItems / 2, pagingViewModel.pagingControlColors.count - maxItems), 0)
            let last = first + maxItems - 1
            if item.pageIndex < first || item.pageIndex > last {
                return 0
            }
        }
        
        let adjustedDiameter: CGFloat
        
        if isPanning {
            
            let touchOffset = Translation.value / maxDiameter
            
            let itemOffset = CGFloat(item.pageIndex - startingPageIndex)
            let difference = abs(touchOffset - itemOffset)
            adjustedDiameter = maxDiameter - difference * sizeTailOff.tailOffValue * magnification.magnificationValue
            
        } else {
            
            let itemOffset = abs(CGFloat(item.pageIndex - pagingViewModel.currentPage))
            adjustedDiameter = maxDiameter - itemOffset * sizeTailOff.tailOffValue
        }
        
        return max(adjustedDiameter, minDiameter)
    }
}
