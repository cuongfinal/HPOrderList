//
//  ProductInfo+CoreDataProperties.swift
//  
//
//  Created by Cuong Le on 6/14/20.
//
//

import Foundation
import CoreData


extension ProductInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductInfo> {
        return NSFetchRequest<ProductInfo>(entityName: "ProductInfo")
    }

    @NSManaged public var paid: Int64
    @NSManaged public var price: Int64
    @NSManaged public var productId: Int64
    @NSManaged public var quantity: Int32
    @NSManaged public var status: Bool
    @NSManaged public var note: String?
    @NSManaged public var name: String?
    @NSManaged public var ofUser: UserInfo?

}
