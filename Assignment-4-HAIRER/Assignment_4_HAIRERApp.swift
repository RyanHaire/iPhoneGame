//
//  Assignment_4_HAIRERApp.swift
//  Assignment-4-HAIRER
//
//  Created by Ryan Haire on 2021-11-26.
//

import SwiftUI

@main
struct Assignment_4_HAIRERApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
