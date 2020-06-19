//
//  ListProductTableVC.swift
//  HPOrderList
//
//  Created by Cuong Le on 6/14/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

protocol ListProductTableVCDetagate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func confirmDelete(productInfo: ProductInfo)
}

class ListProductTableVC: UITableViewController {
    var delegate : ListProductTableVCDetagate?
    var dataSource = [ProductInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "ProductInfoCell", bundle: nil), forCellReuseIdentifier: "productInfoCell")
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.borderColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "productInfoCell") as! ProductInfoCell
        let cellData = dataSource[indexPath.row]
        cell.configure(productInfo: cellData)
        cell.backgroundColor = .clear
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegate = self.delegate {
            delegate.scrollViewDidScroll(scrollView)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cellData = dataSource[indexPath.row]
        let askAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            if let delegate = self.delegate {
                delegate.confirmDelete(productInfo: cellData)
            }
        }
        askAction.image = UIImage.init(named: "delete-icon")
        askAction.backgroundColor = UIColor.editBGColor
        
        let editAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            let editUserVC = CommonUtil.viewController(storyboard: "UserManage", storyboardID: "editProductVC") as! EditProductVC
            editUserVC.productInfo = cellData
            CommonUtil.push(editUserVC, from: self, andCanBack: true, hideBottom: true)
        }
        editAction.image = UIImage.init(named: "edit-icon")
        editAction.backgroundColor = UIColor.editBGColor
        return UISwipeActionsConfiguration(actions: [askAction, editAction])
    }
}
