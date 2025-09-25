//
//  LeaderboardModel.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 23/07/25.
//

import Foundation
import SwiftUI
import GameKit
import Combine

struct Player: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var score: Int
    var playerID: String?
    
    init(name: String, score: Int, playerID: String? = nil) {
        self.name = name
        self.score = score
        self.playerID = playerID
    }
}

class LeaderboardModel: ObservableObject {
    @Published var players: [(rank: Int, name: String, score: Int)] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var isGuest = false
    
    private let gameCenterManager = GameCenterManager.shared
    
    init() {
        setupGameCenterObservers()
        loadGameCenterData()
    }
    
    private func setupGameCenterObservers() {
        // Observe Game Center authentication status
        gameCenterManager.$isAuthenticated
            .assign(to: &$isAuthenticated)
        
        // Observe guest mode status
        gameCenterManager.$isGuest
            .assign(to: &$isGuest)
        
        // Observe loading state
        gameCenterManager.$isLoading
            .assign(to: &$isLoading)
        
        // Observe error messages
        gameCenterManager.$errorMessage
            .assign(to: &$errorMessage)
        
        // Observe leaderboard scores changes
        gameCenterManager.$leaderboardScores
            .sink { [weak self] scores in
                self?.updatePlayersFromGameCenter(scores)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func loadGameCenterData() {
        if gameCenterManager.isAuthenticated {
            gameCenterManager.loadLeaderboardScores()
        }
    }
    
    func submitScore(_ score: Int) {
        gameCenterManager.submitScore(score)
    }
    
    func refreshLeaderboard() {
        gameCenterManager.loadLeaderboardScores()
    }
    
    func retryAuthentication() {
        gameCenterManager.retryAuthentication()
    }
    
    private func updatePlayersFromGameCenter(_ scores: [GKLeaderboard.Entry]) {
        players = scores.enumerated().map { index, entry in
            let playerName = entry.player.displayName.isEmpty ? "Anonymous" : entry.player.displayName
            return (rank: index + 1, name: playerName, score: entry.score)
        }
    }
    
    // MARK: - Computed Properties
    var currentPlayerRank: Int? {
        gameCenterManager.getPlayerRank()
    }
    
    var currentPlayerScore: Int? {
        gameCenterManager.getPlayerScore()
    }
    
    var hasError: Bool {
        errorMessage != nil
    }
}
