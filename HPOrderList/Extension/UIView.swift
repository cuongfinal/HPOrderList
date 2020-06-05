//
//  UIView.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/27/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    private static var _hasErrorShown = [String:Bool]()
    
    var hasErrorShown:Bool {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIView._hasErrorShown[tmpAddress] ?? false
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIView._hasErrorShown[tmpAddress] = newValue
        }
    }
}
