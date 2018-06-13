//
//  String+Reg.swift
//  Portscan
//
//  Created by Juan Gestal Romani on 29/5/18.
//  Copyright © 2018 Juan Gestal Romani. All rights reserved.
//

import Foundation

extension String {
    static func isValidHost(hostStr: String) -> Bool {
        let isHost = hostStr.range(of: "^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", options: .regularExpression) != nil
        let isIp = hostStr.range(of: "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", options: .regularExpression) != nil
        print("Is host \(isHost) is IP: \(isIp)")
        return isHost || isIp
    }
}
