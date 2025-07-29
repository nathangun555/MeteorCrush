//
//  MainMenuView.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 14/07/25.
//

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
    @State private var animateEntrance = false

    let radius: CGFloat = 270

    var body: some View {
        NavigationStack {
            if showGame {
                ContentView()
            } else {
                ZStack {
                    Image("bgMainMenuRevisi")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    VStack {
                        // Logo & Rocket
                        ZStack {
                            Image("logoMeteorCrushHomeFix")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 380)
                                .opacity(animateEntrance ? 1 : 0)
                                .offset(y: animateEntrance ? 0 : -60)
                                .animation(.easeOut(duration: 1.0), value: animateEntrance)
                                .padding(.top, 220)

                            
                            Image("rocketBlue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .offset(x: -radius * cos(CGFloat(rotateRocket) * .pi / 180),
                                        y: radius * sin(CGFloat(rotateRocket) * .pi / 180))
                                .rotationEffect(.degrees(rotateRocket))
                                .padding(.top, 220)
                        }
                       

                        Spacer()

                        // Buttons
                        VStack(spacing: -120) {
                            animatedButton(imageName: "buttonStart", delay: 0.1) {
                                SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                                showGame = true
                            }

                            animatedButton(imageName: "buttonLeaderboard", delay: 0.2) {
                                SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                                showLeaderboard = true
                            }
                            .background(
                                NavigationLink(destination: LeaderboardView().navigationBarBackButtonHidden(true), isActive: $showLeaderboard) {
                                    EmptyView()
                                }.hidden()
                            )

                            animatedButton(imageName: "buttonSettings", delay: 0.3) {
                                SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                                showSettings = true
                            }
                            .background(
                                NavigationLink(destination: SettingsView().navigationBarBackButtonHidden(true), isActive: $showSettings) {
                                    EmptyView()
                                }.hidden()
                            )
                        }
                        .padding(.top, -580)
                       
                    }
                    .padding(.horizontal)
                    .onAppear {
                        withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                            rotateRocket = 360
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            animateEntrance = true
                        }

                        // Default settings
                        SoundManager.shared.playLobbyMusic()

                        let defaults = UserDefaults.standard

                        if defaults.object(forKey: "joystickSensitivity") == nil {
                            defaults.set(1.0, forKey: "joystickSensitivity")
                        }

                        if defaults.object(forKey: "joystickVisibility") == nil {
                            defaults.set(false, forKey: "joystickVisibility")
                        }

                        if defaults.object(forKey: "hapticManager") == nil {
                            defaults.set(true, forKey: "hapticManager")
                        }

                        if defaults.object(forKey: "musicManager") == nil {
                            defaults.set(true, forKey: "musicManager")
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func animatedButton(imageName: String, delay: Double, action: @escaping () -> Void) -> some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 450)
                .opacity(animateEntrance ? 1 : 0)
                .offset(y: animateEntrance ? 0 : 30)
                .animation(.interpolatingSpring(stiffness: 100, damping: 12).delay(delay), value: animateEntrance)

            Button(action: action) {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.red.opacity(0.01)) // allows tap recognition
                    .frame(width: 250, height: 50)
            }
        }
    }
}

#Preview {
    MainMenuView()
}
