//
//  FConfirmButton.swift
//  FICO
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/21/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class FConfirmButton: RoundedButton {
    
    override var isEnabled: Bool {
        didSet{
            reloadBackgroundColor()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadBackgroundColor()
    }
    
    private func reloadBackgroundColor() {
        backgroundColor = isEnabled  ? UIColor.mainColor : UIColor.veryLightBlue
    }
}
