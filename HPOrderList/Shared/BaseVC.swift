//
//  BaseVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 4/20/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    var rightButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.bgColor
        let titleName = self.title?.count ?? 0 > 0 ? self.title : self.navigationItem.title
        CommonUtil.customNavigationBar(for: self, withTitle: titleName, hideBackButton: false, rightButton: rightButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    func addRightButton(imageName: String) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(actionRightBar), for: .touchUpInside)
        let size = CommonUtil.sizeBasedOnDeviceWidth(size: 24)
        button.frame = CGRect.init(x: 0, y: 0, width: size, height: size)
        rightButton = UIBarButtonItem(customView: button)
        
    }
    
    @objc func actionRightBar(sender: UIBarButtonItem) {
        //override it to execute
    }
    
}

struct NavigationBar {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
    static func resetClearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(nil, for: .default)
        navBar.shadowImage = nil
        navBar.isTranslucent = false
    }
}

class BaseVCCanBack: BaseVC, CommonUtilDelegate {
    func goBack() {
        CommonUtil.popViewController(for: self)
    }
}
