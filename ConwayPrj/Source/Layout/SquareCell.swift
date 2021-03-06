//
//  GameController.swift
//  ConwayPrj
//
//  Created by Danya on 08/06/2022.
//  Copyright © 2022 Danya. All rights reserved.
//

import UIKit

@IBDesignable
class SquareCell: UICollectionViewCell {
    
    public var row:Int?
    public var col:Int?
    public var live:Bool?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.live = false
    }
    
    func change(_ state:Bool) {
        self.backgroundColor = state ? UIColor.black : UIColor.white
        self.live = state
    }
}


