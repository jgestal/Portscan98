//
//  DialogGroupView.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 27/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class W98GroupView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.layer.magnificationFilter = kCAFilterNearest
        if let image = bgImg(name: "groupbg", withCapInsets: UIEdgeInsetsMake(3, 3, 3, 3)) {
            self.backgroundColor = UIColor(patternImage: image)
        }
    }
}
