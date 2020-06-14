//
//  FRoundedButton.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import Foundation
import UIKit

enum CornerType: Int {
    case all = 0
    case topCorner
    case bottomCorner
}

@IBDesignable class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            clipsToBounds = true
            let cornerRadiusValue = cornerRadius == -1 ? self.bounds.size.height/2 : CommonUtil.sizeBasedOnDeviceWidth(size: cornerRadius)
            layer.cornerRadius = cornerRadiusValue
        }
    }
    
    @IBInspectable var borderColorDisable: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColorDisable.cgColor
        }
    }
    
    @IBInspectable var borderColorNormal: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColorNormal.cgColor
        }
    }
    
    @IBInspectable var bgColorNormal: UIColor = UIColor.mainColor {
        didSet {
            backgroundColor = bgColorNormal
        }
    }
    
    @IBInspectable var bgColorDisable: UIColor = UIColor.veryLightBlue {
        didSet {
            backgroundColor = bgColorDisable
        }
    }
    
    @IBInspectable var useMultiline: Bool = false
    @IBInspectable var useDropShadow: Bool = false
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowAlpha: Float = 0.5
    @IBInspectable var shadowBlur: CGFloat = 2
    @IBInspectable var shadowOffset: CGPoint = CGPoint(x: 0, y: 2)
    @IBInspectable var shadowSpread: CGFloat = 0
    
    @IBInspectable var titleColor: UIColor = UIColor.white
    @IBInspectable var groupButtonEnable: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // for InterfaceBuilder
        setup()
    }
    
    override var isSelected: Bool {
        didSet {
            reloadBackgroundColor()
        }
    }
    
    func setStyleNoBG() {
        if self.isSelected {
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor.mainColor, for: .normal)
        } else {
            self.setTitleColor(UIColor.blueyGrey, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        reloadBackgroundColor()
        let cornerRadiusValue = cornerRadius == -1 ? self.bounds.size.height/2 : CommonUtil.sizeBasedOnDeviceWidth(size: cornerRadius)
        layer.cornerRadius = cornerRadiusValue
    }
    
    private func setup() {
        if useMultiline {
            self.titleLabel?.lineBreakMode = .byWordWrapping
            self.titleLabel?.numberOfLines = 0
            self.titleLabel?.textAlignment = NSTextAlignment.center
        }
        
        if useDropShadow {
            layer.applySketchShadow(color: shadowColor, alpha: shadowAlpha, offset: shadowOffset, blur: shadowBlur, spread: shadowSpread)
        }
    }
    
    func setGradient(colorSet: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorSet
        gradientLayer.frame.size = layer.frame.size
        gradientLayer.frame.origin = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius = layer.cornerRadius
        if let _ = (self.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            return
        }else {
            self.layer.insertSublayer(gradientLayer, at: 0)
            self.layer.masksToBounds = true
        }
    }
    
    func removeGradient (){
        if let gradient = (self.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            gradient.removeFromSuperlayer()
        }
    }
    
    func setupInSender() {
        self.setup()
    }
    
    override var isEnabled: Bool {
        didSet {
            reloadBackgroundColor()
        }
    }
    
    private func reloadBackgroundColor() {
        layer.borderColor = isEnabled ? borderColorNormal.cgColor : borderColorDisable.cgColor
        isEnabled ? setTitleColor(titleColor, for: .normal) : setTitleColor(UIColor.white, for: .normal)
        backgroundColor = isEnabled ? bgColorNormal : bgColorDisable
        if groupButtonEnable {
            setStyleNoBG()
        }
    }
}

@IBDesignable class RoundedImage: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            clipsToBounds = true
            let cornerRadiusValue = cornerRadius == -1 ? self.bounds.size.height/2 : CommonUtil.sizeBasedOnDeviceWidth(size: cornerRadius)
            layer.cornerRadius = cornerRadiusValue
        }
    }
    
    func setUp(){
        
    }
}

@IBDesignable class RoundedView : UIView {
    
    @IBInspectable var cornerRadiusValue: Int = 0
    @IBInspectable var cornerType: Int = CornerType.all.rawValue {
        didSet {
            roundCorners()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners()
    }
    
    func roundCorners() {
        if #available(iOS 11.0, *) {
            
            self.clipsToBounds = true
            self.layer.cornerRadius = CGFloat(cornerRadiusValue)
            
            switch cornerType {
            case CornerType.all.rawValue:
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case CornerType.topCorner.rawValue:
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            default:
                self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

@IBDesignable class EllipseView: UIView {
    var imageView: UIImageView!
    
    @IBInspectable var roundRadius: CGFloat = 60
    
    @IBInspectable var isSelected: Bool = true
    
    //    override func draw(_ rect: CGRect) {
    //        let dotPath = UIBezierPath(ovalIn:rect)
    //        let shapeLayer = CAShapeLayer()
    //        shapeLayer.path = dotPath.cgPath
    //        shapeLayer.fillColor = mainColor.cgColor
    //        layer.addSublayer(shapeLayer)
    //
    //        if (isSelected) {
    //            drawRingFittingInsideView(rect: rect)
    //        }
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        doMyInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doMyInit()
    }
    
    func doMyInit() {
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.mainColor
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        
        let rect = self.bounds
        let y:CGFloat = rect.size.height - CommonUtil.sizeBasedOnDeviceWidth(size: roundRadius)
        let curveTo:CGFloat = rect.size.height
        
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y))
        myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: curveTo))
        myBezier.addLine(to: CGPoint(x: rect.width, y: 0))
        myBezier.addLine(to: CGPoint(x: 0, y: 0))
        myBezier.close()
        
        let maskForPath = CAShapeLayer()
        maskForPath.path = myBezier.cgPath
        layer.mask = maskForPath
        
    }
    //
    //    internal func drawRingFittingInsideView(rect: CGRect) {
    //        let hw:CGFloat = ringThickness/2
    //        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw,dy: hw) )
    //
    //        let shapeLayer = CAShapeLayer()
    //        shapeLayer.path = circlePath.cgPath
    //        shapeLayer.fillColor = UIColor.clear.cgColor
    //        shapeLayer.strokeColor = ringColor.cgColor
    //        shapeLayer.lineWidth = ringThickness
    //        layer.addSublayer(shapeLayer)
    //    }
}
