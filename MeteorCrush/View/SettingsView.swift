//
//  SettingsView.swift
//  MeteorCrush
//
//  Created by Vivi on 18/07/25.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    @State private var musicEnabled: Bool = true
    @State private var hapticEnabled: Bool = true
    @State private var joystickVisibility: Bool = true
    @State private var joystickSensitivity: Double = UserDefaults.standard.double(forKey: "joystickSensitivity")
    @State private var showingUsernameAlert: Bool = false
    @State private var back: Bool = false
    @State private var joystickValue = 0.0
    
    var body: some View {
        NavigationView{
            ZStack {
                // Background gradasi ungu
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                VStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 300, height: 400)
                        .overlay(
                            VStack{
                                Text("Settings")
                                    .bold()
                                    .font(.title)
                                SettingsToggleRow(
                                    title: "Music",
                                    icon: "music.note",
                                    isOn: $musicEnabled
                                )
                                
                                SettingsToggleRow(
                                    title: "Haptic",
                                    icon: "iphone.radisowaves.left.and.right",
                                    isOn: $hapticEnabled
                                )
                                
                                SettingsToggleRow(
                                    title: "Joystick Visibility",
                                    icon: "gamecontroller",
                                    isOn: $joystickVisibility
                                )
                                SettingsSliderRow(
                                    title: "Joystick Sensitivity",
                                    icon: "slider.horizontal.3",
                                    sliderValue: $joystickValue,
                                    sliderRange: 0...1
                                )
                                .onChange(of: joystickValue) { newValue in
                                    if joystickValue == 0.0
                                    {
                                        UserDefaults.standard.set(0.0, forKey: "joystickSensitivity")
                                    } else if joystickValue == 0.25 {
                                        UserDefaults.standard.set(0.5, forKey: "joystickSensitivity")
                                    } else if joystickValue == 0.5 {
                                        UserDefaults.standard.set(1.0, forKey: "joystickSensitivity")
                                    } else if joystickValue == 0.75 {
                                        UserDefaults.standard.set(1.5, forKey: "joystickSensitivity")
                                    } else if joystickValue == 1.0
                                    {
                                        UserDefaults.standard.set(2, forKey: "joystickSensitivity")
                                    }
                                }
                                .onChange(of: joystickValue) {
                                    // joystick
                                }
                            }
                        )
                    Button(action: {
                                    dismiss()
                                }) {
                                    Text("Back")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(width: 250, height: 50)
                                        .background(Color.blue.opacity(0.8))
                                        .cornerRadius(15)
                                        .shadow(color: .white.opacity(0.3), radius: 5, x: 0, y: 3)
                                        .padding(.top, 30)
                                }
                }
            }
        }
        .onAppear()
        {
            valueSlider()
        }
    }
    
    func valueSlider(){
        let checker = UserDefaults.standard.double(forKey: "joystickSensitivity")
        if checker == 0.0
        {
            joystickValue = 0
        } else if checker == 0.5
        {
            joystickValue = 0.25
        } else if checker == 1.0
        {
            joystickValue = 0.5
        } else if checker == 1.5
        {
            joystickValue = 0.75
        } else if checker == 2.0
        {
            joystickValue = 1.0
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
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Custom Checkbox
            Button(action: {
                isOn.toggle()
            }) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(isOn ? .blue : .gray)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .frame(width: 250)
        .cornerRadius(10)
    }
}

struct SettingsSliderRow: View {
    let title: String
    let icon: String
    @Binding var sliderValue: Double
    let sliderRange: ClosedRange<Double>
    private let sensitivity = [0, 25, 50, 75, 100]
    var body: some View {
        VStack(spacing: 8) {
            // Title Row
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            // Slider with Levels
            VStack(spacing: 4) {
                GeometryReader { geometry in
                    ZStack {
                        Slider(value: $sliderValue, in: sliderRange, step: (sliderRange.upperBound - sliderRange.lowerBound) / 4)
                            .accentColor(.blue)
                    }
                }
                .frame(height: 30)
                
                // Level labels (optional)
                HStack {
                    ForEach(0..<sensitivity.count) { index in
                        Text("\(sensitivity[index])%")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .frame(width: 250)
        .cornerRadius(10)
    }
}
