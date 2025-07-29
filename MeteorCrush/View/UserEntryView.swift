//
//  UserEntryView.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 24/07/25.
//

import SwiftUI

struct UserEntryView: View {
    @State private var username: String = ""
    @State private var isSubmitted = false
    @State private var errorMessage: String?
    @State private var animate = false
    @State private var fadeIn = false
    @State private var bounce = false

    @EnvironmentObject var leaderboardModel: LeaderboardModel

    var body: some View {
        NavigationStack {
            if isSubmitted {
                MainMenuView()
            } else {
                ZStack {
                    Image("bgHomeScreen")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    VStack(spacing: 0) {
                        
                        // Logo with bounce animation, does NOT block taps
                        Image("logoMeteorCrushUserEntryFix")
                            .resizable()
                            .scaledToFit()
                            .offset(y: bounce ? -8 : 8)
                            .frame(width: 470)
                            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: bounce)
                            .allowsHitTesting(false)
                          
                            .padding(.top, -50)
                            

                        

                        // Username entry and error message
                        VStack(spacing: 5) {
                            Text("Enter Your Username")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(fadeIn ? 1 : 0)
                                .offset(y: fadeIn ? 0 : 20)
                                .animation(.easeOut(duration: 0.6).delay(0.3), value: fadeIn)

                            ZStack {
                                Image("usernameTextBoxRevisi")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 280, height: 70)

                                TextField("", text: $username)
                                    .padding(.horizontal, 20)
                                    .frame(height: 50)
                                    .foregroundColor(.black)
                                    .background(Color.clear)
                                    .multilineTextAlignment(.center)
                                    .onChange(of: username) { newValue in
                                        if newValue.count > 8 {
                                            username = String(newValue.prefix(8))
                                        }
                                    }
                                    .placeholder(when: username.isEmpty) {
                                        Text("Max 8 Characters")
                                            .foregroundColor(.black.opacity(0.6))
                                            .font(.system(size: 18, weight: .bold))
                                    }
                            }
                            .opacity(fadeIn ? 1 : 0)
                            .offset(y: fadeIn ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.4), value: fadeIn)

                            if let error = errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))
                                    .opacity(fadeIn ? 1 : 0)
                                    .animation(.easeIn(duration: 0.4), value: fadeIn)
                            }
                        }

                        ZStack {
                            Image("buttonContinue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300)

                            Button(action: {
                                withAnimation(.easeIn(duration: 0.15)) {
                                    animate = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    animate = false
                                    handleSubmit()
                                }
                            }) {
                                Color.clear
                                    .frame(width: 195, height: 35) // match image size
                            }
                            .scaleEffect(animate ? 0.95 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animate)
                        }
                        .opacity(fadeIn ? 1 : 0)
                        .offset(y: fadeIn ? -40 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.5), value: fadeIn)
//                        // Continue Button
//                        Button(action: {
//                            withAnimation(.easeIn(duration: 0.15)) {
//                                animate = true
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                animate = false
//                                handleSubmit()
//                            }
//                        }) {
//                            Image("buttonContinue")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 300)
//                                .scaleEffect(animate ? 0.95 : 1.0)
//                                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animate)
//                                
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        .opacity(fadeIn ? 1 : 0)
//                        .offset(y: fadeIn ? -40 : -20)
//                        .animation(.easeOut(duration: 0.6).delay(0.5), value: fadeIn)
                    
                    }
            
                }
                .ignoresSafeArea(.all)
                .onAppear {
                    fadeIn = true
                    bounce = true
                }
            }
        }
    }

    private func handleSubmit() {
        let trimmed = username.trimmingCharacters(in: .whitespaces)

        if trimmed.isEmpty {
            errorMessage = "Name cannot be empty."
        } else if trimmed.count > 8 {
            errorMessage = "Name must be max 8 characters."
        } else if leaderboardModel.players.contains(where: { $0.name.lowercased() == trimmed.lowercased() }) {
            errorMessage = "Name already exists."
        } else {
            UserDefaults.standard.set(trimmed, forKey: "username")
            leaderboardModel.addPlayer(name: trimmed, score: 0)
            errorMessage = nil
            isSubmitted = true
        }
    }
}

// MARK: - TextField Placeholder Extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Preview
#Preview {
    UserEntryView()
        .environmentObject(LeaderboardModel())
}

