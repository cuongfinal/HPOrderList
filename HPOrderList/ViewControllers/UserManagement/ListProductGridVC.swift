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
        
        @IBOutlet weak var viewHeader: UIView!
        @IBOutlet weak var viewTable: UIView!
        @IBOutlet weak var btnClose: UIButton!
        
        //MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.rotate(angle: 90)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        
        func configure(productInfo: [ProductInfo]){
            self.productList = productInfo
            dataTable = makeDataTable()
            setupViews()
            setupConstraints()
        }
        
    @IBAction func closeTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: false, completion: nil)
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
            view.backgroundColor = UIColor.dark.withAlphaComponent(0.7)
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
                    "Số lượng",
                    "Giá SP",
                    "Tiền cọc",
                    "Trạng thái",
                    "Ghi chú"
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
                let item = [productItem.quantity,
                            CommonUtil.convertCurrency(productItem.price, currency: ""),
                            CommonUtil.convertCurrency(productItem.paid, currency: ""),
                            productItem.status ? "Đã trả hàng" : "Chưa trả hàng",
                            productItem.note ?? ""] as [Any]
                arrayDataSet.append(item)
            }
            return arrayDataSet.map {
                $0.compactMap (DataTableValueType.init)
            }
        }
        
}
