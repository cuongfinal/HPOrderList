//
//  EditProductVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/11/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class EditProductVC: BaseVCCanBack {
    @IBOutlet weak var ivName: FInputView!
    @IBOutlet weak var ivQuantity: FInputView!
    @IBOutlet weak var ivPrice: FInputView!
    @IBOutlet weak var ivPaid: FInputView!
    @IBOutlet weak var lbTotalMoney: UILabel!
    @IBOutlet weak var btnCreateProduct: FConfirmButton!
    @IBOutlet weak var ivNote: FInputView!
    @IBOutlet weak var swProductReturn: SSwitchView!
    var productInfo: ProductInfo?
    var currentProductId = 0
    
    override func viewDidLoad() {
        title = "Cập Nhật Sản Phẩm"
        super.viewDidLoad()

        ivPrice.delegate = self
        ivQuantity.delegate = self
        ivPaid.delegate = self
        ivName.delegate = self
        ivNote.delegate = self
        ivPrice.inputKeyboardType = .numberPad
        ivQuantity.inputKeyboardType = .numberPad
        ivPaid.inputKeyboardType = .numberPad
        setupUI()
    }
    
    func setupUI(){
        guard let productInfo = productInfo else {
            goBack()
            return
        }
        ivName.value = productInfo.name ?? ""
        ivQuantity.value = String(productInfo.quantity)
        ivPrice.value = CommonUtil.convertCurrency(productInfo.price, currency: "")
        ivPaid.value = CommonUtil.convertCurrency(productInfo.paid, currency: "")
        ivNote.value = productInfo.note ?? ""
        swProductReturn.isOn = productInfo.status
        reloadTotalMoney()
    }
    
    @IBAction func createProductTapped(_ sender: Any) {
        guard let productInfo = productInfo else {
            goBack()
            return
        }
        
        let productModel = ProductInfoModel(quantity: Int32(ivQuantity.currencyInputted), price: Int64(ivPrice.currencyInputted), paid: Int64(ivPaid.currencyInputted), status: swProductReturn.isOn , ofUser: productInfo.ofUser, note: ivNote.value, name: ivName.value)
        DataHandling().updateProductInfo(productId: productInfo.productId, productModel: productModel)
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

extension EditProductVC: FInputViewDelegate {
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
            return 0
        }
    }
}

extension EditProductVC: SSwitchViewDelegate {
    func valueChanged(_ switcher: SSwitchView, isOn: Bool) {
        //
    }
}
