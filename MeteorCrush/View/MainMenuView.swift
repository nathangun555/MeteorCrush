//
//  MainMenuView.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 14/07/25.
//


import SwiftUI

struct MainMenuView: View {
    @State private var showGame = false
    @State private var showLeaderboard = false
    @State private var showSettings = false
    @State private var rotateRocket = 0.0
    @State private var meteorSpawner: FallingMeteorSpawner?

    let radius: CGFloat = 270
    var body: some View {
        if showGame {
            ContentView()
        } else {
            ZStack {
                Image("bgHomeScreen")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(spacing: -80) {
                    Spacer()
                    ZStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                        
                        
                        Image("rocketBlue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .offset(x: -radius * cos(CGFloat(rotateRocket) * .pi / 180),
                                    y: radius * sin(CGFloat(rotateRocket) * .pi / 180))
                            .rotationEffect(.degrees(rotateRocket))
                    }
                    
                    
                    Spacer()
                    
                    // Tombol Start
                    ZStack {
                        Image("buttonStart")
                            .resizable()
                            .scaledToFit()
                        Button(action: {
                            SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                            showGame = true
                        }) {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.red.opacity(0))
                                .frame(width: 250, height: 50)
                        }
                    }
                    
                    // Tombol Leaderboard
                    ZStack {
                        Image("buttonLeaderboard")
                            .resizable()
                            .scaledToFit()
                        Button(action: {
                            SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                            showLeaderboard = true
                        }) {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.red.opacity(0))
                                .frame(width: 250, height: 50)
                        }
                    }

                    ZStack {
                        Image("buttonSettings")
                            .resizable()
                            .scaledToFit()
                        Button(action: {
                            SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                             showSettings = true
                        }) {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.red.opacity(0))
                                .frame(width: 250, height: 50)
                        }

                        NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                            EmptyView()
                        }
                    }
                    
                }
                .padding()
                .padding(.bottom, 10)
                .onAppear {
                    withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                        rotateRocket = 360
                    }
                }
            }
            .sheet(isPresented: $showLeaderboard) {
                Text("Leaderboard View (coming soon)")
                    .font(.title)
                    .padding()
            }
            .sheet(isPresented: $showSettings) {
                Text("Settings View (coming soon)")
                    .font(.title)
                    .padding()
            }
            .onAppear()
            {
                SoundManager.shared.playLobbyMusic()
                    UserDefaults.standard.set(1.0, forKey: "joystickSensitivity")
                    UserDefaults.standard.set(false, forKey: "joystickVisibility")
                    UserDefaults.standard.set(true, forKey: "hapticManager")
                    UserDefaults.standard.set(true, forKey: "musicManager")
            }
        }
    }
}

#Preview {
    MainMenuView()
}


