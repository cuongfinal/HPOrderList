//
//  ProductInfoModel.swift
//  HPOrderList
//
//  Created by Cuong Le on 6/14/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import Foundation

struct ProductInfoModel {
    var quantity: Int32 = 0
    var price: Int64 = 0
    var paid: Int64 = 0
    var status = false
    var ofUser : UserInfo?
    var note = ""
    var name = ""
}
