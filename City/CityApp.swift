//
//  CityApp.swift
//  City
//
//  Created by Leo Powers on 5/4/23.
//

import SwiftUI

@main
struct CityApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
