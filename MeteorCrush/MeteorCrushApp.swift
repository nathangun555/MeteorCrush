//
//  MeteorCrushApp.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 10/07/25.
//

import SwiftUI

@main
struct MeteorCrushApp: App {
    @StateObject private var userData = UserData()

    var body: some Scene {
        WindowGroup {
            UsernameEntryView()
                .environmentObject(userData)
        }
    }
}
