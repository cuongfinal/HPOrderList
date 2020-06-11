//
//  CreateProductVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/11/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class CreateProductVC: BaseVCCanBack {
    @IBOutlet weak var ivName: FInputView!
    @IBOutlet weak var ivQuality: FInputView!
    @IBOutlet weak var ivPrice: FInputView!
    @IBOutlet weak var ivPaid: FInputView!
    @IBOutlet weak var lbTotalMoney: UILabel!
    @IBOutlet weak var btnCreateProduct: FConfirmButton!
    
    override func viewDidLoad() {
        title = "Thêm Sản Phẩm  "
        super.viewDidLoad()

        ivPrice.delegate = self
        ivQuality.delegate = self
        ivPaid.delegate = self
        ivName.delegate = self
        
        ivPrice.inputKeyboardType = .numberPad
        ivQuality.inputKeyboardType = .numberPad
        ivPaid.inputKeyboardType = .numberPad
    }
    
    @IBAction func createProductTapped(_ sender: Any) {
    }
    
    private func reloadTotalMoney() {
        lbTotalMoney.text = CommonUtil.convertCurrency(Int64((ivPrice.currencyInputted * (Int(ivQuality.value) ?? 0)) - ivPaid.currencyInputted), currency: "VND")
    }
    
    private func reloadBtnSubmit(){
        btnCreateProduct.isEnabled = ivPrice.value.count > 0
            && ivQuality.value.count > 0
            && ivPrice.value.count > 0
            && ivPaid.value.count > 0
    }
}

extension CreateProductVC: FInputViewDelegate {
    func valueChanged(_ inputView: FInputView, value: String) {
        reloadTotalMoney()
    }
    
    func textFieldDidEndEditing(_ inputView: FInputView) {
        reloadBtnSubmit()
    }
    func maxCharacter(_ inputView: FInputView) -> Int {
        if inputView == ivQuality {
            return 4
        }else if inputView == ivPrice || inputView == ivPaid{
            return 12
        }else {
            return 0
        }
    }
}
