//
//  DialogProgressViewController.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 27/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class W98ProgressViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.isHidden = true
        updateProgress(0)
    }
    
    func updateProgress(_ progress: CGFloat) {
        let width = (view.frame.width - 4) * (progress > 1 ? 1 : progress)
        label.isHidden = progress == 0 ? true : false
        progressView.frame = CGRect(x: 2, y: 1, width: width, height: view.frame.height - 2)
        label.textColor = progress > 0.5 ? .white : .black
        label.text = String(format: "%.0f", progress * 100) + "%"
    }
}
