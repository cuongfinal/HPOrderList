//
//  SSwicher.swift
//  Savy
//
//  Created by CuongFinal on 6/15/19.
//  Copyright © 2019 TPBank. All rights reserved.
//

import UIKit

class SSwicher: UISwitch {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpSwicher()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpSwicher()
    }
    
    func setUpSwicher(){
        //UISwich on state color
        self.onTintColor = UIColor.mainColor
        //UISwich off state color
        self.backgroundColor = UIColor.blueyGrey
        self.tintColor = UIColor.blueyGrey
        self.layer.cornerRadius = self.frame.height/2.0
        
    }

}
