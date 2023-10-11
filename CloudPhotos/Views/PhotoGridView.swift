//
//  PhotoGridView.swift
//  CloudPhotos
//
//  Created by シン・ジャスティン on 2023/10/11.
//

import PhotosUI
import SwiftData
import SwiftUI

struct PhotoGridView: View {
    @Environment(\.modelContext) var modelContext
    @Namespace var namespace
    @State var photos: [Photo] = []
    @State var displayedPhoto: Photo?
    @State var selectedPhotoItems: [PhotosPickerItem] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80.0), spacing: 2.0)], spacing: 2.0) {
                    ForEach(photos, id: \.id) { photo in
                        if displayedPhoto != photo {
                            Button {
                                withAnimation {
                                    displayedPhoto = photo
                                }
                            } label: {
                                PhotoLabel(namespace: namespace, photo: photo)
                            }
                            .matchedGeometryEffect(id: photo.id, in: namespace)
                            .contextMenu {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    try? FileManager.default.removeItem(atPath: photo.photoPath())
                                    modelContext.delete(photo)
                                    reloadPhotos()
                                }
                            }
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .aspectRatio(1.0, contentMode: .fill)
                        }
                    }
                }
            }
            .refreshable {
                reloadPhotos()
            }
            .onAppear {
                reloadPhotos()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        PhotosPicker(selection: $selectedPhotoItems, matching: .images, photoLibrary: .shared()) {
                            Text("1. Select Photos (\(selectedPhotoItems.count))")
                        }
                        Button("2. Import") {
                            importPhotos()
                            reloadPhotos()
                        }
                    }
                }
            }
        }
        .overlay {
            if let displayedPhoto {
                PhotoViewer(namespace: namespace, photo: displayedPhoto) {
                    withAnimation {
                        self.displayedPhoto = nil
                    }
                }
            }
        }
    }
    
    func reloadPhotos() {
        withAnimation {
            do {
                photos = try modelContext.fetch(FetchDescriptor<Photo>(sortBy: [SortDescriptor<Photo>(\.id)]))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func importPhotos() {
        Task {
            for selectedPhotoItem in selectedPhotoItems {
                if let data = try? await selectedPhotoItem.loadTransferable(type: Data.self) {
                    let photo = Photo(data: data)
                    modelContext.insert(photo)
                }
            }
            selectedPhotoItems.removeAll()
        }
    }
}
