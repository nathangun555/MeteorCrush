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
                    
                    VStack(spacing: 20) {
                        Text("Enter Your Name")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        TextField("Max 8 characters", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250)
                            .multilineTextAlignment(.center)
                            .onChange(of: username) { newValue in
                                if newValue.count > 8 {
                                    username = String(newValue.prefix(8))
                                }
                            }

                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                        }

                        Button(action: handleSubmit) {
                            Text("Submit")
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
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
            // ✅ Save username for global use
            UserDefaults.standard.set(trimmed, forKey: "username")
            leaderboardModel.addPlayer(name: trimmed, score: 0)
            errorMessage = nil
            isSubmitted = true
        }
    }
}

#Preview {
    UserEntryView()
}
