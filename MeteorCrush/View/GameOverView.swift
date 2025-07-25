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
                    .font(.headline)
                    .foregroundColor(.black)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2.15)
                
                Text("\(currentScore)")
                    .font(.system(size: 40, weight: .bold))
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 1.69)
                    
                
                Button(action: onPlayAgain) {
                    Text("Play Again")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 110, height: 70)
                        .background(Color.green.opacity(0.7))
                        .cornerRadius(30)
//                        .position(x: 70, y: 600)
                        .position(x: geometry.size.width / 2.8, y: geometry.size.height / 1.4)
                        .opacity(0)
                }
                
                Button(action: onQuit) {
                    Text("Quit")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 110, height: 70)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(30)
//                        .position(x: 140, y: 600)
                        .position(x: geometry.size.width / 1.55, y: geometry.size.height / 1.4)
                        .opacity(0)
                }
                
            }

            
          
        }
    }
}


