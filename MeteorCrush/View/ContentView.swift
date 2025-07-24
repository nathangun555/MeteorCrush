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

    @EnvironmentObject var leaderboardModel: LeaderboardModel

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

                            // Get player name from UserDefaults
                            let playerName = UserDefaults.standard.string(forKey: "username") ?? "Player"

                            // Update leaderboard
                            if leaderboardModel.players.contains(where: { $0.name == playerName }) {
                                let oldScore = leaderboardModel.players.first(where: { $0.name == playerName })?.score ?? 0
                                if currentScore > oldScore {
                                    leaderboardModel.updatePlayer(name: playerName, newScore: currentScore)
                                }
                            } else {
                                leaderboardModel.addPlayer(name: playerName, score: currentScore)
                            }

                            // Update best score locally
                            bestScore = max(currentScore, UserDefaults.standard.integer(forKey: "bestScore"))
                            if currentScore >= bestScore {
                                UserDefaults.standard.set(currentScore, forKey: "bestScore")
                            }
                        }
                    }

                if isGameOver {
                    GameOverView(
                        currentScore: currentScore,
                        bestScore: bestScore,
                        onPlayAgain: {
                            isGameOver = false
                            sceneID = UUID() // reload scene
                        },
                        onQuit: {
                            backToMenu = true
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
