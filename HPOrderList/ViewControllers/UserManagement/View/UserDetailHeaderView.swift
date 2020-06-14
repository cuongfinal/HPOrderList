//
//  UserDetailHeaderView.swift
//  savy
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 5/14/20.
//  Copyright © 2020 Backbase. All rights reserved.
//

import UIKit

var kTableHeaderHeight:CGFloat = CommonUtil.sizeBasedOnDeviceWidth(size: 270)
var kNavigationSize = CommonUtil.sizeBasedOnDeviceWidth(size: 170)

@IBDesignable class UserDetailHeaderView: UIView {
    
    @IBOutlet weak var lbTotalMoney: UILabel!
    @IBOutlet weak var lbTotalRemain: UILabel!
    @IBOutlet weak var lbTotalPaid: UILabel!
    @IBOutlet weak var btnListTable: RoundedButton!
    @IBOutlet weak var btnGridTable: RoundedButton!

    @IBOutlet weak var underlineBtn: UIView!{
        didSet{
            underlineBtn.translatesAutoresizingMaskIntoConstraints = true
        }
    }
    @IBOutlet weak var stackViewBtn: UIStackView!
    @IBOutlet weak var navigationView: SNavigationView!
    
    
    func updateHeaderView(scrollView: UIScrollView?) {
        if let scrollView = scrollView {
            if scrollView.contentOffset.y < -kTableHeaderHeight {
                frame.size.height = -scrollView.contentOffset.y
            } else if scrollView.contentOffset.y >= -kTableHeaderHeight && scrollView.contentOffset.y < -kNavigationSize {
                frame.size.height = -scrollView.contentOffset.y
            } else {
                frame.size.height = kNavigationSize
            }
        }
        
        //View status change frame animation, width increase slow by 50%
        let progress = (frame.height - kNavigationSize)/(kTableHeaderHeight - kNavigationSize)
        lbTotalRemain.alpha = progress
        lbTotalPaid.alpha = progress
        lbTotalMoney.alpha = progress
    }
    
    func updateUnderlinePosition(selectedButton: UIButton){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            var newFrame = self.underlineBtn.frame
            newFrame.origin.x = selectedButton.frame.origin.x + self.stackViewBtn.frame.minX
            self.underlineBtn.frame = newFrame
        }, completion: nil)
    }
}
