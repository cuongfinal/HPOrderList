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
    @IBOutlet weak var lbOthers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configure(userInfo: UserInfo){
        lbUsername.text = userInfo.username
        lbPhoneNumber.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "SĐT: %@", userInfo.phoneNumber ?? ""), stringSemiBold: userInfo.phoneNumber ?? "")
        //
        lbAddress.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "Địa chỉ: %@", userInfo.address ?? ""), stringSemiBold: userInfo.address ?? "")
        
        //
        let otherStr = (userInfo.others ?? "").count > 0 ? userInfo.others : "Không có"
        lbOthers.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "Thông tin khác: %@", otherStr ?? ""), stringSemiBold: otherStr ?? "")
    }
}
