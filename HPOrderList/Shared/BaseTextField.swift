//
//  BaseTextField.swift
//  FICO
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import Foundation
import UIKit

protocol BaseTextFieldDelegate {
    func textFieldDidDeleteEmpty()
}

class BaseTextField: UITextField {
    var myDelegate: BaseTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDeleteEmpty()
    }
}




