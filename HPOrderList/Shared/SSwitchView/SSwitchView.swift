//
//  SSwitchView.swift
//  Savy
//
//  Created by DucNguyen on 6/12/19.
//  Copyright © 2019 TPBank. All rights reserved.
//

import Foundation
import UIKit

protocol SSwitchViewDelegate: class {
    func valueChanged(_ switcher: SSwitchView, isOn: Bool)
}

@IBDesignable
class SSwitchView: BaseXibView {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var customSwitcher: CustomSwitch!
    weak var delegate: SSwitchViewDelegate?
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.inputBorderColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            lbTitle.text = title
        }
    }
    
    @IBInspectable var isOn: Bool = false {
        didSet {
            if isOn != customSwitcher.isOn {
                customSwitcher.isOn = isOn
            }
        }
    }
    
    override func viewSettings() {
        self.backgroundColor = UIColor.whiteThree
        customSwitcher.animationDuration = 0.25
    }
    
    @IBAction func switcherValueChanged(_ sender: Any) {
        isOn = customSwitcher.isOn
        lbTitle.textColor = customSwitcher.isOn ? UIColor.black : UIColor.blueyGrey
        delegate?.valueChanged(self, isOn: isOn)
    }
}
