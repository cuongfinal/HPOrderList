//
//  SNavigationView.swift
//  Savy
//
//  Created by DucNguyen on 6/12/19.
//  Copyright © 2019 TPBank. All rights reserved.
//

import Foundation
import UIKit

protocol SNavigationViewDelegate: class {
    func touchedOnBackButton()
    func rightBarButtonTapped()
}


class SNavigationView: BaseXibView {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    weak var delegate: SNavigationViewDelegate?
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var titleColor: UIColor = UIColor.white {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    @IBInspectable var isCloseButton: Bool = false {
        didSet {
            isCloseButton ? leftButton.setImage(UIImage.init(named: "icon_close"), for: .normal) : leftButton.setImage(UIImage.init(named: "icon-back"), for: .normal)
        }
    }
    
    @IBInspectable var leftButtonColor: UIColor = UIColor.paleBlue {
        didSet {
            leftButton.tintColor = leftButtonColor
        }
    }
    
    @IBInspectable var showRightButton: Bool = false {
        didSet {
            rightButton.isHidden = !showRightButton
        }
    }
    
    @IBInspectable var rightButtonColor :UIColor = UIColor.white {
        didSet {
            rightButton.setTitleColor(rightButtonColor, for: .normal)
        }
    }
    
    @IBInspectable var rightButtonTitle :String = "" {
        didSet {
            rightButton.setTitle(rightButtonTitle, for: .normal)
        }
    }
    
    override func viewSettings() {
        rightButton.isHidden = true
    }
    
    @IBAction func touchedOnBack(_ sender: Any) {
        delegate?.touchedOnBackButton()
    }
    
    @IBAction func touchOnRightButton(_ sender: Any) {
        delegate?.rightBarButtonTapped()
    }
}
