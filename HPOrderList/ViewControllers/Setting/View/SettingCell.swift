//
//  SettingCell.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

enum SettingCellType{
    case none
    case switcher
}

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switcherView: UISwitch!
    @IBOutlet weak var imgArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(type: SettingCellType){
        switcherView.isHidden = true
        imgArrow.isHidden = false
        if type == .switcher {
            switcherView.isHidden = false
            imgArrow.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
