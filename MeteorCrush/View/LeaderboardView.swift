//
//  LeaderboardView.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 22/07/25.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var leaderboardModel: LeaderboardModel

    // Animation states
    @State private var fadeIn = false
    @State private var animateStars = false

    var body: some View {
        ZStack {
            Image("bg1")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("LEADERBOARD")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
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
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                        }

                                        HStack {
                                            Text(player.name)
                                                .font(.system(size: 12))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .fontWeight(.bold)
                                                .offset(x: -5)

                                            Spacer()

                                            Text("\(player.score) pts")
                                                .font(.system(size: 9))
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

                Spacer()

                // For testing: Button to add new player
                Button(action: {
                    leaderboardModel.addPlayer(name: "You", score: Int.random(in: 10...50))
                }) {
                    Text("Simulate Player Score")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom, 40)
                .opacity(fadeIn ? 1 : 0)
                .offset(y: fadeIn ? 0 : 10)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: fadeIn)
            }
        }
        .onAppear {
            withAnimation {
                fadeIn = true
            }
            animateStars = true
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
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text(score)
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .font(.system(size: 11))
            }
        }
    }
}

#Preview {
    LeaderboardView().environmentObject(LeaderboardModel())
}
