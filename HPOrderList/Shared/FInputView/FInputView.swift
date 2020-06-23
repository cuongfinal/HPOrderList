//
//  FInputView.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import UIKit

import Foundation

enum FIputRightType: Int {
    case none = 0
    case regular
    case bold
    case password
}

@objc protocol FInputViewDelegate: class {
    func valueChanged(_ inputView: FInputView, value: String)
    func textFieldDidEndEditing(_ inputView: FInputView)
    @objc optional func maxCharacter(_ inputView: FInputView) -> Int
    @objc optional func formattedString(_ inputView: FInputView, currentString: String?) -> String?
    @objc optional func titleFont(_ inputView: FInputView, currentString: String) -> UIFont?
    @objc optional func valueFont(_ inputView: FInputView, currentString: String) -> UIFont?
}

@IBDesignable
class FInputView: BaseXibView {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtInput: BaseTextField!
    weak var delegate: FInputViewDelegate?
    var currencyInputted  = 0
    var btnViewPass: UIButton?
    
    @IBOutlet weak var stackViewRight: UIStackView!
    @IBOutlet weak var lbRegular: UILabel!
    @IBOutlet weak var lbBold: UILabel!
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.inputBorderColor {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            lbTitle.text = title
        }
    }
    
    @IBInspectable var placeHolder: String = "" {
        didSet {
            txtInput.placeholder = placeHolder
        }
    }
    
    @IBInspectable var inputKeyboardType: UIKeyboardType = .asciiCapable {
        didSet {
            txtInput.keyboardType = inputKeyboardType
        }
    }
    
    @IBInspectable var value: String = "" {
        didSet {
            if value != txtInput.text {
                txtInput.text = value
            }
            if let number = Int(value.replacingOccurrences(of: ",", with: "")){
                currencyInputted = number
            }
            hasTitle = txtInput.text?.count ?? 0 > 0
            title = placeHolder
            delegate?.valueChanged(self, value: value)
        }
    }
    
    @IBInspectable var hasTitle: Bool = false {
        didSet {
            lbTitle.isHidden = !hasTitle
        }
    }
    

    @IBInspectable var rightType: Int = 0 {
        didSet {
            reloadRightView()
        }
    }
    
    @IBInspectable var rightTitle: String = "" {
        didSet {
            reloadRightView()
        }
    }
    
    @IBInspectable var nonUnicode: Bool = true
    
    
    override func draw(_ rect: CGRect) {
        let borderPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        UIColor.clear.set()
        borderPath.fill()
    }
    
    private func reloadRightView() {
        let rightViewType = FIputRightType.init(rawValue: rightType) ?? .none
        stackViewRight.isHidden = (rightViewType == .none || rightViewType == .password)
        lbRegular.isHidden = true
        lbBold.isHidden = true
        
        switch rightViewType {
        case .regular:
            lbRegular.text = rightTitle
            lbRegular.isHidden = false
        case .bold:
            lbBold.text = rightTitle
            lbBold.isHidden = false
        case .password:
            txtInput.rightViewMode = .always
            txtInput.isSecureTextEntry = true
            let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
            
            btnViewPass = UIButton.init(frame: rightView.frame)
            if let btnViewPass = btnViewPass {
                btnViewPass.setImage(UIImage.init(named: "eye-password"), for: .normal)
                btnViewPass.tintColor = UIColor.mainColor
                btnViewPass.addTarget(self, action: #selector(showPass), for: .touchUpInside)
                rightView.addSubview(btnViewPass)
            }
            
            txtInput.rightView = rightView
        default:
            break
        }
    }
    
    @IBInspectable var isCurrencyValue: Bool = false
    
    override func viewSettings() {
        self.backgroundColor = UIColor.whiteThree
        reloadRightView()
        txtInput.keyboardType = inputKeyboardType
        txtInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtInput.delegate = self
        txtInput.myDelegate = self
        
        txtInput.font = delegate?.valueFont?(self, currentString: value) ?? SFProText.regular(size: 16)
        lbTitle.font = delegate?.titleFont?(self, currentString: value) ?? SFProText.regular(size: 12)
        
        txtInput.textColor = UIColor.dark
        lbTitle.textColor = UIColor.darkGray
    }
    
    @objc func showPass() {
        txtInput.isSecureTextEntry = !txtInput.isSecureTextEntry
        if let btnViewPass = btnViewPass {
            txtInput.isSecureTextEntry ? btnViewPass.setImage(UIImage.init(named: "eye-password"), for: .normal) : btnViewPass.setImage(UIImage.init(named: "eye-password-inactive"), for: .normal)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let formattedString = delegate?.formattedString?(self, currentString: textField.text) {
            textField.text = formattedString
        }
        
//        if nonUnicode {
//            textField.text = textField.text?.removingUnicode()
//        }
        
        if isCurrencyValue {
            //save value inputted for using after that
            if let text = textField.text, let number = Int(text.replacingOccurrences(of: ",", with: "")) {
                currencyInputted = number
                value = CommonUtil.convertCurrency(Int64(number), currency: "")
            }else{
                value = ""
                currencyInputted = 0
            }
        }else{
            value = textField.text ?? ""
        }
        
        setRegularText(textLength: textField.text?.count ?? 0)
    }
    
    func setRegularText(textLength: Int){
        if let maxLength = delegate?.maxCharacter?(self), !lbRegular.isHidden {
            lbRegular.text = String(format: "%@/%@", String(textLength), String(maxLength))
        }
    }
}

extension FInputView : UITextFieldDelegate, BaseTextFieldDelegate {
    func textFieldDidDeleteEmpty() {
        //Hide title when backward to empty string
        hasTitle = value.count > 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        value = textField.text ?? ""
        //Hide title when backward to empty string
        hasTitle = value.count > 0
        delegate?.textFieldDidEndEditing(self)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        
        let format = "[A-Z0-9a-z ]{1,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", format)
        if !predicate.evaluate(with: string){
            return false
        }
        
        //Show title = placeholder when start input sth
        hasTitle = string.count > 0  && !string.contains { $0.isNewline }
        title = placeHolder
        
        if let count = delegate?.maxCharacter?(self), count > 0 {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= count
        }
        return true
    }
}
