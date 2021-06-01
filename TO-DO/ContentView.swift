//
//  ContentView.swift
//  TO-DO
//
//  Created by Milos Malovic on 16.5.21..
//

import SwiftUI
import CoreSpotlight

struct ContentView: View {

    /// Saving last user scene in scene storage
    /// In App storage if user open two instances of app on iPad it will be shared on both.
    @SceneStorage("selectedView") var selectedView: String?

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ProjectView(showClosedProject: false)
                .tag(ProjectView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            ProjectView(showClosedProject: true)
                .tag(ProjectView.closeTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
        }.onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
    }

    /// When user taps task in spot light always return first to home
    /// - Parameter input: any input
    func moveToHome(_ input: Any) {
        selectedView = HomeView.tag
    }
}

struct ContentView_Previews: PreviewProvider {

    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
