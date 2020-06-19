//
//  UserDetailVC.swift
//  HPOrderList
//
//  Created by Cuong Le on 6/14/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class UserDetailVC: BaseVC {
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var viewMainAction: UIView!
    @IBOutlet weak var btnMainAction: RoundedButton!
    
    var headerView: UserDetailHeaderView!
    var btnController: SSRadioButtonsController?
    var userInfo: UserInfo?
    var dataSource = [ProductInfo]()
    var listTable = ListProductTableVC()
    var totalMoney: Int64 = 0
    var paidMoney: Int64 = 0
    var remainingMoney: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUIHeader()
        setupSelectedTableTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: handle hide when searchBar is active?
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func calculateMomey(){
        totalMoney = 0
        paidMoney = 0
        remainingMoney = 0
        for product in dataSource {
            if !product.status {
                totalMoney += (product.price * Int64(product.quantity))
                paidMoney +=  product.paid
                remainingMoney += (product.price * Int64(product.quantity)) - product.paid
            }
        }
        
        let totalMoneyStr = CommonUtil.convertCurrency(totalMoney)
        let stringColor = UIColor.white
        headerView.lbTotalMoney.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "total_money".localized(), totalMoneyStr),
                                                                                                    stringSemiBold: totalMoneyStr,
                                                                                                    fullStringColor: stringColor,
                                                                                                    stringSemiboldColor: stringColor,
                                                                                                    fullStringFont: SFProText.regular(size: 15),
                                                                                                    stringSemiboldFont: SFProText.semibold(size: 15))
        
        let remainMoneyStr = CommonUtil.convertCurrency(remainingMoney)
        headerView.lbTotalRemain.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "total_remaining_money".localized(), remainMoneyStr),
                                                                                                     stringSemiBold: remainMoneyStr,
                                                                                                     fullStringColor: stringColor,
                                                                                                     stringSemiboldColor: stringColor,
                                                                                                     fullStringFont: SFProText.regular(size: 15),
                                                                                                     stringSemiboldFont: SFProText.semibold(size: 15))
        
        let paidMoneyStr = CommonUtil.convertCurrency(paidMoney)
        headerView.lbTotalPaid.attributedText = NSMutableAttributedString().attributedHalfOfString(fullString: String(format: "total_paid_money".localized(), paidMoneyStr),
                                                                                                   stringSemiBold: paidMoneyStr,
                                                                                                   fullStringColor: stringColor,
                                                                                                   stringSemiboldColor: stringColor,
                                                                                                   fullStringFont: SFProText.regular(size: 15),
                                                                                                   stringSemiboldFont: SFProText.semibold(size: 15))
    }
    
    func reloadData(){
        dataSource = DataHandling().fetchAllProduct(userInfo: userInfo ?? UserInfo())
        listTable.dataSource = dataSource
        listTable.tableView.reloadData()
        calculateMomey()
    }
    
    func setupTableView(){
        listTable = ListProductTableVC()
        self.addChild(listTable)
        listTable.tableView.frame = viewTable.frame
        listTable.delegate = self
        listTable.dataSource = dataSource
        self.viewTable.addSubview(listTable.tableView)
    }

    func setupUIHeader(){
        let customHeaderView = Bundle.main.loadNibNamed("UserDetailHeaderView", owner: self, options: nil)?.first as! UserDetailHeaderView
        headerView = customHeaderView
        headerView.delegate = self
        view.addSubview(headerView)
        headerView.frame.size = CGSize(width: view.frame.width, height: kTableHeaderHeight)
        view.bringSubviewToFront(headerView)
        
        listTable.tableView.contentInset.top = headerView.frame.height
        listTable.tableView.contentOffset.y = -headerView.frame.height
        headerView.updateHeaderView(scrollView: nil)
        //
        headerView.navigationView.delegate = self
        headerView.navigationView.title = userInfo?.username ?? ""
        headerView.underlineBtn.isHidden = true
    }
    
    func setupSelectedTableTabbar(){
//        btnController = SSRadioButtonsController.init(buttons: headerView.btnListTable, headerView.btnGridTable)
//        btnController!.delegate = self
//        btnController!.shouldLetDeSelect = false
//        headerView.btnListTable.isSelected = true
    }
    
    @IBAction func mainActionTapped(_ sender: Any) {
        let createProductVC = CommonUtil.viewController(storyboard: "UserManage", storyboardID: "createProductVC") as! CreateProductVC
        createProductVC.userInfo = userInfo ?? UserInfo()
        CommonUtil.push(createProductVC, from: self, andCanBack: true, hideBottom: true)
    }
    
    func goBack() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        CommonUtil.popViewController(for: self)
    }
    
    func confirmDeleteProduct(productInfo: ProductInfo){
        self.present(AlertVC.shared.confirmAlert("alert_confirm_title".localized(), message: "alert_delete_content".localized(), cancelTitle: "alert_cancel_btn".localized(), confirmTitle: "alert_ok_btn".localized(), completedClosure: nil, confirmClosure: {
            DataHandling().deleteProduct(productId: productInfo.productId)
            self.reloadData()
        }))
    }
    
    func confirmDeleteAll(){
        self.present(AlertVC.shared.confirmAlert("alert_confirm_title".localized(), message: "alert_delete_content".localized(), cancelTitle: "alert_cancel_btn".localized(), confirmTitle: "alert_ok_btn".localized(), completedClosure: nil, confirmClosure: {
            DataHandling().deleteAllProduct(userInfo: self.userInfo ?? UserInfo())
            self.reloadData()
        }))
    }
}

extension UserDetailVC : UserDetailHeaderViewDelegate {
    func openGridTable() {
        let gridView = CommonUtil.viewController(storyboard: "UserManage", storyboardID: "listProductGridVC") as! ListProductGridVC
        gridView.configure(productInfo: dataSource, totalMoney: totalMoney, paidMoney: paidMoney, remainingMoney: remainingMoney)
        CommonUtil.present(gridView, from: self)
    }
}
extension UserDetailVC: ListProductTableVCDetagate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.updateHeaderView(scrollView: scrollView)
    }

    func confirmDelete(productInfo: ProductInfo) {
        confirmDeleteProduct(productInfo: productInfo)
    }
}

//extension UserDetailVC: SSRadioButtonControllerDelegate{
//    func didSelectButton(selectedButton: UIButton?) {
//        if selectedButton == headerView.btnGridTable {
//            let gridView = CommonUtil.viewController(storyboard: "UserManage", storyboardID: "listProductGridVC") as! ListProductGridVC
//            gridView.configure(productInfo: dataSource)
//            CommonUtil.present(gridView, from: self)
//        }
//    }
//}


extension UserDetailVC: SNavigationViewDelegate{
    func touchedOnBackButton() {
        goBack()
    }
    
    func rightBarButtonTapped(){
        confirmDeleteAll()
    }
}
