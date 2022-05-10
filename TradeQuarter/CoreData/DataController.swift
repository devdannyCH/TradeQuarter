//
//  DataController.swift
//  TradeQuarter
//
//  Created by Danny Dev on 06.05.22.
//

import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Tickers")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
