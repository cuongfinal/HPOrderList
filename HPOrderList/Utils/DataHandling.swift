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

typealias CoreDataClosure = ((ActionCoreDataState)->())?

struct ActionCoreDataState {
    var success = true
    var numberSuccess = 0
    var numberFail = 0
    var message = ""
}


class DataHandling {
    func addUser(userModel: UserInfoModel, coreDataClosure: CoreDataClosure){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let checkUser = fetchSingleUser(phoneNumber: userModel.phoneNumber)
        if checkUser == nil {
            let userObj = UserInfo(context: managedObjectContext)
            userObj.phoneNumber = userModel.phoneNumber
            userObj.address = userModel.address
            userObj.username = userModel.username
            userObj.others = userModel.others
        
            do {
                try managedObjectContext.save()
                coreDataClosure?(ActionCoreDataState(success: true, numberSuccess: 1, numberFail: 0, message: ""))
            } catch let error as NSError {
                coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: error.localizedDescription))
            }
        }else{
            coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: "error_dupplicate_user".localized()))
        }
    }
    
    func addMultipleUser(usersModel: [UserInfoModel], coreDataClosure: CoreDataClosure){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        var numberSuccess = 0
        var numberFailture = 0
        
        for userModel in usersModel {
            let checkUser = fetchSingleUser(phoneNumber: userModel.phoneNumber)
            if checkUser == nil {
                numberSuccess += 1
                let userObj = UserInfo(context: managedObjectContext)
                userObj.phoneNumber = userModel.phoneNumber
                userObj.address = userModel.address
                userObj.username = userModel.username
                userObj.others = userModel.others
            }else{
                numberFailture += 1
            }
        }
        
        do {
            try managedObjectContext.save()
             coreDataClosure?(ActionCoreDataState(success: true, numberSuccess: numberSuccess, numberFail: numberFailture, message: ""))
        } catch let error as NSError {
             coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: error.localizedDescription))
        }
    }
    
    func fetchSingleUser(phoneNumber : String) -> UserInfo? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserInfo>(entityName: "UserInfo")
        fetchRequest.predicate = NSPredicate(format: "phoneNumber == %@", phoneNumber)
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            return tasks.count > 0 ? tasks.first : nil
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
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "username", ascending: true)
        fetchRequest.sortDescriptors = [idDescriptor]
        
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            return tasks
        }
        catch let error as NSError {
            print(error)
            return [UserInfo]()
        }
    }
    
    func deleteUser(phoneNumber: String, coreDataClosure: CoreDataClosure) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let userData = fetchSingleUser(phoneNumber: phoneNumber)
        if let userData = userData {
            managedObjectContext.delete(userData)
            do {
                try managedObjectContext.save()
                coreDataClosure?(ActionCoreDataState(success: true, numberSuccess: 1, numberFail: 0, message: ""))
            } catch let error as NSError {
                coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: error.localizedDescription))
            }
        }
    }
    
    func updateUserInfo(userModel: UserInfoModel, coreDataClosure: CoreDataClosure){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let userData = fetchSingleUser(phoneNumber: userModel.phoneNumber)
        if let userData = userData {
            userData.address = userModel.address
            userData.username = userModel.username
            userData.others = userModel.others

            do {
                try managedObjectContext.save()
                 coreDataClosure?(ActionCoreDataState(success: true, numberSuccess: 1, numberFail: 0, message: ""))
            } catch let error as NSError {
                 coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: error.localizedDescription))
            }
        }
    }
}

extension DataHandling {
    func addProduct(productModel: ProductInfoModel, coreDataClosure: CoreDataClosure){
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
            coreDataClosure?(ActionCoreDataState(success: true, numberSuccess: 1, numberFail: 0, message: ""))
        } catch let error as NSError {
            coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: error.localizedDescription))
        }
    }
    
    func fetchSingleProduct(productId : Int64) -> ProductInfo? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ProductInfo>(entityName: "ProductInfo")
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)
        
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            return tasks.count > 0 ? tasks.first : nil
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
    
    func deleteProduct(productId: Int64, coreDataClosure: CoreDataClosure) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let productInfo = fetchSingleProduct(productId: productId)
        if let productInfo = productInfo {
            managedObjectContext.delete(productInfo)
            do {
                try managedObjectContext.save()
                coreDataClosure?(ActionCoreDataState(success: true, numberSuccess: 1, numberFail: 0, message: ""))
            } catch let error as NSError {
                 coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: error.localizedDescription))
            }
        }
    }
    
    func deleteAllProduct(userInfo: UserInfo, coreDataClosure: CoreDataClosure) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let productList = fetchAllProduct(userInfo: userInfo)
        for product in productList {
            managedObjectContext.delete(product)
        }
        
        do {
            try managedObjectContext.save()
            coreDataClosure?(ActionCoreDataState(success: true, numberSuccess: 1, numberFail: 0, message: ""))
        } catch let error as NSError {
             coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: error.localizedDescription))
        }
    }

    
    func updateProductInfo(productId: Int64, productModel: ProductInfoModel, coreDataClosure: CoreDataClosure){
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
                coreDataClosure?(ActionCoreDataState(success: true, numberSuccess: 1, numberFail: 0, message: ""))
            } catch let error as NSError {
                 coreDataClosure?(ActionCoreDataState(success: false, numberSuccess: 0, numberFail: 1, message: error.localizedDescription))
            }
        }
    }
}
