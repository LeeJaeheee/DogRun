//
//  UIImage+Ext.swift
//  DogRun
//
//  Created by 이재희 on 5/1/24.
//

import UIKit


extension UIImage {
    
    func resizedImage(toWidth newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizedImage(below maxFileSizeInMB: Float, compressionQuality: CGFloat = 1.0, scaleFactor: CGFloat = 1.0) -> Data? {
        // 해상도 낮춤
        guard let resizedImage = self.resizedImage(toWidth: self.size.width * scaleFactor) else { return nil }
        guard let imageData = resizedImage.jpegData(compressionQuality: compressionQuality) else { return nil }
        
        let fileSizeInMB = Float(imageData.count) / (1024 * 1024)
        if fileSizeInMB < maxFileSizeInMB {
            return imageData
        } else {
            if compressionQuality > 0.1 {
                // 압축 품질을 조금 더 낮춤
                return resizedImage.resizedImage(below: maxFileSizeInMB, compressionQuality: compressionQuality - 0.1, scaleFactor: scaleFactor)
            } else if scaleFactor > 0.1 {
                // 해상도를 낮춤
                return self.resizedImage(below: maxFileSizeInMB, compressionQuality: 1.0, scaleFactor: scaleFactor - 0.1)
            } else {
                // 더 이상 해상도를 낮출 수 없음
                return nil
            }
        }
    }
}
