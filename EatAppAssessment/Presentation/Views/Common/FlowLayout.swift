//
//  FlowLayout.swift
//  EatAppAssessment
//
//  Created by Ali Bamohammad on 19/06/2025.
//

import SwiftUI

// MARK: - FlowLayout

struct FlowLayout: Layout {
    let alignment: Alignment
    let spacingX: Double
    let spacingY: Double
    let fillLineHeight: Bool

    init(
        alignment: Alignment = .leading,
        spacingX: Double = 10,
        spacingY: Double = 10,
        fillLineHeight: Bool = false
    ) {
        self.alignment = alignment
        self.spacingX = spacingX
        self.spacingY = spacingY
        self.fillLineHeight = fillLineHeight
    }
}

// MARK: - Layout Implementation

extension FlowLayout {
    func makeCache(subviews: Subviews) -> LayoutCache? {
        return nil
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout LayoutCache?
    ) -> CGSize {
        let containerWidth = proposal.replacingUnspecifiedDimensions().width
        let calculation = calculateLayout(subviews: subviews, containerWidth: containerWidth)
        cache = calculation
        return calculation.size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout LayoutCache?
    ) {
        let containerWidth = proposal.replacingUnspecifiedDimensions().width
        let calculation = cache?.ifValid(forWidth: containerWidth) ??
                         calculateLayout(subviews: subviews, containerWidth: bounds.width)
        
        for (index, subview) in zip(subviews.indices, subviews) {
            if let cacheItem = calculation.items[index] {
                subview.place(
                    at: bounds.origin + cacheItem.position,
                    proposal: ProposedViewSize(cacheItem.size)
                )
            }
        }
    }

    static var layoutProperties: LayoutProperties {
        var properties = LayoutProperties()
        properties.stackOrientation = .horizontal
        return properties
    }
}

// MARK: - Layout Calculation

private extension FlowLayout {
    func calculateLayout(subviews: Subviews, containerWidth: CGFloat) -> LayoutCache {
        var layoutCache = LayoutCache(targetContainerWidth: containerWidth)
        var currentPosition = CGPoint.zero
        var currentLineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0
        var lines: [LayoutLine] = [LayoutLine(y: 0)]
        
        for (index, subview) in zip(subviews.indices, subviews) {
            let size = subview.sizeThatFits(ProposedViewSize(width: containerWidth, height: nil))
            
            if shouldStartNewLine(currentPosition: currentPosition, itemSize: size, containerWidth: containerWidth) {
                startNewLine(
                    lines: &lines,
                    currentPosition: &currentPosition,
                    currentLineHeight: &currentLineHeight
                )
            } else if !isFirstItemInLine(lines: lines) {
                currentPosition.x += spacingX
            }
            
            addItemToCurrentLine(
                lines: &lines,
                index: index,
                position: currentPosition,
                size: size,
                currentLineHeight: &currentLineHeight,
                maxWidth: &maxWidth,
                containerWidth: containerWidth
            )
            
            currentPosition.x += size.width
        }
        
        applyAlignmentToAllLines(&lines, maxWidth: maxWidth)
        
        layoutCache.size = CGSize(width: maxWidth, height: lines.last?.maxY ?? 0)
        layoutCache.items = consolidateItemsFromLines(lines)
        
        return layoutCache
    }
    
    private func shouldStartNewLine(
        currentPosition: CGPoint,
        itemSize: CGSize,
        containerWidth: CGFloat
    ) -> Bool {
        return currentPosition.x + spacingX + itemSize.width > containerWidth
    }
    
    private func isFirstItemInLine(lines: [LayoutLine]) -> Bool {
        return lines.last?.items.isEmpty == true
    }
    
    private func startNewLine(
        lines: inout [LayoutLine],
        currentPosition: inout CGPoint,
        currentLineHeight: inout CGFloat
    ) {
        currentLineHeight = 0
        currentPosition.x = 0
        currentPosition.y += lines[lines.endIndex - 1].height + spacingY
        lines.append(LayoutLine(y: currentPosition.y))
    }
    
    private func addItemToCurrentLine(
        lines: inout [LayoutLine],
        index: Int,
        position: CGPoint,
        size: CGSize,
        currentLineHeight: inout CGFloat,
        maxWidth: inout CGFloat,
        containerWidth: CGFloat
    ) {
        let lineIndex = lines.endIndex - 1
        lines[lineIndex].items[index] = CacheItem(position: position, size: size)
        
        maxWidth = min(containerWidth, max(maxWidth, position.x + size.width))
        currentLineHeight = max(currentLineHeight, size.height)
        lines[lineIndex].width = position.x + size.width
        lines[lineIndex].height = currentLineHeight
    }
    
    private func applyAlignmentToAllLines(_ lines: inout [LayoutLine], maxWidth: CGFloat) {
        for index in lines.indices {
            lines[index].applyAlignment(
                alignment,
                layoutWidth: maxWidth,
                fillLineHeight: fillLineHeight
            )
        }
    }
    
    private func consolidateItemsFromLines(_ lines: [LayoutLine]) -> [Int: CacheItem] {
        return lines.reduce(into: [Int: CacheItem]()) { result, line in
            result.merge(line.items, uniquingKeysWith: { $1 })
        }
    }
}

// MARK: - Supporting Types

extension FlowLayout {
    struct LayoutCache {
        var targetContainerWidth: Double
        var items: [Int: CacheItem] = [:]
        var size: CGSize = .zero

        func ifValid(forWidth width: Double) -> Self? {
            guard targetContainerWidth == width else {
                return nil
            }
            return self
        }
    }

    struct LayoutLine {
        var y: Double
        var height: Double = 0
        var width: Double = 0
        var items: [Int: CacheItem] = [:]
        
        var maxY: Double {
            y + height
        }

        mutating func applyAlignment(
            _ alignment: Alignment,
            layoutWidth: Double,
            fillLineHeight: Bool
        ) {
            applyVerticalAlignment(alignment, fillLineHeight: fillLineHeight)
            applyHorizontalAlignment(alignment, layoutWidth: layoutWidth)
        }
        
        private mutating func applyVerticalAlignment(_ alignment: Alignment, fillLineHeight: Bool) {
            if fillLineHeight {
                applyFillLineHeight()
            } else {
                applyVerticalAlignmentByPosition(alignment)
            }
        }
        
        private mutating func applyFillLineHeight() {
            for index in items.keys {
                items[index]?.position.y = y
                items[index]?.size.height = height
            }
        }
        
        private mutating func applyVerticalAlignmentByPosition(_ alignment: Alignment) {
            switch alignment.vertical {
            case .center:
                applyCenterVerticalAlignment()
            case .bottom:
                applyBottomVerticalAlignment()
            default:
                break
            }
        }
        
        private mutating func applyCenterVerticalAlignment() {
            let centerY = y + (height / 2)
            for (index, item) in items {
                items[index]?.position.y = centerY - item.size.height / 2
            }
        }
        
        private mutating func applyBottomVerticalAlignment() {
            let bottomY = y + height
            for (index, item) in items {
                items[index]?.position.y = bottomY - item.size.height
            }
        }
        
        private mutating func applyHorizontalAlignment(_ alignment: Alignment, layoutWidth: Double) {
            switch alignment.horizontal {
            case .center:
                applyHorizontalOffset((layoutWidth - width) / 2)
            case .trailing:
                applyHorizontalOffset(layoutWidth - width)
            default:
                break
            }
        }
        
        private mutating func applyHorizontalOffset(_ offset: Double) {
            for index in items.keys {
                items[index]?.position.x += offset
            }
        }
    }

    struct CacheItem {
        var position: CGPoint
        var size: CGSize
    }
}

// MARK: - CGPoint Extension

private extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
