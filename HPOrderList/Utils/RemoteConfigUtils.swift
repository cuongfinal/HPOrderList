//
//  RemoteConfigUtils.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/29/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import Foundation
import Firebase

class RemoteConfigUtils {
    
    static let sharedInstance = RemoteConfigUtils()
    
    private init() {
      loadDefaultValues()
    }
    
    func loadDefaultValues() {
      let appDefaults: [String: Any?] = [
        "currentVersion" : "1.0"
      ]
      RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    
    func fetchRemoteConfig(completedClosure: CompletedClosure){
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
        
        RemoteConfig.remoteConfig().fetch() { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                RemoteConfig.remoteConfig().activate() { (error) in
                    completedClosure?()
                }
            } else {
                completedClosure?()
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    func getString(key: String) -> String {
        return RemoteConfig.remoteConfig()[key].stringValue ?? ""
    }
    
}
