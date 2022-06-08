//
//  GameController.swift
//  ConwayPrj
//
//  Created by Danya on 08/06/2022.
//  Copyright © 2022 Danya. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    var CELL_HEIGHT = 30.0
    var CELL_WIDTH = 30.0
    let STATUS_BAR = UIApplication.shared.statusBarFrame.height
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    var dataSourceDidUpdate = true
    
    override var collectionViewContentSize : CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        
        if !dataSourceDidUpdate {
            
            let xOffset = collectionView!.contentOffset.x
            let yOffset = collectionView!.contentOffset.y
            
            if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
                for section in 0...sectionCount-1 {
                    
                    if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                        
                        if section == 0 {
                            for item in 0...rowCount-1 {
                                
                                let indexPath = IndexPath(item: item, section: section)
                                
                                if let attrs = cellAttrsDictionary[indexPath] {
                                    var frame = attrs.frame
                                    
                                    if item == 0 {
                                        frame.origin.x = xOffset
                                    }
                                    
                                    frame.origin.y = yOffset
                                    attrs.frame = frame
                                }
                            }
                        } else {
                            let indexPath = IndexPath(item: 0, section: section)
                            if let attrs = cellAttrsDictionary[indexPath] {
                                var frame = attrs.frame
                                frame.origin.x = xOffset
                                attrs.frame = frame
                            }
                            
                        }
                    }
                }
            }
            return
        }
        dataSourceDidUpdate = false
        if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
            for section in 0...sectionCount-1 {
                if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                    for item in 0...rowCount-1 {
                        let cellIndex = IndexPath(item: item, section: section)
                        let xPos = Double(item) * CELL_WIDTH
                        let yPos = Double(section) * CELL_HEIGHT
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                        
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        cellAttrsDictionary[cellIndex] = cellAttributes
                        
                    }
                }
                
            }
        }
        
        let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
        let contentHeight = Double(collectionView!.numberOfSections) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
}

