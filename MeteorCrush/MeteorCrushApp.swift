//
//  MeteorCrushApp.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 10/07/25.
//

import SwiftUI

class UserData: ObservableObject {
    @Published var username: String = ""
}

@main
struct MeteorCrushApp: App {
    @StateObject private var userData = UserData()

    var body: some Scene {
        WindowGroup {
            MainMenuView().environmentObject(userData)

// <<<<<<< Updated upstream
//             ContentView()
// =======
//             UsernameEntryView()
        }
    }
}
