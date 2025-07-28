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
