//
//  HomeVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {
    var dataSource = [UserInfo]()
    var filteredUsers = [UserInfo]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var tbUserlist: UITableView! {
        didSet {
            tbUserlist.register(UINib.init(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: "userInfoCell")
            tbUserlist.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tbUserlist.frame.size.width, height: 1))
            tbUserlist.showsVerticalScrollIndicator = false
            tbUserlist.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            tbUserlist.backgroundColor = UIColor.white
            tbUserlist.estimatedRowHeight = 107
            tbUserlist.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchBar()
        reloadData()
    }
    
    override func viewDidLoad() {
        title = "home_title".localized()
        super.viewDidLoad()
        CommonUtil.addRightBtn(to: self, imageNamed: "plus-icon", with: #selector(self.rightBtnAction))
        tbUserlist.separatorColor = UIColor.borderColor
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredUsers = dataSource.filter { (userInfo: UserInfo) -> Bool in
            return  userInfo.username?.lowercased().contains(searchText.lowercased()) ?? false ||
                userInfo.phoneNumber?.lowercased().contains(searchText) ?? false
        }
        
        tbUserlist.reloadData()
    }
    
    func setupSearchBar(){
        //SearchVC
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Tìm khách hàng (Tên/SĐT)"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        definesPresentationContext = true
        
        searchController.searchBar.searchTextField.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string:"Tìm khách hàng (Tên/SĐT)", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.75)])
        }
        if let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = UIColor.white.withAlphaComponent(0.75)
        }
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
//    func  updateSearchResultsForSearchController(searchController:UISearchController) {
//        if let searchText = searchController.searchBar.text?.lowercased() {
//            if searchText.count == 0 {
//                filteredUsers = dataSource
//            }
//            else {
//                filteredUsers =  [UserInfo]().filter {
//                    return $0.username?.lowercased().contains(searchText) ?? false ||
//                        $0.phoneNumber?.lowercased().contains(searchText) ?? false
//                }
//            }
//        }
//        self.tbUserlist.reloadData()
//    }
    
    @objc func rightBtnAction() {
        let createUserVC = CommonUtil.viewController(storyboard: "UserManage", storyboardID: "createUserVC") as! CreateUserVC
        CommonUtil.push(createUserVC, from: self, andCanBack: true, hideBottom: true)
    }
    
    func reloadData(){
        dataSource = DataHandling().fetchAllUser()
        if isFiltering {
            let searchBar = searchController.searchBar
            filterContentForSearchText(searchBar.text!)
        }else{
            tbUserlist.reloadData()
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filteredUsers.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "userInfoCell") as! UserInfoCell
        let cellData = isFiltering ? filteredUsers[indexPath.row] : dataSource[indexPath.row]
        cell.configure(userInfo: cellData)
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cellData = isFiltering ? filteredUsers[indexPath.row] : dataSource[indexPath.row]

        let askAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            DataHandling().deleteUser(userName: cellData.username ?? "")
            self.reloadData()
        }
        askAction.image = UIImage.init(named: "delete-icon")
        askAction.backgroundColor = UIColor.editBGColor
        
        let editAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            let editUserVC = CommonUtil.viewController(storyboard: "UserManage", storyboardID: "editUserVC") as! EditUserVC
            editUserVC.userInfo = cellData
            CommonUtil.push(editUserVC, from: self, andCanBack: true, hideBottom: true)
        }
        editAction.image = UIImage.init(named: "edit-icon")
        editAction.backgroundColor = UIColor.editBGColor
        
        return UISwipeActionsConfiguration(actions: [askAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailVC = CommonUtil.viewController(storyboard: "UserManage", storyboardID: "userDetailVC") as! UserDetailVC
        let cellData = isFiltering ? filteredUsers[indexPath.row] : dataSource[indexPath.row]
        userDetailVC.userInfo = cellData
        CommonUtil.push(userDetailVC, from: self, andCanBack: true, hideBottom: true)
    }
}

extension HomeVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


