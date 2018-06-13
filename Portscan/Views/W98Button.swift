//
//  DialogButton.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 27/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class W98Button: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        if let normalImage = bgImg(name: "buttonbg", withCapInsets: UIEdgeInsetsMake(2, 2, 2, 2)) {
            setBackgroundImage(normalImage, for: .normal)
        }
        if let highlightedImage = bgImg(name: "buttonbg_pressed", withCapInsets: UIEdgeInsetsMake(2, 2, 2, 2)) {
            setBackgroundImage(highlightedImage, for: .highlighted)
        }
    }
}
