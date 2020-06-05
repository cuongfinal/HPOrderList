//
//  UserInfoCell.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbPhoneNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configure(){
        //
        //            lbUsername.text = ""
        //
        lbPhoneNumber.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "SĐT: %@", "123456789"), stringSemiBold: "123456789")
        //
        lbAddress.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "Địa chỉ: %@", "Hong pít :|"), stringSemiBold: "Hong pít :|")
    }
}
