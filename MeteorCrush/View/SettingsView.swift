//
//  SettingsView.swift
//  MeteorCrush
//
//  Created by Vivi on 18/07/25.
//


import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // remove the hash
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    @State private var musicEnabled: Bool = true
    @State private var hapticFeedback: Bool = false
    @State private var joystickVisibility: Bool = UserDefaults.standard.bool(forKey: "joystickVisibility")
    @State private var joystickSensitivity: Double = UserDefaults.standard.double(forKey: "joystickSensitivity")
    @State private var showingUsernameAlert: Bool = false
    @State private var back: Bool = false
    @State private var joystickValue: Int = 0

    var body: some View {
        NavigationView{
            ZStack {
                Image("bgHomeScreen")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()
                
                VStack{
                    Image("bgSettings")
                        .resizable()
                        .frame(width: 330, height: 380)
                        .overlay(
                            VStack{
                                Text("SETTINGS")
                                    .foregroundStyle(.white)
                                    .bold()
                                    .font(fontTitle())
                                VStack{
                                    SettingsToggleRow(
                                        title: "Music",
                                        icon: "music.note",
                                        isOn: $musicEnabled
                                    )
                                    
                                    SettingsToggleRow(
                                        title: "Haptic",
                                        icon: "iphone.gen1.radiowaves.left.and.right",
                                        isOn: $hapticFeedback
                                    )
                                    
//                                    SettingsToggleRow(
//                                        title: "Joystick Visibility",
//                                        icon: "gamecontroller",
//                                        isOn: $joystickVisibility
//                                    )
                                    SettingsSliderRow(
                                        title: "Joystick Sensitivity",
                                        icon: "slider.horizontal.3",
                                        selectedIndex: $joystickValue
//                                        sliderRange: 0...1
                                    )
                                } .padding(.top, -30)
                                
                                .onChange(of: musicEnabled){
                                    vibrateWithDelay(.medium, count: 1, delayInterval: 0.0)
                                    let currentValue = UserDefaults.standard.bool(forKey: "musicManager")
                                    let newValue = !currentValue
                                    if newValue == false {
                                        SoundManager.shared.stopAllSounds()
                                        UserDefaults.standard.set(newValue, forKey: "musicManager")
                                    } else if newValue == true {
                                        UserDefaults.standard.set(newValue, forKey: "musicManager")
                                        SoundManager.shared.playLobbyMusic()
                                    }
                                }
                                .onChange(of: hapticFeedback){
                                    vibrateWithDelay(.medium, count: 1, delayInterval: 0.0)
                                    let currentValue = UserDefaults.standard.bool(forKey: "hapticManager")
                                    let newValue = !currentValue
                                    UserDefaults.standard.set(newValue, forKey: "hapticManager")
                                }
//                                .onChange(of: joystickVisibility){
//                                    vibrateWithDelay(.medium, count: 1, delayInterval: 0.0)
//                                    let currentValue = UserDefaults.standard.bool(forKey: "joystickVisibility")
//                                    let newValue = !currentValue
//                                    UserDefaults.standard.set(newValue, forKey: "joystickVisibility")
//                                }
                                .onChange(of: joystickValue) {  newValue in
                                    vibrateWithDelay(.medium, count: 1, delayInterval: 0.0)
                                    switch newValue {
                                    case 0:
                                        UserDefaults.standard.set(0.5, forKey: "joystickSensitivity")
                                    case 1:
                                        UserDefaults.standard.set(1.0, forKey: "joystickSensitivity")
                                    case 2:
                                        UserDefaults.standard.set(1.5, forKey: "joystickSensitivity")
                                    case 3:
                                        UserDefaults.standard.set(2.0, forKey: "joystickSensitivity")
                                    default:
                                        break
                                    }
                                }
                            }
                        )
                    ZStack{
                        Image("buttonBack")
                            .resizable()
                            .frame(width: 300, height: 180)
                            .scaledToFit()
                        Button(action: {
                            SoundManager.shared.playSFX(named: "buttonTap", withExtension: "wav")
                            dismiss()
                        }) {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color.clear)
                                .frame(width: 160, height: 50)
                        }
                    }.padding(.top, -30)
                }.padding(.top, 50)
            }
        }
        .onAppear()
        {
            valueSlider()
            valueHaptic()
            valueJoystickVisibility()
            valueMusic()
        }
    }
    func valueMusic()
    {
        let checker = UserDefaults.standard.bool(forKey: "musicManager")
        if checker {
            musicEnabled = true
        } else
        {
            musicEnabled = false
        }
    }
    func valueJoystickVisibility()
    {
        let checker = UserDefaults.standard.bool(forKey: "joystickVisibility")
        if checker {
            joystickVisibility = true
        } else
        {
            joystickVisibility = false
        }
    }
    func valueHaptic()
    {
        let checker = UserDefaults.standard.bool(forKey: "hapticManager")
        if checker {
            hapticFeedback = true
        } else
        {
            hapticFeedback = false
        }
    }
    func valueSlider() {
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



#Preview {
    SettingsView()
}

struct SettingsToggleRow: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .font(.title3)
                .frame(width: 30)
            
            Text(title)
                .font(fontSubTitle())
                .foregroundColor(.black)
            
            Spacer()
            
            // Custom Checkbox
            Button(action: {
                isOn.toggle()
            }) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(isOn ?  Color(hex: "#8f85ff") : .gray)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color.white)
        .frame(width: 250)
        .cornerRadius(10)
    }
}

struct SettingsSliderRow: View {
    let title: String
    let icon: String
    @Binding var selectedIndex: Int // 0 = 25%, 1 = 50%, ...
    private let sensitivity = [25, 50, 75, 100]

    var body: some View {
        VStack(spacing: 12) {
            // Title
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .font(.title2)
                    .frame(width: 30)

                Text(title)
                    .font(fontSubTitle())
                    .foregroundColor(.primary)

                Spacer()
            }

            VStack(spacing: 8) {
                // Discrete Slider pakai Stepper-style logic
                Slider(
                    value: Binding(
                        get: { Double(selectedIndex) },
                        set: { selectedIndex = Int(round($0)) }
                    ),
                    in: 0...3,
                    step: 1
                )
                .accentColor(Color(hex: "#8f85ff"))

                HStack {
                    ForEach(0..<sensitivity.count) { index in
                        Text("\(sensitivity[index])%")
                            .font(.custom("Baloo2-ExtraBold", size: 10))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .frame(width: 250)
        .cornerRadius(10)
    }
}
