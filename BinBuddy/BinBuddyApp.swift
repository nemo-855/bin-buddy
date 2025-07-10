//
//  BinBuddyApp.swift
//  BinBuddy
//
//  Created by Kohei Inoue on 2025/07/10.
//

import SwiftUI
import CoreData

@main
struct BinBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
