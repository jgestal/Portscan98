//
//  DialogHelpButton.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 27/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit
class W98HelpButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        layer.magnificationFilter = kCAFilterNearest
        if let normalImage = bgImg(name: "button_help", withCapInsets: UIEdgeInsetsMake(2, 2, 2, 2)) {
                 setBackgroundImage(normalImage, for: .normal)
        }
        if let highlightedImage = bgImg(name: "button_help_pressed", withCapInsets: UIEdgeInsetsMake(2, 2, 2, 2)) {
                setBackgroundImage(highlightedImage, for: .highlighted)
        }
    }
}
