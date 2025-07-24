//
//  GameOverView.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 14/07/25.
//

import SwiftUI

struct GameOverView: View {
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
                .foregroundColor(.black)

            Text("\(currentScore)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.black)

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
            }
        }
    }
}

