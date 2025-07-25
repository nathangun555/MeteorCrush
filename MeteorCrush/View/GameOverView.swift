//
//  GameOverView.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 14/07/25.


import SwiftUI

struct GameOverView: View {
    var currentScore: Int
    var bestScore: Int
    var onPlayAgain: () -> Void
    var onQuit: () -> Void
    
    var body: some View {
        
        ZStack {
            
            Image("gameOver")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
            
            GeometryReader { geometry in
                Text("\(bestScore)")
                    .font(.custom("Baloo2-ExtraBold", size: 25))
                    .foregroundColor(.white)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2.13)
                
                Text("\(currentScore)")
                    .font(.custom("Baloo2-ExtraBold", size: 30))
                    .foregroundStyle(Color(red: 89/255, green: 81/255, blue: 180/255))
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 1.68)
                // ZStack untuk Play Again dan Quit dengan lapisan yang sama
                ZStack {
                    // Tombol Play Again
                    Button(action: onPlayAgain) {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.red)
                            .frame(width: 120, height: 80)
                            .opacity(0)
                            
                    }
                    .position(x: geometry.size.width / 2.8, y: geometry.size.height / 1.4)

                    // Tombol Quit
                    Button(action: onQuit) {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.red)
                            .frame(width: 120, height: 80)
                            .opacity(0)
                            
                    }
                    .position(x: geometry.size.width / 1.55, y: geometry.size.height / 1.4)
                }
            }
        }
    }
}

