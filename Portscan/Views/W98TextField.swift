//
//  DialogTextField.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 27/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

class W98TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        layer.magnificationFilter = kCAFilterNearest
        borderStyle = .none
        if let image = bgImg(name: "controlbg", withCapInsets: UIEdgeInsetsMake(2, 2, 2, 2)) {
            self.backgroundColor = UIColor(patternImage: image)
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}
