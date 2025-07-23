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
