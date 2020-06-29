//
//  ListProductGridVC.swift
//  HPOrderList
//
//  Created by Cuong Le on 6/14/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit

class ListProductGridVC: UIViewController {
    
    //MARK: - Properties
    var dataTable: SwiftDataTable!
    var productList: [ProductInfo]!
    
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var lbRemainingMoney: UILabel!
    @IBOutlet weak var lbPaid: UILabel!
    @IBOutlet weak var lbTotalMoney: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgWaterMark: UIImageView!
    
    var total: Int64 = 0
    var paid: Int64 = 0
    var remaining: Int64 = 0
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        handleShowWaterMark()
    }
    
    func configure(productInfo: [ProductInfo], totalMoney: Int64, paidMoney: Int64, remainingMoney: Int64){
        self.productList = productInfo
        dataTable = makeDataTable()
        setupViews()
        setupConstraints()
        
        lbTotalMoney.text = String(format: "total_money".localized(), CommonUtil.convertCurrency(totalMoney, currency: ""))
        lbRemainingMoney.text = String(format: "total_remaining_money".localized(), CommonUtil.convertCurrency(remainingMoney, currency: ""))
        lbPaid.text = String(format: "total_paid_money".localized(), CommonUtil.convertCurrency(paidMoney, currency: ""))
    }
    
    func handleShowWaterMark(){
        if !CommonUtil.getDefaultDisableWaterMark(){
            imgWaterMark.isHidden = true
        }else{
            if let imgData = CommonUtil.getDefaultWaterMark() {
                if let img = UIImage(data: imgData){
                    imgWaterMark.image = img
                }else {
                    imgWaterMark.image = UIImage(named: "logo-junes")
                }
            }else{
                imgWaterMark.image = UIImage(named: "logo-junes")
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupViews() {
        navigationController?.navigationBar.isTranslucent = false
        title = "Employee Balances"
        view.backgroundColor = UIColor.white
//        viewHeader.backgroundColor = UIColor.veryLightBlue
//        viewFooter.backgroundColor = UIColor.veryLightBlue
        automaticallyAdjustsScrollViewInsets = false
        viewTable.addSubview(dataTable)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dataTable.topAnchor.constraint(equalTo: viewTable.topAnchor),
            dataTable.leadingAnchor.constraint(equalTo: viewTable.leadingAnchor),
            dataTable.bottomAnchor.constraint(equalTo: viewTable.bottomAnchor),
            dataTable.trailingAnchor.constraint(equalTo: viewTable.trailingAnchor),
        ])
    }
    
}
extension ListProductGridVC {
    func makeOptions() -> DataTableConfiguration {
        var options = DataTableConfiguration()
        options.shouldShowSearchSection = false
        options.shouldShowFooter = false
        options.shouldShowVerticalScrollBars = false
        options.shouldShowHorizontalScrollBars = false
        options.highlightedAlternatingRowColors =  [
            UIColor(red: 0.9725, green: 0.9725, blue: 0.9725, alpha: 1),
            .white
        ]
        options.unhighlightedAlternatingRowColors =  [
            UIColor(red: 0.9725, green: 0.9725, blue: 0.9725, alpha: 1),
            .white
        ]
        options.headerFooterColor = [
            UIColor.mainColor,
            UIColor.orangeColor
        ]
        return options
    }
    
    func makeDataTable() -> SwiftDataTable {
        let dataTable = SwiftDataTable(
            data: dataSetProduct(),
            headerTitles: columnHeaders(),
            options: makeOptions()
        )
        dataTable.delegate = self
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTable.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return dataTable
    }
}

extension ListProductGridVC: SwiftDataTableDelegate {
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        debugPrint("did select item at indexPath: \(indexPath) dataValue: \(dataTable.data(for: indexPath))")
    }
}

extension ListProductGridVC {
    func columnHeaders() -> [String] {
        return [
            "Tên Sản Phẩm",
            "SL",
            "Giá Sản Phẩm",
            "Tiền cọc ",
            "Thành tiền",
            "Trạng thái"
        ]
    }
    
    func data() -> [[DataTableValueType]]{
        //This would be your json object
        var dataSet: [[Any]] = dataSetProduct()
        for _ in 0..<0 {
            dataSet += dataSetProduct()
        }
        
        return dataSet.map {
            $0.compactMap (DataTableValueType.init)
        }
    }
    
    public func dataSetProduct() -> [[DataTableValueType]]{
        //            let paidList = productList.sorted{ $0.installment < $1.installment }
        var arrayDataSet = [[Any]]()
        for productItem in productList {
            let item = [productItem.name ?? "",
                        productItem.quantity,
                        CommonUtil.convertCurrency(productItem.price, currency: ""),
                        CommonUtil.convertCurrency(productItem.paid, currency: ""),
                        CommonUtil.convertCurrency((productItem.price*Int64(productItem.quantity))-productItem.paid, currency: ""),
                        productItem.status ? "Đã trả hàng" : "Chưa trả hàng"] as [Any]
            arrayDataSet.append(item)
        }
        return arrayDataSet.map {
            $0.compactMap (DataTableValueType.init)
        }
    }
    
}
