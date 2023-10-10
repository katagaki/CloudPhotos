//
//  CloudImageState.swift
//  CloudPhotos
//
//  Created by シン・ジャスティン on 2023/10/11.
//

import Foundation

enum CloudImageState {
    case notReadyForDisplay
    case downloading
    case downloaded
    case readyForDisplay
    case hidden
}
