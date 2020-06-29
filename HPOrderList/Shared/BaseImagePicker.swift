//
//  BaseImagePicker.swift
//  HPOrderList
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 6/29/20.
//  Copyright © 2020 Cuong Le. All rights reserved.
//

import Foundation
import UIKit
import CoreServices

protocol HasImagePickerProtocol {
    func getImagePickerDelegate() -> UIImagePickerControllerDelegate & UINavigationControllerDelegate
    func openImagePickerMenu(title:String)
    func pickedImage(_ image: UIImage?)
}

extension HasImagePickerProtocol where Self: UIViewController {
    func openImagePickerMenu(title:String) {
        let imagePickerMenu = AlertVC.shared.imagePickerAlert(title: title, photoClosure: { [weak self] in
            self?.getImageFrom(.photoLibrary)
        }, cancelClosure: nil)
        DispatchQueue.main.async {
            self.present(imagePickerMenu)
        }
    }
    
    private func getImageFrom(_ type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = type
        picker.delegate = getImagePickerDelegate()
        present(picker, animated: true)
    }
}

class BaseImagePickerVC: BaseVC, HasImagePickerProtocol {
    func getImagePickerDelegate() -> UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        return self
    }
    
    func pickedImage(_ image: UIImage?) {}
}

extension BaseImagePickerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        
        if picker.sourceType == UIImagePickerController.SourceType.camera {
            
            if CFStringCompare(mediaType as CFString?, kUTTypeMovie, CFStringCompareFlags(rawValue: 0)) == .compareEqualTo {
                let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                UISaveVideoAtPathToSavedPhotosAlbum((videoUrl?.path)!, nil, nil, nil)
            } else {
                let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
            }
        }
        
        weak var weakSelf = self
        picker.dismiss(animated: true) {
            if CFStringCompare((mediaType)! as CFString, kUTTypeImage, CFStringCompareFlags(rawValue: 0)) == .compareEqualTo {
                
                let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                if (weakSelf != nil) {
                    weakSelf?.pickedImage(image)
                }
            }
        }
    }
}
