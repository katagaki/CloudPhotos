//
//  Photo.swift
//  CloudPhotos
//
//  Created by シン・ジャスティン on 2023/10/11.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Photo {
    var id = UUID().uuidString
    var thumbnail: Data = Data()
    
    init(data: Data) {
        FileManager.default.createFile(atPath: photoPath(), contents: data)
        if let data = try? Data(contentsOf: URL(filePath: photoPath())), let thumbnailData = Photo.makeThumbnail(data) {
            self.thumbnail = thumbnailData
        }
    }
    
    func photoPath() -> String {
        let documentsFolder = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsFolder.appendingPathComponent(id).path(percentEncoded: false)
    }
    
    func thumbnailImage() -> UIImage? {
        return UIImage(data: thumbnail)
    }
    
    static func makeThumbnail(_ data: Data?) -> Data? {
        if let data, let sourceImage = UIImage(data: data) {
            return sourceImage.jpegThumbnail()
        }
        return nil
    }
}
