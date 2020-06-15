//
//  CreateUserVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/11/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class EditUserVC: BaseVCCanBack {
    @IBOutlet weak var ivPhone: FInputView!
    @IBOutlet weak var ivAddress: FInputView!
    @IBOutlet weak var ivOther: FInputView!
    @IBOutlet weak var btnCreate: FConfirmButton!
    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        title = "Chỉnh sửa thông tin K/H"
        super.viewDidLoad()
        ivPhone.delegate = self
        ivOther.delegate = self
        ivAddress.delegate = self
        ivPhone.inputKeyboardType = .phonePad
        setupUI()
    }
    
    func setupUI(){
        guard let userInfo = userInfo else {
            goBack()
            return
        }
        ivPhone.value = userInfo.phoneNumber ?? ""
        ivAddress.value = userInfo.address ?? ""
        ivOther.value = userInfo.others ?? ""
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        guard let userInfo = userInfo else {
            goBack()
            return
        }
        
        let userModel = UserInfoModel(username: userInfo.username ?? "", phoneNumber: ivPhone.value, address: ivAddress.value, others: ivOther.value)
        DataHandling().updateUserInfo(userModel: userModel)
        goBack()
    }
    
    private func reloadBtnSubmit(){
           btnCreate.isEnabled = ivPhone.value.count > 0
               && ivAddress.value.count > 0
    }
}

extension EditUserVC: FInputViewDelegate{
    func valueChanged(_ inputView: FInputView, value: String) {
    }
    
    func textFieldDidEndEditing(_ inputView: FInputView) {
        reloadBtnSubmit()
    }
}
