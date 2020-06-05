//
//  UIViewController.swift
//  HPOrderList
//
//  Created by Cuong Le on 4/22/20.
//  Copyright © 2020 TPBank. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func present(_ viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    open func dismiss(completion: (() -> ())? = nil) {
        dismiss(animated: true, completion: completion)
    }
    
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func presentModal(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
