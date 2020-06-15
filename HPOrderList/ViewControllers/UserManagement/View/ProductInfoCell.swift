//
//  ProductInfoCell.swift
//  HPOrderList
//
//  Created by Cuong Le on 6/14/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

protocol ProductInfoCellDelegate {
    func editTapped()
}
class ProductInfoCell: UITableViewCell {
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbPaid: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbNote: UILabel!
    
    var delegate : ProductInfoCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(productInfo: ProductInfo){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        lbProductName.text = productInfo.name
        lbQuantity.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "Số lượng: %d", productInfo.quantity ), stringSemiBold: String(productInfo.quantity))
        //
        lbPrice.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "Giá SP: %@", CommonUtil.convertCurrency(productInfo.price)), stringSemiBold: CommonUtil.convertCurrency(productInfo.price))
        
        //
        lbPaid.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "Tiền cọc: %@", CommonUtil.convertCurrency(productInfo.paid)), stringSemiBold: CommonUtil.convertCurrency(productInfo.paid))
        //
        let statusStr = productInfo.status ? "Đã trả hàng" : "Chưa trả hàng"
        let colorStatus = productInfo.status ? UIColor.dark : UIColor.mainColor
        lbStatus.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "Trạng thái: %@", statusStr), stringSemiBold: statusStr, stringSemiboldColor: colorStatus)
        
        let noteStr = productInfo.note!.count > 0 ? productInfo.note : "Không có"
        lbNote.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "Ghi chú: %@", noteStr ?? ""), stringSemiBold: noteStr ?? "")
    }
}
