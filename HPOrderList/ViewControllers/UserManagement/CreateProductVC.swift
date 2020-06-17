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
    @IBOutlet weak var ivQuantity: FInputView!
    @IBOutlet weak var ivPrice: FInputView!
    @IBOutlet weak var ivPaid: FInputView!
    @IBOutlet weak var lbTotalMoney: UILabel!
    @IBOutlet weak var btnCreateProduct: FConfirmButton!
    @IBOutlet weak var ivNote: FInputView!
    @IBOutlet weak var swProductReturn: SSwitchView!
    var userInfo : UserInfo?
    
    override func viewDidLoad() {
        title = "Thêm Sản Phẩm"
        super.viewDidLoad()

        ivPrice.delegate = self
        ivQuantity.delegate = self
        ivPaid.delegate = self
        ivName.delegate = self
        ivNote.delegate = self
        swProductReturn.delegate = self
        ivPrice.inputKeyboardType = .numberPad
        ivQuantity.inputKeyboardType = .numberPad
        ivPaid.inputKeyboardType = .numberPad
    }
    
    @IBAction func createProductTapped(_ sender: Any) {
        let productModel = ProductInfoModel(quantity: Int32(ivQuantity.currencyInputted), price: Int64(ivPrice.currencyInputted), paid: Int64(ivPaid.currencyInputted), status: swProductReturn.isOn , ofUser: userInfo, note: ivNote.value, name: ivName.value)
        DataHandling().addProduct(productModel: productModel)
        goBack()
    }
    
    private func reloadTotalMoney() {
        lbTotalMoney.text = CommonUtil.convertCurrency(Int64((ivPrice.currencyInputted * (Int(ivQuantity.value) ?? 0)) - ivPaid.currencyInputted), currency: "VND")
    }
    
    private func reloadBtnSubmit(){
        btnCreateProduct.isEnabled = ivPrice.value.count > 0
            && ivQuantity.value.count > 0
            && ivPrice.value.count > 0
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
        if inputView == ivQuantity {
            return 4
        }else if inputView == ivPrice || inputView == ivPaid{
            return 12
        }else {
            return 100
        }
    }
}

extension CreateProductVC: SSwitchViewDelegate {
    func valueChanged(_ switcher: SSwitchView, isOn: Bool) {
        //
    }
}
