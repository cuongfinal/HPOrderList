//
//  AlertVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/19/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//


import Foundation
import UIKit
typealias CompletedClosure = (()->())?
typealias ConfirmClosure = (()->())?

protocol AlertVCDelegate: class {
    func autoPopAlert()
}

class AlertVC : UIAlertController {
    static let shared = AlertVC()
    weak var delegate: AlertVCDelegate?
    
    func confirmAlert(_ title: String?, message: String?, cancelTitle: String,confirmTitle:String, completedClosure: CompletedClosure, confirmClosure: ConfirmClosure) -> UIAlertController {
        let alertVC = UIAlertController.init(title: title,
                                             message: message,
                                             preferredStyle: .alert)
        let titleFont = [NSAttributedString.Key.font: SFProText.semibold(size: 16)]
        let messageFont = [NSAttributedString.Key.font: SFProText.regular(size: 13), .foregroundColor: UIColor.dark]
        if let title = title, let message = message {
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertVC.setValue(titleAttrString, forKey: "attributedTitle")
            alertVC.setValue(messageAttrString, forKey: "attributedMessage")
        }
        let actionCancel = UIAlertAction(title: cancelTitle, style: .default) { (action) in
            completedClosure?()
        }
        actionCancel.setValue(UIColor.dark, forKey: "titleTextColor")
        let actionConfirm = UIAlertAction(title: confirmTitle, style: .default) { (action) in
            confirmClosure?()
        }
        alertVC.addAction(actionCancel)
        alertVC.addAction(actionConfirm)
        alertVC.view.tintColor = UIColor.mainColor
        return alertVC
    }
}

