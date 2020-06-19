//
//  CSVWorking.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/19/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import Foundation
import UIKit

struct DocumentsDirectory {
    static let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
    static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    
}

class CSVWorking{
    func exportDatabase(completedClosure: CompletedClosure) {
        let exportString = createExportString()
        saveAndExport(exportString: exportString, completedClosure: {
            completedClosure?()
        })
    }
    
    func createExportString() -> String {
        var export: String = NSLocalizedString("Name, PhoneNumber, Address, Others \n", comment: "")
        let userArray = DataHandling().fetchAllUser()
        for (_, userInfo) in  userArray.enumerated() {
            let nameString = "\(userInfo.username ?? "")"
            let phoneString = "\(userInfo.phoneNumber ?? "")"
            let addressString = "\(userInfo.address ?? "")"
            let othersString = "\(userInfo.others ?? "")"
            export += nameString + "," + phoneString + "," + addressString + "," + othersString + "\n"
        }
        print("This is what the app will export: \(export)")
        return export
    }
    
    func saveAndExport(exportString: String, completedClosure: CompletedClosure) {
        //        let exportFilePath = NSTemporaryDirectory() + "User List.csv"
        let exportFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("UserList.csv")
        //        FileManager.default.createFile(atPath: exportFileURL.path, contents: Data(), attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        let data = Data(exportString.utf8)
        do {
            try data.write(to: exportFileURL, options: .atomic)
        } catch {
            print("Error with fileHandle")
        }
        
        do {
            if FileManager.default.fileExists(atPath: exportFileURL.path){
                fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
            }
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            fileHandle!.closeFile()
            moveFileToCloud()
            completedClosure?()
        }
    }
    
    func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else { return false }
    }
    
    func deleteFilesInDirectory(url: URL?) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url?.path ?? "")
        while let file = enumerator?.nextObject() as? String {
            do {
                try fileManager.removeItem(at: url!.appendingPathComponent(file))
                print("Files deleted")
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
    }
    
    func moveFileToCloud() {
        if isCloudEnabled() {
            deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL!) // Clear destination
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {
                do {
                    try fileManager.setUbiquitous(true,
                                                  itemAt: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file),
                                                  destinationURL: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
                    print("Moved to iCloud")
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                }
            }
        }
    }
}
