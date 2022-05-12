//
//  Persistence.swift
//  TQ
//
//  Created by Danny Dev on 06.05.22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let tBTCUSD = Ticker(context: viewContext)
        tBTCUSD.symbol = "BTC"
        tBTCUSD.lastPrice = 39630.06427442
        tBTCUSD.dailyChange = -0.0852
        let tETHUSD = Ticker(context: viewContext)
        tETHUSD.symbol = "ETH"
        tETHUSD.lastPrice = 3630.06427442
        tETHUSD.dailyChange = 1.2852
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TradeQuarter")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        // Overwrite local data with incoming data
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
    }
}
