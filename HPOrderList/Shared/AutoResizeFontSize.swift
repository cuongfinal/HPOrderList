//
//  AutoResizeFontSize.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    override open func awakeFromNib() {
        super.awakeFromNib()
        resizeFont()
    }
    
    private func resizeFont(){
        self.font = UIFont.CustomFont(fontType: self.font.fontName, size: self.font.pointSize)
    }
}

extension UIButton {
    override open func awakeFromNib() {
        super.awakeFromNib()
        resizeFont()
    }
    
    private func resizeFont(){
        if let titleLabel = self.titleLabel {
            titleLabel.font = UIFont.CustomFont(fontType: titleLabel.font.fontName, size: titleLabel.font.pointSize)
        }
    }
}

extension UITextField {
    override open func awakeFromNib() {
        super.awakeFromNib()
        resizeFont()
    }
    
    private func resizeFont(){
        if let font = self.font {
            self.font = UIFont.CustomFont(fontType: font.fontName, size: font.pointSize)
        }
    }
}

extension UITextView {
    override open func awakeFromNib() {
        super.awakeFromNib()
        resizeFont()
    }
    
    private func resizeFont(){
        if let font = self.font {
            self.font = UIFont.CustomFont(fontType: font.fontName, size: font.pointSize)
        }
    }
}
