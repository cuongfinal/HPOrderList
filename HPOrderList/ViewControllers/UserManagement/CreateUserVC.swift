//
//  CreateUserVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/11/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class CreateUserVC: BaseVCCanBack {
    @IBOutlet weak var ivName: FInputView!
    @IBOutlet weak var ivPhone: FInputView!
    @IBOutlet weak var ivAddress: FInputView!
    @IBOutlet weak var btnCreate: FConfirmButton!
    
    override func viewDidLoad() {
        title = "Tạo Khách Hàng Mới"
        super.viewDidLoad()
        ivName.delegate = self
        ivPhone.delegate = self
        ivAddress.delegate = self
        ivPhone.inputKeyboardType = .phonePad
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        
    }
    
    private func reloadBtnSubmit(){
           btnCreate.isEnabled = ivName.value.count > 0
               && ivPhone.value.count > 0
               && ivAddress.value.count > 0
    }
}

extension CreateUserVC: FInputViewDelegate{
    func valueChanged(_ inputView: FInputView, value: String) {
    }
    
    func textFieldDidEndEditing(_ inputView: FInputView) {
        reloadBtnSubmit()
    }
}
