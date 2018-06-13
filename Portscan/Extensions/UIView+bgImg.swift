//
//  UIView+bgImg.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 12/6/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit

extension UIView {
    
    func bgImg(name: String, withCapInsets capInsets: UIEdgeInsets) -> UIImage? {
        let bg = UIImage(named: name)?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
        UIGraphicsBeginImageContext(frame.size)
        bg?.draw(in: bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
