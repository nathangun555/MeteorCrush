//
//  ContentView.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 10/07/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var sceneID = UUID()
    @State private var isGameOver = false
    @State private var currentScore = 0
    @State private var bestScore = 0
    @State private var backToMenu = false

    @StateObject private var leaderboardModel = LeaderboardModel() // ✅
    @EnvironmentObject var userData: UserData                      // ✅

    private var scene: SKScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        
        ZStack {
            if backToMenu {
                MainMenuView()
            } else {
                SpriteView(scene: scene)
                    .id(sceneID)
                    .ignoresSafeArea()
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("GameOver"))) { notif in
                        isGameOver = true
                        if let score = notif.object as? Int {
                            currentScore = score
                            bestScore = max(currentScore, UserDefaults.standard.integer(forKey: "bestScore"))
                            if currentScore >= bestScore{
                                UserDefaults.standard.set(currentScore, forKey: "bestScore")
                            }
                            // bestScore = max(score, bestScore)
                        }
                    }

                if isGameOver {
                    GameOverView(
                        leaderboardModel: leaderboardModel, // 🔁 moved to the top
                        currentScore: currentScore,
                        bestScore: bestScore,
                        onPlayAgain: {
                            isGameOver = false
                            sceneID = UUID()
                        },
                        onQuit: {
                            backToMenu = true
                        }
                    )
                    .environmentObject(userData)
                }
            }
        }
    }
}


#Preview {
    @Previewable var userData: UserData = UserData()
    ContentView().environmentObject(userData)
}
