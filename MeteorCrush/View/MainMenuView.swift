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

    var body: some View {
        NavigationView {
            if showGame {
                ContentView() // masuk ke game utama
            } else {
                ZStack {
                    // Background gradasi ungu
                    LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .ignoresSafeArea()
                    
                    VStack(spacing: 40) {
                        Spacer()
                        
                        // Logo Game
                        Image("logo") // ganti dengan logo kamu
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .shadow(radius: 10)
                        
                        Spacer()
                        
                        // Tombol Start
                        Button(action: {
                            showGame = true
                        }) {
                            menuButtonLabel("🚀 Start Game")
                        }
                        
                        // Tombol Leaderboard
                        Button(action: {
                            showLeaderboard = true
                        }) {
                            menuButtonLabel("🏆 Leaderboard")
                        }
                        
                        // Tombol Settings
                        NavigationLink(destination: SettingsView()) {
                            menuButtonLabel("⚙️ Settings")
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                // Optional: pop-up dummy buat leaderboard & setting
                .sheet(isPresented: $showLeaderboard) {
                    Text("Leaderboard View (coming soon)")
                        .font(.title)
                        .padding()
                }
            }
        }
        .onAppear()
        {
            if UserDefaults.standard.double(forKey: "joystickSensitivity") == nil
            {
                UserDefaults.standard.set(1.0, forKey: "joystickSensitivity")
                UserDefaults.standard.set(false, forKey: "joystickVisibility")
                UserDefaults.standard.set(true, forKey: "hapticManager")
                UserDefaults.standard.set(true, forKey: "musicManager")
            }
        }
    }

    // Komponen tombol reusable
    func menuButtonLabel(_ title: String) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 250, height: 50)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(15)
            .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    MainMenuView()
}
