//
//  NSMutableAttributedString.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setFont(font: UIFont, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
    
    func setLink(link: String, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.link, value: link, range: range)
    }
    
    func attributedHalfOfString(fullString: String, stringSemiBold: String, stringSemiboldColor: UIColor = .dark) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
               paragraphStyle.alignment = .left
               
        let attributedString = NSMutableAttributedString(string: fullString, attributes: [
            .font: SFProText.regular(size: 12),
            .foregroundColor: UIColor.dark,
            .kern: 0.0,
            .paragraphStyle: paragraphStyle
            ])
        attributedString.setColor(color: stringSemiboldColor, forText: stringSemiBold)
        attributedString.setFont(font: SFProText.semibold(size: 12.0), forText: stringSemiBold)
        return attributedString
    }
}
