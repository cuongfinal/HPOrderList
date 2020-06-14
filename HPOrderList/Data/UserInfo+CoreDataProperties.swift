//
//  UserInfo+CoreDataProperties.swift
//  
//
//  Created by Cuong Le on 6/14/20.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var address: String?
    @NSManaged public var others: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var userid: Int64
    @NSManaged public var username: String?
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension UserInfo {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: ProductInfo)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: ProductInfo)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
