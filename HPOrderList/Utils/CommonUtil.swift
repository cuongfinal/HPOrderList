//
//  CommonUtils.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit
import SwiftDate

@objc protocol CommonUtilDelegate : NSObjectProtocol {
    @objc func goBack()
}

class CommonUtil : NSObject {
    var delegate : CommonUtilDelegate!
    
    static func viewController(storyboard: String, storyboardID: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardID)
    }
    
    static func convertCurrency(_ price: Int64, currency:String = "") -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        if currency.count > 0 {
            return numberFormatter.string(from: price as NSNumber)?.appendingFormat(" %@", currency) ?? "0"
        }else{
            return numberFormatter.string(from: price as NSNumber) ?? "0"
        }
    }
    
    static func sizeBasedOnWidth(size:CGFloat, screenSize: CGFloat) -> CGFloat{
        return size*(screenSize/MAIN_DESIGN_WIDTH)
    }
    
    static func sizeBasedOnDeviceWidth(size:CGFloat) -> CGFloat{
        return size*(UIScreen.main.bounds.size.width/MAIN_DESIGN_WIDTH)
    }
    
    static func sizeBasedOnHeight(size:CGFloat, screenSize: CGFloat) -> CGFloat{
        return size*(screenSize/MAIN_DESIGN_HEIGHT)
    }
    
    static func sizeBasedOnPercentage(size:CGFloat, percent: CGFloat) -> CGFloat{
        return size*percent
    }
    
    static func push(_ target: UIViewController?, from source: UIViewController?, andCanBack canBack: Bool, hideBottom: Bool = false) {
        target?.hidesBottomBarWhenPushed = hideBottom
        if let target = target {
            source?.navigationController?.pushViewController(target, animated: true)
        }
        if canBack {
            self.addBackBtn(to: target, with: #selector(CommonUtilDelegate.goBack))
        }else{
            target?.navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    
    static func pushWithCompleted(viewController: UIViewController?,
                                  source:UIViewController?,
                                   canBack: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        push(viewController, from: source, andCanBack: canBack)
        CATransaction.commit()
    }
    
    static func popWithCompleted(navCtrl: UINavigationController?,
                                 animated:Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        navCtrl?.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    static func present(_ target: UIViewController?, from source: UIViewController?) {
           var navigationController: UINavigationController? = nil
           if let target = target {
               navigationController = UINavigationController(rootViewController: target)
           }
           if let navigationController = navigationController {
               navigationController.modalPresentationStyle = .overFullScreen
               source?.navigationController?.present(navigationController, animated: true)
           }
    }

    static func popViewController(for vc: UIViewController?) {
        if vc?.navigationController != nil {
            vc?.navigationController?.popViewController(animated: true)
        }
    }
    
    static func popToViewController(for vc: UIViewController?, toVC: UIViewController?) {
        if vc?.navigationController != nil {
            vc?.navigationController?.popToViewController(toVC!, animated: true)
        }
    }
    
    
    static func customNavigationBar(for vc: UIViewController?, withTitle title: String?, hideBackButton: Bool, rightButton: UIBarButtonItem = UIBarButtonItem()) {
        vc?.navigationController?.setNavigationBarHidden(false, animated: true)
        vc?.navigationItem.setHidesBackButton(hideBackButton, animated: false)
        vc?.navigationItem.rightBarButtonItem = rightButton
        
        let lblTitle = UILabel(frame: CGRect.zero)
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.font = SFProText.medium(size: 16)
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor.white
        lblTitle.text = title
        
        vc?.navigationItem.titleView = lblTitle
        lblTitle.sizeToFit()
        
        if rightButton.title?.count ?? 0 > 0 {
            rightButton.setTitleTextAttributes([
                NSAttributedString.Key.font : SFProText.regular(size: 16),
                NSAttributedString.Key.foregroundColor : UIColor.white,
                ], for: .normal)
        }
    }
    
    
    static func showTabbarAtIndex(vc: UIViewController, index: NSInteger){
        if let tabbarCrl:MainTabbarController = vc.tabBarController as? MainTabbarController  {
            tabbarCrl.selectedIndex = index
        }
    }
    
    static func addBackBtn(to vc: UIViewController?, with selector: Selector) {
        let close = UIImage(named: "back-icon")
        vc?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: close, style: .plain, target: vc, action: selector)
        vc?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    static func addLeftBtn(to vc: UIViewController?,imageNamed: String, with selector: Selector) {
        let close = UIImage(named: imageNamed)
        vc?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: close, style: .plain, target: vc, action: selector)
        vc?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    static func addRightBtn(to vc: UIViewController?,imageNamed: String, with selector: Selector) {
        let close = UIImage(named: imageNamed)
        vc?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: close, style: .plain, target: vc, action: selector)
        vc?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    static func willStartAutoBackup() -> Bool {
        let nextUpdate = DateInRegion.init(seconds: getDefaultLastUpdate()).convertTo(region: .current).dateByAdding(3, .day)
        let currentDate = DateInRegion.init(Date(), region: .current)
        if nextUpdate < currentDate && getDefaultAutoBackup() {
            return true
        }
        return false
    }
}

extension CommonUtil {
    static func getDefaultAutoBackup() -> Bool {
        return UserDefaults.standard.bool(forKey: AutoBackUpDefaultKey)
    }
    
    static func setDefaultAutoBackup(state: Bool){
        let ud = UserDefaults.standard
        ud.set(state, forKey: AutoBackUpDefaultKey)
        ud.synchronize()
    }
    
    static func getDefaultLastUpdate() -> Double {
        return UserDefaults.standard.double(forKey: LastUpdateDefaultKey)
    }
    
    static func setDefaultLastUpdate(lastUpdate: TimeInterval){
        let ud = UserDefaults.standard
        ud.set(lastUpdate, forKey: LastUpdateDefaultKey)
        ud.synchronize()
    }
    
    static func getDefaultDisableWaterMark() -> Bool {
        return UserDefaults.standard.bool(forKey: DisableWaterMark)
    }
    
    static func setDefaultDisableWaterMark(state: Bool){
        let ud = UserDefaults.standard
        ud.set(state, forKey: DisableWaterMark)
        ud.synchronize()
    }
    
    static func getDefaultWaterMark() -> Data? {
        return UserDefaults.standard.data(forKey: DefaultWaterMark)
    }
    
    static func setDefaultWaterMark(data: Data){
        let ud = UserDefaults.standard
        ud.set(data, forKey: DefaultWaterMark)
        ud.synchronize()
    }
}

