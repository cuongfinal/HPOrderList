//
//  HomeVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {

    @IBOutlet weak var tbUserlist: UITableView! {
        didSet {
            tbUserlist.register(UINib.init(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: "userInfoCell")
            tbUserlist.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tbUserlist.frame.size.width, height: 1))
            tbUserlist.showsVerticalScrollIndicator = false
            tbUserlist.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            tbUserlist.backgroundColor = UIColor.white
            tbUserlist.estimatedRowHeight = 85
            tbUserlist.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewDidLoad() {
        title = "home_title".localized()
        super.viewDidLoad()
        CommonUtil.addRightBtn(to: self, imageNamed: "plus-icon", with: #selector(self.rightBtnAction))
        tbUserlist.separatorColor = UIColor.borderColor
    }
    
    @objc func rightBtnAction() {
       //
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "userInfoCell") as! UserInfoCell
        cell.configure()
        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let askAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            print("Delete tapped")
        }
        askAction.image = UIImage.init(named: "delete-icon")
        askAction.backgroundColor = UIColor.editBGColor
        
        return UISwipeActionsConfiguration(actions: [askAction])
    }
}
