//
//  PhotoLabel.swift
//  CloudPhotos
//
//  Created by シン・ジャスティン on 2023/10/11.
//

import SwiftUI

struct PhotoLabel: View {
    var namespace: Namespace.ID
    var photo: Photo
    @State var thumbnailImage: UIImage?
    @State var state: CloudImageState = .notReadyForDisplay
    
    var body: some View {
        ZStack(alignment: .center) {
            if state == .readyForDisplay {
                if let thumbnailImage {
                    Image(uiImage: thumbnailImage)
                        .resizable()
                        .transition(.opacity.animation(.snappy))
                } else {
                    Rectangle()
                        .foregroundStyle(.primary.opacity(0.1))
                        .overlay {
                            Image(systemName: "xmark.circle.fill")
                        }
                }
            } else {
                Rectangle()
                    .foregroundStyle(.primary.opacity(0.1))
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .aspectRatio(1.0, contentMode: .fill)
        .contentShape(Rectangle())
        .onAppear {
            switch state {
            case .notReadyForDisplay:
                state = .downloading
                if let image = photo.thumbnailImage() {
                    thumbnailImage = image
                }
                state = .readyForDisplay
            case .hidden:
                state = .readyForDisplay
            default: break
            }
        }
        .onDisappear {
            state = .hidden
        }
        .draggable(PhotoTransferable(id: photo.id)) {
            if let thumbnailImage {
                Image(uiImage: thumbnailImage)
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
            }
        }
    }
}
