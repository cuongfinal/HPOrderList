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
    
    func exportDatabase(stateClosure: StateClosure) {
        let exportString = createExportString()
        saveAndExport(exportString: exportString) { closureState in
            stateClosure?(closureState)
        }
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
    
    func saveAndExport(exportString: String, stateClosure: StateClosure) {
        let exportFileURL = DocumentsDirectory.localDocumentsURL.appendingPathComponent(exportFileName)
        FileManager.default.createFile(atPath: exportFileURL.path, contents: Data(), attributes: nil)
        
        var fileHandle: FileHandle? = nil
        do {
            if FileManager.default.fileExists(atPath: exportFileURL.path){
                fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
            }
        } catch {
            stateClosure?(ClosureState(success: false, message: error.localizedDescription))
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            fileHandle!.closeFile()
            //Copy to icloud
            if isCloudEnabled() {
                iCloudUpload { closureState in
                    stateClosure?(closureState)
                }
            }
            stateClosure?(ClosureState(success: true, message: ""))
        }
    }
}

extension CSVWorking {
    func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else { return false }
    }
    
    func iCloudUpload(stateClosure: StateClosure){
        //Create Directory
        if let iCloudDocumentsURL = DocumentsDirectory.iCloudDocumentsURL {
            if (!FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: nil)) {
                do {
                    try FileManager.default.createDirectory(at: iCloudDocumentsURL, withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    stateClosure?(ClosureState(success: false, message: error.localizedDescription))
                }
            }
        }
        
        //iCloud Upload
        guard let iCloudDocumentsURL = DocumentsDirectory.iCloudDocumentsURL?.appendingPathComponent("Subdirectory") else {
            stateClosure?(ClosureState(success: false, message: "No directory at iCloud drive"))
            return
        }
        
        var isDir:ObjCBool = false
        if FileManager.default.fileExists(atPath: iCloudDocumentsURL.path, isDirectory: &isDir) {
            do {
                try FileManager.default.removeItem(at: iCloudDocumentsURL)
            }
            catch {
                stateClosure?(ClosureState(success: false, message: error.localizedDescription))
            }
        }
        
        do {
            try FileManager.default.copyItem(at:  DocumentsDirectory.localDocumentsURL, to: iCloudDocumentsURL)
        }
        catch {
            stateClosure?(ClosureState(success: false, message: error.localizedDescription))
        }
        stateClosure?(ClosureState(success: true, message: ""))
    }
}




//    func deleteFilesInDirectory(url: URL?) {
//        let fileManager = FileManager.default
//        let enumerator = fileManager.enumerator(atPath: url?.path ?? "")
//        while let file = enumerator?.nextObject() as? String {
//            do {
//                try fileManager.removeItem(at: url!.appendingPathComponent(file))
//                print("Files deleted")
//            } catch let error as NSError {
//                print("Failed deleting files : \(error)")
//            }
//        }
//    }
//
//    func moveFileToCloud() {
//        if isCloudEnabled() {
//            deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL!) // Clear destination
//            do {
//                try FileManager.default.copyItem(at: DocumentsDirectory.localDocumentsURL, to: DocumentsDirectory.iCloudDocumentsURL!)
//            } catch (let writeError)
//            {
//                print("Error creating a file \(writeError)")
//            }
//
//
//
////            let fileManager = FileManager.default
////            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
////            while let file = enumerator?.nextObject() as? String {
////                do {
////                    try fileManager.setUbiquitous(true,
////                                                  itemAt: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file),
////                                                  destinationURL: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))
////                    print("Moved to iCloud")
////                } catch let error as NSError {
////                    print("Failed to move file to Cloud : \(error)")
////                }
////            }
//        }
//    }
