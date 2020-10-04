//
//  PopcornSwirlApp.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI
import GoogleMobileAds

@main
struct PopcornSwirlApp: App {
    
    let persistenceController = PersistenceController.shared
    let genreListState = GenreListState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(genreListState)
        }
    }
}
