//
//  LeaderboardView.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 22/07/25.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var leaderboardModel: LeaderboardModel
    @Environment(\.dismiss) var dismiss

    // Animation states
    @State private var fadeIn = false
    @State private var animateStars = false

    var body: some View {
        ZStack {
            Image("bg1")
                .resizable()
                .ignoresSafeArea()

            if leaderboardModel.isGuest {
                // Guest Mode - No Leaderboard Access
                VStack(spacing: 30) {
                    Text("GUEST MODE")
                        .font(fontTitle())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 100)
                    
                    Text("Sign in to Game Center to view global leaderboards")
                        .font(fontSubTitle())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        leaderboardModel.retryAuthentication()
                    }) {
                        ZStack {
                            Image("buttonContinue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 60)
                            Text("SIGN IN")
                                .font(fontSubTitle())
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Image("buttonBack")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 60)
                            Text("BACK")
                                .font(fontSubTitle())
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }
            } else if leaderboardModel.isLoading {
                // Loading State
                VStack(spacing: 20) {
                    Text("LEADERBOARD")
                        .font(fontTitle())
                        .foregroundColor(.white)
                        .padding(.top, 100)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    
                    Text("Loading scores...")
                        .font(fontSubTitle())
                        .foregroundColor(.white)
                }
            } else if leaderboardModel.hasError {
                // Error State
                VStack(spacing: 30) {
                    Text("ERROR")
                        .font(fontTitle())
                        .foregroundColor(.white)
                        .padding(.top, 100)
                    
                    Text(leaderboardModel.errorMessage ?? "Failed to load leaderboard")
                        .font(fontSubTitle())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Button(action: {
                        leaderboardModel.refreshLeaderboard()
                    }) {
                        ZStack {
                            Image("buttonContinue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 60)
                            Text("RETRY")
                                .font(fontSubTitle())
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Image("buttonBack")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 60)
                            Text("BACK")
                                .font(fontSubTitle())
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }
            } else {
                // Normal Leaderboard View
                VStack(spacing: 20) {
                    Text("LEADERBOARD")
                        .font(fontTitle())
                        .foregroundColor(.white)
                        .padding(.top, 100)
                        .padding(.bottom, 20)
                        .opacity(fadeIn ? 1 : 0)
                        .offset(y: fadeIn ? 0 : -20)
                        .animation(.easeOut(duration: 0.6), value: fadeIn)

                // Top 3
                HStack(alignment: .bottom, spacing: 30) {
                    leaderboardTop(rankImage: "leaderboardRank2", name: getName(for: 2), score: getScore(for: 2))
                        .padding(.bottom, 20)
                        .scaleEffect(animateStars ? 1.03 : 0.95)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateStars)

                    leaderboardTop(rankImage: "leaderboardRank1", name: getName(for: 1), score: getScore(for: 1))
                        .scaleEffect(animateStars ? 1.07 : 0.97)
                        .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: animateStars)

                    leaderboardTop(rankImage: "leaderboardRank3", name: getName(for: 3), score: getScore(for: 3))
                        .padding(.bottom, 20)
                        .scaleEffect(animateStars ? 1.03 : 0.97)
                        .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: animateStars)
                }
                .opacity(fadeIn ? 1 : 0)
                .offset(y: fadeIn ? 0 : -10)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: fadeIn)

                // Ranks 4+
                ZStack(alignment: .top) {
                    Image("leaderboardHolder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 380)

                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(leaderboardModel.players.filter { $0.rank > 3 }, id: \.rank) { player in
                                ZStack {
                                    Image("leaderboardRankOthers2")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 330)

                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.clear)
                                                .frame(width: 36, height: 36)
                                            Text("#\(player.rank)")
                                                .font(fontSubTitle2())
                                                .foregroundColor(.white)
                                        }

                                        HStack {
                                            Text(player.name)
                                                .font(fontSubTitle2())
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .fontWeight(.bold)
                                                .offset(x: -5)

                                            Spacer()

                                            Text("\(player.score) pts")
                                                .font(fontSubTitle3())
                                                .foregroundColor(.yellow)
                                                .padding(.trailing, 11)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .padding(.horizontal, 36)
                                }
                            }
                        }
                        .padding(.top, 18)
                        .padding(.bottom, 16)
                    }
                    .frame(height: 330) // Limit scroll height
                }
                .padding(.top, 20)
                .opacity(fadeIn ? 1 : 0)
                .offset(y: fadeIn ? 0 : 10)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: fadeIn)

                    ZStack{
                        Image("buttonBack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 320, height: 300)
                        Button(action: {
                            SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                            dismiss()
                        }) {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.clear)
                                .frame(width: 180, height: 40)
                        }
                    }.padding(.top, -100)
                }.padding(.top, 20)
            }
        }
        .onAppear {
            withAnimation {
                fadeIn = true
            }
            animateStars = true
            leaderboardModel.refreshLeaderboard()
        }
    }

    // Helpers
    private func getName(for rank: Int) -> String {
        leaderboardModel.players.first(where: { $0.rank == rank })?.name ?? "Player"
    }

    private func getScore(for rank: Int) -> String {
        if let score = leaderboardModel.players.first(where: { $0.rank == rank })?.score {
            return "\(score) pts"
        }
        return "-"
    }

    private func leaderboardTop(rankImage: String, name: String, score: String) -> some View {
        VStack(spacing: 2) {
            Image(rankImage)
                .resizable()
                .frame(width: 80, height: 80)
            VStack(spacing: -1) {
                Text(name)
                    .font(fontSubTitle())
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text(score)
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .font(fontSubTitle2())
                    .padding(.top, -5)
            }
        }
    }
}

#Preview {
    LeaderboardView().environmentObject(LeaderboardModel())
}
