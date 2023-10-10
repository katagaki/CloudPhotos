//
//  App.swift
//  CloudPhotos
//
//  Created by シン・ジャスティン on 2023/10/11.
//

import SwiftUI
import SwiftData

@main
struct CloudPhotosApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Photo.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            PhotoGridView()
        }
        .modelContainer(sharedModelContainer)
    }
}
