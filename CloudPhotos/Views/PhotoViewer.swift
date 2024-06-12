//
//  PhotoViewer.swift
//  CloudPhotos
//
//  Created by シン・ジャスティン on 2023/10/11.
//

import SwiftUI

struct PhotoViewer: View {
    var namespace: Namespace.ID
    @State var photo: Photo
    @State var displayOffset: CGSize = .zero
    @State var isFileFromCloudReadyForDisplay: Bool = false
    @State var displayedImage: UIImage?
    var closeAction: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Spacer(minLength: 0)
            ZStack {
                if isFileFromCloudReadyForDisplay {
                    if let displayedImage {
                        Image(uiImage: displayedImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .overlay {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .overlay {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .matchedGeometryEffect(id: photo.id, in: namespace)
            .offset(displayOffset)
            Spacer(minLength: 0)
            if let closeAction {
                Button("Close") {
                    closeAction()
                }
                .padding()
                .opacity(opacityDuringGesture())
            }
        }
        .frame(maxWidth: .infinity)
        .background(.regularMaterial.opacity(opacityDuringGesture()))
        .onAppear {
            do {
                if let data = try? Data(contentsOf: URL(filePath: photo.photoPath())),
                   let image = UIImage(data: data) {
                    displayedImage = image
                    isFileFromCloudReadyForDisplay = true
                } else {
                    try FileManager.default.startDownloadingUbiquitousItem(
                        at: URL(filePath: photo.photoPath()))
                    var isDownloaded: Bool = false
                    while !isDownloaded {
                        if FileManager.default.fileExists(atPath: photo.photoPath()) {
                            isDownloaded = true
                        }
                    }
                    let data = try? Data(contentsOf: URL(filePath: photo.photoPath()))
                    if let data, let image = UIImage(data: data) {
                        displayedImage = image
                    }
                    isFileFromCloudReadyForDisplay = true
                }
            } catch {
                debugPrint(error.localizedDescription)
                isFileFromCloudReadyForDisplay = true
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if closeAction != nil {
                        displayOffset = gesture.translation
                    }
                }
                .onEnded { gesture in
                    if let closeAction {
                        if hypotenuse(gesture.translation) > 100.0 {
                            closeAction()
                        } else {
                            withAnimation {
                                displayOffset = .zero
                            }
                        }
                    }
                }
        )
    }
    
    func opacityDuringGesture() -> Double {
        1.0 - hypotenuse(displayOffset) / 100.0
    }
    
    func hypotenuse(_ translation: CGSize) -> Double {
        let width = translation.width
        let height = translation.height
        return sqrt((width * width) + (height * height))
    }
}
