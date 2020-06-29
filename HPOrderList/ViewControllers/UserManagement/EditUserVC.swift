//
//  CreateUserVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/11/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class EditUserVC: BaseVCCanBack {
    @IBOutlet weak var ivName: FInputView!
    @IBOutlet weak var ivAddress: FInputView!
    @IBOutlet weak var ivOther: FInputView!
    @IBOutlet weak var btnCreate: FConfirmButton!
    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        title = "Chỉnh sửa thông tin K/H"
        super.viewDidLoad()
        ivName.delegate = self
        ivOther.delegate = self
        ivAddress.delegate = self
    
        setupUI()
    }
    
    func setupUI(){
        guard let userInfo = userInfo else {
            goBack()
            return
        }
        ivName.value = userInfo.username ?? ""
        ivAddress.value = userInfo.address ?? ""
        ivOther.value = userInfo.others ?? ""
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        guard let userInfo = userInfo else {
            goBack()
            return
        }
        
        let userModel = UserInfoModel(username: ivName.value, phoneNumber: userInfo.phoneNumber ?? "", address: ivAddress.value, others: ivOther.value)
        DataHandling().updateUserInfo(userModel: userModel){ result in
            if !result.success {
                self.present(AlertVC.shared.warningAlert("alert_fail_title".localized(), message: result.message, cancelTitle: "Đóng", completedClosure: nil))
            }else{
                self.goBack()
            }
        }
    }
    
    private func reloadBtnSubmit(){
           btnCreate.isEnabled = ivName.value.count > 0
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
