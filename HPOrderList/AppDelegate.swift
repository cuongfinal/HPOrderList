//
//  AppDelegate.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/2/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        RemoteConfigUtils.sharedInstance.fetchRemoteConfig {
            self.checkForceUpdate()
        }
        return true
    }

    func checkForceUpdate(){
        let updateString = RemoteConfigUtils.sharedInstance.getString(key: "currentVersion")
        if updateString.count > 0 {
            let newVersion = Int(updateString.replacingOccurrences(of: ".", with: "")) ?? 0
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let currentVersion = Int(appVersion?.replacingOccurrences(of: ".", with: "") ?? "") ?? 0
            let appStoreURL = "itms-apps://itunes.apple.com/app/1521206567";
            DispatchQueue.main.async {
                if let rootView = UIApplication.shared.keyWindow?.rootViewController, let url = URL.init(string: appStoreURL),  currentVersion < newVersion {
                    rootView.present(AlertVC.shared.warningAlert("", message: "Bạn vui lòng cập nhật phiên bản mới nhất để tiếp tục sử dụng 😁😁", cancelTitle: "Cập nhật", completedClosure: {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }))
                }
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        checkForceUpdate()
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HPOrderList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

