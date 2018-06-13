//
//  DialogProgressView.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 27/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

@IBDesignable
class W98ProgressView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        layer.magnificationFilter = kCAFilterNearest
        if let image = bgImg(name: "progressbg", withCapInsets: UIEdgeInsetsMake(2, 2, 2, 2)) {
            self.backgroundColor = UIColor(patternImage: image)
        }
    }
}
