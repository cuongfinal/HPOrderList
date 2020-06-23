//
//  CSVWorking.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/19/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import Foundation
import UIKit

typealias StateClosure = ((ClosureState)->())?
struct ClosureState {
    var success = true
    var message = ""
}

struct DocumentsDirectory {
    static let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
    static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
}

class CSVWorking{
    
    func exportDatabase(stateClosure: StateClosure) {
        let exportString = createExportString()
        saveAndExport(exportString: exportString) { closureState in
            CommonUtil.setDefaultLastUpdate(lastUpdate: Date().timeIntervalSince1970)
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
            return
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            fileHandle!.closeFile()
            //Copy to icloud
            if isCloudEnabled() {
                iCloudUpload { closureState in
                    //TODO: re-check
                    stateClosure?(ClosureState(success: true, message: ""))
                }
            }else{
                stateClosure?(ClosureState(success: true, message: ""))
            }
        }
    }
}

extension CSVWorking {
    func parseCSV (contentsOfURL: URL, encoding: String.Encoding, error: NSErrorPointer) -> [UserInfoModel]? {
        
        var items:[UserInfoModel]?
    
        if let content = try? String(contentsOf: contentsOfURL, encoding: encoding) {
            items = []
            var lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
            //Remove header
            if lines.count > 0 {
                lines.remove(at: 0)
            }
            
            for lineStr in lines {
                if lineStr.count > 0 {
                    let valuesParsed = parseCsvLine(ln: lineStr)
                    // Put the values into the tuple and add it to the items array
                    var newUserInfo = UserInfoModel()
                    newUserInfo.username = valuesParsed[0]
                    newUserInfo.phoneNumber = valuesParsed[1]
                    newUserInfo.address = valuesParsed[2]
                    newUserInfo.others = valuesParsed[3]
                    items?.append(newUserInfo)
                }
            }
        }
        
        return items
    }
    
    func parseCsvLine(ln: String) -> [String] {
        // takes a line of a CSV file and returns the separated values
        // so input of 'a,b,2' should return ["a","b","2"]
        // or input of '"Houston, TX","Hello",5,"6,7"' should return ["Houston, TX","Hello","5","6,7"]
        
        let delimiter = ","
        let quote = "\""
        var nextTerminator = delimiter
        var andDiscardDelimiter = false
        let totalField = 4
        var currentValue = ""
        var allValues : [String] = []
        
        for char in ln {
            let chr = String(char)
            if chr == nextTerminator {
                if andDiscardDelimiter {
                    // we've found the comma after a closing quote. No action required beyond clearing this flag.
                    andDiscardDelimiter = false
                }
                else {
                    // we've found the comma or closing quote terminating one value
                    allValues.append(currentValue)
                    currentValue = ""
                }
                nextTerminator = delimiter  // either way, next thing we look for is the comma
            } else if chr == quote {
                // this is an OPENING quote, so clear currentValue (which should be nothing but maybe a single space):
                currentValue = ""
                nextTerminator = quote
                andDiscardDelimiter = true
            } else {
                currentValue += chr
            }
        }
        //Add "" value for missing field
        let remainingField = totalField - allValues.count
        for _ in 0..<remainingField {
            allValues.append("")
        }
        return allValues
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
                    return
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
                return
            }
        }
        
        do {
            try FileManager.default.copyItem(at:  DocumentsDirectory.localDocumentsURL, to: iCloudDocumentsURL)
        }
        catch {
            stateClosure?(ClosureState(success: false, message: error.localizedDescription))
            return
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
