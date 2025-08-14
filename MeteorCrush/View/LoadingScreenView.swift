//
//  LoadingScreenView.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 06/08/25.
//


import SwiftUI

struct LoadingScreenView: View {
    
    @State private var rocketY: CGFloat = UIScreen.main.bounds.height * 0.94
    @State private var logoOpacity: Double = 0
    @State private var fadeOut = false
    @State private var goToMainMenu = false
    @State private var fireImageIndex: Int = 1 // Menyimpan index gambar fire (1 - 9)
    @State private var fireImage: String = "fire1.1"
    let fireImages = (1...9).map { "fire1.\($0)" }
    
    var body: some View {
        NavigationStack {
            if goToMainMenu {
                MainMenuView()
            } else {
                ZStack {
                    // Background
                    Image("bgHomeScreen")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    ZStack {
                        Image("logoMeteorCrushUserEntryFix")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 500)
                            .opacity(logoOpacity)
                            .position(
                                x: UIScreen.main.bounds.width / 2 + 10,
                                y: UIScreen.main.bounds.height / 2
                            )
                            .animation(.easeIn(duration: 1), value: logoOpacity)
                        
                        Image("rocketBlue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .position(
                                x: UIScreen.main.bounds.width / 2,
                                y: rocketY
                            )
                            .scaleEffect(rocketY < UIScreen.main.bounds.height * 0.95 ? 0.8 : 1.0)
                            .animation(
                                .timingCurve(0.2, 0.8, 0.4, 1.0, duration: 2),
                                value: rocketY
                            )

                        Image(fireImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 140)
                            .position(
                                x: UIScreen.main.bounds.width / 2,
                                y: rocketY + 110
                            )
                            .scaleEffect(rocketY < UIScreen.main.bounds.height * 0.95 ? 0.8 : 1.0)
                            .animation(.timingCurve(0.2, 0.8, 0.4, 1.0, duration: 2), value: rocketY)
                    }
                    .opacity(fadeOut ? 0 : 1)
                    .animation(.easeOut(duration: 1), value: fadeOut)
                }
                .onAppear {
                    startAnimation()
                    startFireAnimation()
                }
            }
        }
    }

    private func startFireAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if fireImageIndex < fireImages.count {
                fireImage = fireImages[fireImageIndex]
                fireImageIndex += 1
            } else {
                fireImageIndex = 0
            }
        }
    }

    private func startAnimation() {
        withAnimation(.timingCurve(0.2, 0.8, 0.4, 1.0, duration: 10)) {
            rocketY = -UIScreen.main.bounds.height * 0.4
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            logoOpacity = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            fadeOut = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            goToMainMenu = true
        }
    }
}

#Preview {
    LoadingScreenView()
}
