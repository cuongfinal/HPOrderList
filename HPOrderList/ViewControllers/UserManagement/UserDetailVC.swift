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
        var total: Int64 = 0
        var paid: Int64 = 0
        var remaining: Int64 = 0
        for product in dataSource {
            total += (product.price * Int64(product.quantity))
            paid +=  product.paid
            remaining += (product.price * Int64(product.quantity)) - product.paid
        }
        headerView.lbTotalMoney.text = String(format: "Tổng số tiền: %@", CommonUtil.convertCurrency(total))
        headerView.lbTotalRemain.text = String(format: "Tổng số tiền còn lại: %@", CommonUtil.convertCurrency(remaining))
        headerView.lbTotalPaid.text = String(format: "Tổng số tiền cọc: %@", CommonUtil.convertCurrency(paid)) 
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
        btnController = SSRadioButtonsController.init(buttons: headerView.btnListTable, headerView.btnGridTable)
        btnController!.delegate = self
        btnController!.shouldLetDeSelect = false
        headerView.btnListTable.isSelected = true
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
}

extension UserDetailVC: ListProductTableVCDetagate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.updateHeaderView(scrollView: scrollView)
    }
    
    func reloadViewData() {
        self.reloadData()
    }
}

extension UserDetailVC: SSRadioButtonControllerDelegate{
    func didSelectButton(selectedButton: UIButton?) {
//        if let selectedBtn = selectedButton {
//            let indexPath = IndexPath(row: 0, section: btnController?.buttonIndex(selectedBtn) ?? 0)
//
//            //Re-coordinate table offset position
//            DispatchQueue.main.async {
//                if indexPath.section > 0{
//                    self.mainTableView.tableView.contentOffset = CGPoint(x: 0, y: self.mainTableView.tableView.contentOffset.y + self.headerView.frame.height)
//                }else{
//                    self.mainTableView.tableView.contentOffset = CGPoint(x: 0, y: -self.headerView.frame.height)
//                }
//            }
//
//            headerView.updateUnderlinePosition(selectedButton: selectedBtn)
//        }
    }
}


extension UserDetailVC: SNavigationViewDelegate{
    func touchedOnBackButton() {
        goBack()
    }
    
    func rightBarButtonTapped(){
        DataHandling().deleteAllProduct(userInfo: userInfo ?? UserInfo())
        self.reloadData()
    }
}
