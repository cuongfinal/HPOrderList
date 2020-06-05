//
//  CALayer.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import UIKit

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        offset: CGPoint = CGPoint(x: 0, y: 2),
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: offset.x, height: offset.y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
        
        masksToBounds = false
    }
}
