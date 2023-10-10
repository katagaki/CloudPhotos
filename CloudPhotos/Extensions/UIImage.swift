//
//  UIImage.swift
//  CloudPhotos
//
//  Created by シン・ジャスティン on 2023/10/11.
//

import Foundation
import UIKit

extension UIImage {
    func jpegThumbnail() -> Data? {
        let shortSideLength = min(self.size.width, self.size.height)
        let xOffset = (self.size.width - shortSideLength) / 2.0
        let yOffset = (self.size.height - shortSideLength) / 2.0
        let cropRect = CGRect(x: xOffset, y: yOffset, width: shortSideLength, height: shortSideLength)
        let imageRendererFormat = self.imageRendererFormat
        imageRendererFormat.opaque = false
        let croppedImage = UIGraphicsImageRenderer(size: cropRect.size, format: imageRendererFormat).image { _ in
            self.draw(in: CGRect(origin: CGPoint(x: -xOffset, y: -yOffset), size: self.size))
        }.cgImage!
        if let scaledImage = UIImage(cgImage: croppedImage).scaleImage(toSize: CGSize(width: 150.0, height: 150.0)) {
            return scaledImage.jpegData(compressionQuality: 0.9)
        }
        return nil
    }
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
