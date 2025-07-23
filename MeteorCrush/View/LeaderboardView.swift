//
//  LeaderboardView.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 22/07/25.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardModel()

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

                // Top 3
                HStack(alignment: .bottom, spacing: 30) {
                    leaderboardTop(rankImage: "leaderboardRank2", name: getName(for: 2), score: getScore(for: 2))
                        .padding(.bottom, 20)

                    leaderboardTop(rankImage: "leaderboardRank1", name: getName(for: 1), score: getScore(for: 1))

                    leaderboardTop(rankImage: "leaderboardRank3", name: getName(for: 3), score: getScore(for: 3))
                        .padding(.bottom, 20)
                }

                // Ranks 4+
                ZStack(alignment: .top) {
                    Image("leaderboardHolder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 380)

                    ScrollView() {
                        VStack(spacing: 8) {
                            ForEach(viewModel.players.filter { $0.rank > 3 }, id: \.rank) { player in
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

                Spacer()

                // For testing: Button to add new player
                Button(action: {
                    viewModel.addPlayer(name: "You", score: Int.random(in: 10...50))
                }) {
                    Text("Simulate Player Score")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom, 40)
            }
        }
    }

    // Helpers
    private func getName(for rank: Int) -> String {
        viewModel.players.first(where: { $0.rank == rank })?.name ?? "Player"
    }

    private func getScore(for rank: Int) -> String {
        if let score = viewModel.players.first(where: { $0.rank == rank })?.score {
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



struct NonBouncingScrollView<Content: View>: UIViewRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear

        let hostingController = UIHostingController(rootView: content)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear

        scrollView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        context.coordinator.hostingController = hostingController

        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        if let hostingController = context.coordinator.hostingController {
            hostingController.rootView = content
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var hostingController: UIHostingController<Content>?
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
