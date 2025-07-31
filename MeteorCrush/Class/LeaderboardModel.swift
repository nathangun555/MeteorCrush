//
//  LeaderboardModel.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 23/07/25.
//

import Foundation
import SwiftUI

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
            Player(name: "Player1", score: 500),
            Player(name: "ABC", score: 450),
            Player(name: "Player2", score: 400),
            Player(name: "Player3", score: 375),
            Player(name: "Player4", score: 350),
            Player(name: "Player5", score: 325),
            Player(name: "Player6", score: 300),
            Player(name: "Player7", score: 275),
            Player(name: "Player8", score: 250),
            Player(name: "Player9", score: 225),
            Player(name: "Player10", score: 200),
            Player(name: "Player11", score: 150),
            Player(name: "Player12", score: 100)
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
