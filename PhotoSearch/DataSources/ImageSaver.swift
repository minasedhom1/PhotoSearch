//
//  ImageSaver.swift
//  PhotoSearch
//
//  Created by Mina Sedhom on 1/31/22.
//  Copyright © 2022 Mina Sedhom. All rights reserved.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    
    var completion: ((Swift.Result <Void, Error>) -> Void)?
    
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveComplete), nil)
    }

    @objc func saveComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            completion?(.failure(error)) //errorHandler?(error)
        } else {
            completion?(.success(()))//successHandler?()
        }
    }
}
