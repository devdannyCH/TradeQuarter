//
//  TradeQuarterApp.swift
//  TradeQuarter
//
//  Created by Danny Dev on 04.05.22.
//

import SwiftUI
import CoreData

@main
struct TradeQuarterApp: App {
            
    var body: some Scene {
        WindowGroup {
            TickersView()
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
