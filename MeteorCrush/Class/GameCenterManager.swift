//
//  GameCenterManager.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 23/07/25.
//

import Foundation
import GameKit
import SwiftUI

class GameCenterManager: NSObject, ObservableObject {
    static let shared = GameCenterManager()
    
    @Published var isAuthenticated = false
    @Published var isGuest = false
    @Published var localPlayer: GKLocalPlayer?
    @Published var leaderboardScores: [GKLeaderboard.Entry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let leaderboardID = "com.nathangunawan.MeteorCrush.highscore"
    
    override init() {
        super.init()
        authenticatePlayer()
    }
    
    // MARK: - Authentication
    func authenticatePlayer() {
        localPlayer = GKLocalPlayer.local
        
        localPlayer?.authenticateHandler = { [weak self] viewController, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Game Center authentication failed: \(error.localizedDescription)")
                    // Set as guest mode on authentication failure
                    self?.isAuthenticated = false
                    self?.isGuest = true
                    return
                }
                
                if let viewController = viewController {
                    // Present the authentication view controller
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController?.present(viewController, animated: true)
                    }
                } else {
                    let authenticated = self?.localPlayer?.isAuthenticated ?? false
                    self?.isAuthenticated = authenticated
                    self?.isGuest = !authenticated
                    
                    if authenticated {
                        self?.loadLeaderboardScores()
                    }
                }
            }
        }
    }
    
    // MARK: - Score Submission
    func submitScore(_ score: Int) {
        // Only submit scores if authenticated with Game Center
        guard isAuthenticated else {
            print("Score not submitted - playing as guest: \(score)")
            return
        }
        
        // Create a GKScore object
        let scoreReporter = GKScore(leaderboardIdentifier: leaderboardID)
        scoreReporter.value = Int64(score)
        
        // Submit the score
        GKScore.report([scoreReporter]) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to submit score: \(error.localizedDescription)")
                } else {
                    print("Score submitted successfully: \(score)")
                    // Score submitted successfully, reload leaderboard
                    self?.loadLeaderboardScores()
                }
            }
        }
    }
    
    // MARK: - Leaderboard Loading
    func loadLeaderboardScores() {
        guard isAuthenticated else { return }
        
        isLoading = true
        errorMessage = nil
        
        GKLeaderboard.loadLeaderboards(IDs: [leaderboardID]) { [weak self] (leaderboards, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.isLoading = false
                    self?.errorMessage = "Failed to load leaderboard: \(error.localizedDescription)"
                    return
                }
                
                guard let leaderboard = leaderboards?.first else {
                    self?.isLoading = false
                    self?.errorMessage = "Leaderboard not found"
                    return
                }
                
                leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 100)) { (localPlayerEntry, entries, totalPlayerCount, error) in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if let error = error {
                            self?.errorMessage = "Failed to load leaderboard entries: \(error.localizedDescription)"
                            return
                        }
                        
                        self?.leaderboardScores = entries ?? []
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    func getPlayerRank() -> Int? {
        guard let localPlayer = localPlayer, isAuthenticated else { return nil }
        
        if let index = leaderboardScores.firstIndex(where: { $0.player.playerID == localPlayer.playerID }) {
            return index + 1
        }
        return nil
    }
    
    func getPlayerScore() -> Int? {
        guard let localPlayer = localPlayer, isAuthenticated else { return nil }
        
        return leaderboardScores.first { $0.player.playerID == localPlayer.playerID }?.score
    }
    
    func retryAuthentication() {
        authenticatePlayer()
    }
}
