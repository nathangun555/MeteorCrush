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

    var onResume: () -> Void
    var gameScene: GameScene
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

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

                Button(action: {
                    SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                    isPresented = false
                    onResume()
                }) {
                    Text("Resume")
                        .font(.title2)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
            .padding(40)
        }
        .onAppear {
            
            valueSlider()
            valueHaptic()
            valueMusic()
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
