//
//  MeteorCrushApp.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 10/07/25.
//

import SwiftUI

@main
struct MeteorCrushApp: App {
    @StateObject private var leaderboardModel = LeaderboardModel()

    var body: some Scene {
        WindowGroup {
            UserEntryView()
                .environmentObject(leaderboardModel) // ✅ share it everywhere
        }
    }
}
