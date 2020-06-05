//
//  UIFont.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import UIKit

enum FontWeight {
    case medium
    case light
    case semibold
    case regular
}

enum FontType: String {
    case DEFAULT_FONT_TEXT_LIGHT        = "SFProText-Light"
    case DEFAULT_FONT_TEXT_SEMIBOLD     = "SFProText-Semibold"
    case DEFAULT_FONT_TEXT_MEDIUM       = "SFProText-Medium"
    case DEFAULT_FONT_TEXT_REGULAR      = "SFProText-Regular"
    case DEFAULT_FONT_DISPLAY_LIGHT     = "SFProDisplay-Light"
    case DEFAULT_FONT_DISPLAY_SEMIBOLD  = "SFProDisplay-Semibold"
    case DEFAULT_FONT_DISPLAY_MEDIUM    = "SFProDisplay-Medium"
    case DEFAULT_FONT_DISPLAY_REGULAR   = "SFProDisplay-Regular"
    
    func weight() -> FontWeight {
        switch self {
        case .DEFAULT_FONT_TEXT_LIGHT, .DEFAULT_FONT_DISPLAY_LIGHT:
            return .light
        case .DEFAULT_FONT_TEXT_SEMIBOLD, .DEFAULT_FONT_DISPLAY_SEMIBOLD:
            return .semibold
        case .DEFAULT_FONT_TEXT_REGULAR, .DEFAULT_FONT_DISPLAY_REGULAR:
            return .regular
        default:
            return .medium
        }
    }
}

enum SFProText {
    static func light(size: CGFloat) -> UIFont {
        return UIFont.CustomFont(fontType: FontType.DEFAULT_FONT_TEXT_LIGHT.rawValue, size: size)
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont.CustomFont(fontType: FontType.DEFAULT_FONT_TEXT_MEDIUM.rawValue, size: size)
    }
    
    static func semibold(size: CGFloat) -> UIFont {
        return UIFont.CustomFont(fontType: FontType.DEFAULT_FONT_TEXT_SEMIBOLD.rawValue, size: size)
    }
    
    static func regular(size: CGFloat) -> UIFont {
        return UIFont.CustomFont(fontType: FontType.DEFAULT_FONT_TEXT_REGULAR.rawValue, size: size)
    }
}

extension UIFont {
    static func CustomFont(fontType: String, size: CGFloat) -> UIFont {
        var fontSize: CGFloat = size
        
        fontSize = CommonUtil.sizeBasedOnDeviceWidth(size: fontSize)
        if let font = UIFont.init(name: fontType, size: fontSize) {
            return font
        }
        return UIFont.systemFont(ofSize: fontSize)
    }
}

