//
//  GameOverView.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 14/07/25.
//

//import SwiftUI
//
//struct GameOverView: View {
//    var currentScore: Int
//    var bestScore: Int
//    var onPlayAgain: () -> Void
//    var onQuit: () -> Void
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("GAME OVER")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .foregroundColor(.red)
//
//            Text("Best Score : \(bestScore)")
//                .font(.headline)
//                .foregroundColor(.black)
//
//            Text("You Just Scored")
//                .font(.subheadline)
//
//            Text("\(currentScore)")
//                .font(.system(size: 40, weight: .bold))
//
//            Button(action: onPlayAgain) {
//                Text("Play Again")
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                    .padding()
//                    .frame(width: 200)
//                    .background(Color.green.opacity(0.7))
//                    .cornerRadius(15)
//            }
//
//            Button(action: onQuit) {
//                Text("Quit")
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                    .padding()
//                    .frame(width: 200)
//                    .background(Color.red.opacity(0.7))
//                    .cornerRadius(15)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(20)
//        .shadow(radius: 10)
//    }
//}



import SwiftUI

//
//  LeaderboardModel.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 23/07/25.
//

import Foundation

struct Player: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var score: Int
}

class LeaderboardModel: ObservableObject {
    @Published var players: [(rank: Int, name: String, score: Int)] = []
    @Published var newlyAddedPlayers: [Player] = [] // ✅ New list to track added players

    init() {
        loadDummyData()
    }

    func loadDummyData() {
        let dummyPlayers: [Player] = [
            Player(name: "Nathan", score: 1037),
            Player(name: "ABC", score: 1037),
            Player(name: "PlayerSix", score: 1001),
            Player(name: "PlayerSeven", score: 950),
            Player(name: "PlayerEight", score: 900),
            Player(name: "PlayerNine", score: 850),
            Player(name: "PlayerTen", score: 800),
            Player(name: "PlayerNine", score: 850),
            Player(name: "PlayerNine2", score: 850),
            Player(name: "PlayerNine3", score: 850),
            Player(name: "PlayerNine4", score: 850),
            Player(name: "PlayerNin5", score: 850),
            Player(name: "PlayerNine6", score: 850)
        ]

        updateRanks(with: dummyPlayers)
    }

    func addPlayer(name: String, score: Int) {
        var currentPlayers = players.map { Player(name: $0.name, score: $0.score) }

        let newPlayer = Player(name: name, score: score)

        if !currentPlayers.contains(where: { $0.name == newPlayer.name }) {
            currentPlayers.append(newPlayer)
            newlyAddedPlayers.append(newPlayer) // ✅ Track the added player
        }

        updateRanks(with: currentPlayers)
    }

    func updatePlayer(name: String, newScore: Int) {
        var currentPlayers = players.map { Player(name: $0.name, score: $0.score) }

        if let index = currentPlayers.firstIndex(where: { $0.name == name }) {
            currentPlayers[index].score = newScore
            updateRanks(with: currentPlayers)
        }
    }

    private func updateRanks(with players: [Player]) {
        let sorted = players.sorted { $0.score > $1.score }
        self.players = sorted.enumerated().map { index, player in
            (rank: index + 1, name: player.name, score: player.score)
        }
    }
}


struct GameOverView: View {
    @EnvironmentObject var userData: UserData           // ✅ Access current username
    @ObservedObject var leaderboardModel: LeaderboardModel
    
    var currentScore: Int
    var bestScore: Int
    var onPlayAgain: () -> Void
    var onQuit: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("GAME OVER")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Text("Best Score : \(bestScore)")
                .font(.headline)
                .foregroundColor(.black)
            
            Text("You Just Scored")
                .font(.subheadline)
            
            Text("\(currentScore)")
                .font(.system(size: 40, weight: .bold))
            
            Button(action: onPlayAgain) {
                Text("Play Again")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 200)
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(15)
            }
            
            Button(action: onQuit) {
                Text("Quit")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 200)
                    .background(Color.red.opacity(0.7))
                    .cornerRadius(15)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .onAppear {
            SoundManager.shared.playSFX(named: "gameOver", withExtension: "wav")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                SoundManager.shared.stopAllSounds()
                let username = userData.username.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !username.isEmpty else { return }
                
                // Check if player exists
                if let existingPlayer = leaderboardModel.players.first(where: { $0.name == username }) {
                    if currentScore > existingPlayer.score {
                        leaderboardModel.updatePlayer(name: username, newScore: currentScore)
                    }
                } else {
                    leaderboardModel.addPlayer(name: username, score: currentScore)
                }
            }
        }
    }
}
