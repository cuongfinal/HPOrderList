//
//  SettingVC.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/5/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class SettingVC: BaseVC {
    
    var sectionFunction = [("backup_title".localized(),"backup-icon"),
                           ("restore_title".localized(),"restore-icon"),
                           ("auto_backup_title".localized(),"auto-backup-icon")]
    
    var sectionSupport = [("guideline_title".localized(),"user-guide-icon"),
                          ("contact_title".localized(),"contact-icon")]
    
    @IBOutlet weak var tbSettings: UITableView! {
        didSet {
            tbSettings.register(UINib.init(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "settingCell")
            tbSettings.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tbSettings.frame.size.width, height: 1))
            tbSettings.showsVerticalScrollIndicator = false
            tbSettings.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            tbSettings.estimatedRowHeight = 50
            tbSettings.backgroundColor = UIColor.clear
            tbSettings.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewDidLoad() {
        title = "setting_title".localized()
        super.viewDidLoad()

        tbSettings.separatorColor = UIColor.borderColor
    }
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "support_function".localized()
        case 1:
            return "support_title".localized()
        case 2:
            if let versionText = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return String(format: "app_version_title".localized(), versionText)
            }
            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CommonUtil.sizeBasedOnDeviceWidth(size: 42.0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: CommonUtil.sizeBasedOnDeviceWidth(size: 15.0), y: 0, width: tbSettings.frame.width, height: CommonUtil.sizeBasedOnDeviceWidth(size: 50.0))
        titleLabel.font = SFProText.regular(size: 14.0)
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        titleLabel.textColor = UIColor.darkGray
        
        let headerView = UIView()
        headerView.addSubview(titleLabel)
        headerView.backgroundColor = UIColor.bgColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionFunction.count
        case 1:
            return sectionSupport.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
         var data = ("", "")
        if indexPath.section == 0 {
            data = sectionFunction[indexPath.row]
            if indexPath.row == 2 {
                cell.configure(type: .switcher)
            }else{
                cell.configure(type: .none)
            }
        }else{
            data = sectionSupport[indexPath.row]
            cell.configure(type: .none)
        }
        cell.backgroundColor = .white
        cell.lblTitle.text = data.0
        cell.imgIcon.image = UIImage.init(named: data.1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                CSVWorking().exportDatabase {
                    print("done")
                }
            default:
                print("default")
            }
        }
    }
}

