//
//  DataHandling.swift
//  HPOrderList
//
//  Created by Cuong Le on 6/14/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataHandling {
    func addUser(userModel: UserInfoModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let checkUser = fetchSingleUser(userName: userModel.username)
        if checkUser == nil {
            let userObj = UserInfo(context: managedObjectContext)
            userObj.phoneNumber = userModel.phoneNumber
            userObj.address = userModel.address
            userObj.username = userModel.username
            userObj.others = userModel.others
        
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func fetchSingleUser(userName : String) -> UserInfo? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserInfo>(entityName: "UserInfo")
        
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            return tasks.filter { $0.username == userName}.first
        }
        catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func fetchAllUser() -> [UserInfo]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [UserInfo]() }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserInfo>(entityName: "UserInfo")
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            return tasks
        }
        catch let error as NSError {
            print(error)
            return [UserInfo]()
        }
    }
    
    func deleteUser(userName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let userData = fetchSingleUser(userName: userName)
        if let userData = userData {
            managedObjectContext.delete(userData)
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func updateUserInfo(userModel: UserInfoModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let userData = fetchSingleUser(userName: userModel.username)
        if let userData = userData {
            userData.address = userModel.address
            userData.phoneNumber = userModel.phoneNumber
            userData.others = userModel.others

            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
}

extension DataHandling {
    func addProduct(productModel: ProductInfoModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //Set ID auto increasement
        var newId:Int64 = 0;
        let allProduct = fetchAllProductWithoutPredicate()
        if allProduct.count > 0{
            newId = allProduct[0].productId + 1
        }
        //
        let productObj = ProductInfo(context: managedObjectContext)
        productObj.name = productModel.name
        productObj.quantity = productModel.quantity
        productObj.price = productModel.price
        productObj.paid = productModel.paid
        productObj.status = productModel.status
        productObj.note = productModel.note
        productObj.productId = newId
        productObj.ofUser = productModel.ofUser
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetchSingleProduct(productId : Int64) -> ProductInfo? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ProductInfo>(entityName: "ProductInfo")
        
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            return tasks.filter { $0.productId == productId}.first
        }
        catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func fetchAllProduct(userInfo: UserInfo) -> [ProductInfo]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [ProductInfo]() }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ProductInfo>(entityName: "ProductInfo")
        fetchRequest.predicate = NSPredicate(format: "ofUser == %@", userInfo)
        
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            return tasks
        }
        catch let error as NSError {
            print(error)
            return [ProductInfo]()
        }
    }
    
    func fetchAllProductWithoutPredicate() -> [ProductInfo]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [ProductInfo]() }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ProductInfo>(entityName: "ProductInfo")
        // Sort Descriptor
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "productId", ascending: false)
        fetchRequest.sortDescriptors = [idDescriptor]
        
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            return tasks
        }
        catch let error as NSError {
            print(error)
            return [ProductInfo]()
        }
    }
    
    func deleteProduct(productId: Int64) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let productInfo = fetchSingleProduct(productId: productId)
        if let productInfo = productInfo {
            managedObjectContext.delete(productInfo)
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    func deleteAllProduct(userInfo: UserInfo) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let productList = fetchAllProduct(userInfo: userInfo)
        for product in productList {
            managedObjectContext.delete(product)
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error)
        }
    }

    
    func updateProductInfo(productId: Int64, productModel: ProductInfoModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let productInfo = fetchSingleProduct(productId: productId)
        if let productInfo = productInfo {
            productInfo.name = productModel.name
            productInfo.quantity = productModel.quantity
            productInfo.price = productModel.price
            productInfo.paid = productModel.paid
            productInfo.status = productModel.status
            productInfo.note = productModel.note

            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
