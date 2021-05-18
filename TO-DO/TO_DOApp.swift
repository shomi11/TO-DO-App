//
//  TO_DOApp.swift
//  TO-DO
//
//  Created by Milos Malovic on 16.5.21..
//

import SwiftUI
import CoreData

@main
struct TO_DOApp: App {
    
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }
    
    func save(_ notification: Notification) {
        dataController.save()
    }
}
