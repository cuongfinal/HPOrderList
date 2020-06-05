//
//  BaseNavigationVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationVC: UINavigationController {
    override func viewDidLoad() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = UIColor.mainColor
    }
 
}
