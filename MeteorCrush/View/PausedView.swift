//
//  PausedView.swift
//  MeteorCrush
//
//  Created by Vivi on 06/08/25.
//
import SwiftUI

struct PausedView: View {
    @Binding var isPresented: Bool
    @State private var musicEnabled: Bool = UserDefaults.standard.bool(forKey: "musicManager")
    @State private var hapticFeedback: Bool = UserDefaults.standard.bool(forKey: "hapticManager")
    @State private var joystickVisibility: Bool = UserDefaults.standard.bool(forKey: "joystickVisibility")
    @State private var joystickValue: Int = 0
    
    @State private var showCountdown = false
     @State private var countdownNumber = 3
     @State private var showGo = false
    
    var onResume: () -> Void
    var gameScene: GameScene
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            if !showCountdown {
                VStack(spacing: 30) {
                    Image("bgSettings")
                        .resizable()
                        .frame(width: 330, height: 380)
                        .overlay(
                            VStack(spacing: 0) {
                                Text("GAME PAUSE")
                                    .foregroundStyle(.white)
                                    .bold()
                                    .font(fontTitle())
                                VStack{
                                    SettingsToggleRow(title: "Music", icon: "music.note", isOn: $musicEnabled)
                                    SettingsToggleRow(title: "Haptic", icon: "iphone.gen1.radiowaves.left.and.right", isOn: $hapticFeedback)
                                    SettingsSliderRow(
                                        title: "Joystick Sensitivity",
                                        icon: "slider.horizontal.3",
                                        selectedIndex: $joystickValue
                                        //                                        sliderRange: 0...1
                                    )
                                    
                                }
                                
                            }
                                .onChange(of: musicEnabled) {
                                    let newValue = musicEnabled
                                    UserDefaults.standard.set(newValue, forKey: "musicManager")
                                    if newValue {
                                        SoundManager.shared.playLobbyMusic()
                                    } else {
                                        SoundManager.shared.stopAllSounds()
                                    }
                                }
                                .onChange(of: hapticFeedback) {
                                    UserDefaults.standard.set(hapticFeedback, forKey: "hapticManager")
                                }
                                .onChange(of: joystickValue) { newValue in
                                    vibrateWithDelay(.medium, count: 1, delayInterval: 0.0)
                                    let sensitivity: Double
                                    switch newValue {
                                    case 0: sensitivity = 0.5
                                    case 1: sensitivity = 1.0
                                    case 2: sensitivity = 1.5
                                    case 3: sensitivity = 2.0
                                    default: sensitivity = 1.0
                                    }
                                    
                                    UserDefaults.standard.set(sensitivity, forKey: "joystickSensitivity")
                                    gameScene.joystick.sensitivity = sensitivity  // <- update yang benar
                                }
                        )
                    ZStack{
                        Image("resumeButton")
                            .resizable()
                            .frame(width: 400, height: 180)
                            .scaledToFit()
                        Button(action: {
                            SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                            startCountdown()
                        }) {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.clear)
                                .frame(width: 250, height: 50)
                        }
                    } .padding(-50)
                }
                .padding(0)
            }
            if showCountdown {
                           VStack {
                               if showGo {
                                   Text("GO!")
                                       .font(.custom("Baloo2-ExtraBold", size: 60))                                       .foregroundColor(.white)
                                       .scaleEffect(countdownNumber == 0 ? 1.0 : 0.3)
                                       .animation(.easeOut(duration: 0.3), value: countdownNumber)
                               } else {
                                   Text("\(countdownNumber)")
                                       .font(.custom("Baloo2-ExtraBold", size: 60))
                                       .foregroundColor(.white)
                                       .scaleEffect(1.0)
                                       .animation(.easeOut(duration: 0.3), value: countdownNumber)
                               }
                           }
                           .onAppear {
                               animateCountdown()
                           }
                       }
                   }
        .onAppear {
            
            valueSlider()
            valueHaptic()
            valueMusic()
        }
    }
    private func startCountdown() {
            showCountdown = true
            countdownNumber = 3
            showGo = false
        }
        
        private func animateCountdown() {
            // Animasi untuk angka 3
            withAnimation(.easeOut(duration: 0.3)) {
                // Scale effect sudah di-handle di Text
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if countdownNumber > 1 {
                    countdownNumber -= 1
                    animateCountdown()
                } else {
                    // Tampilkan "GO!"
                    showGo = true
                    countdownNumber = 0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        // Tutup pause view dan resume game
                        isPresented = false
                        SoundManager.shared.meteor?.play()
                        onResume()
                    }
                }
            }
        }
    private func valueMusic()
    {
        let checker = UserDefaults.standard.bool(forKey: "musicManager")
        if checker {
            musicEnabled = true
        } else
        {
            musicEnabled = false
        }
    }
    private func valueHaptic()
    {
        let checker = UserDefaults.standard.bool(forKey: "hapticManager")
        if checker {
            hapticFeedback = true
        } else
        {
            hapticFeedback = false
        }
    }
    private func valueSlider() {
        let checker = UserDefaults.standard.double(forKey: "joystickSensitivity")
        switch checker {
        case 0.5:
            joystickValue = 0
        case 1.0:
            joystickValue = 1
        case 1.5:
            joystickValue = 2
        case 2.0:
            joystickValue = 3
        default:
            joystickValue = 1 // fallback default
        }
    }

}
