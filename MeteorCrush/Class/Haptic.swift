//
//  Haptic.swift
//  MeteorCrush
//
//  Created by Vivi on 22/07/25.
//
import SwiftUI

func vibrateWithDelay(_ hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle,
                      count: Int = 5,
                      delayInterval: Double = 0.1) {
    let checker = UserDefaults.standard.bool(forKey: "hapticManager")
    if checker {
        let impactGenerator = UIImpactFeedbackGenerator(style: hapticStyle)
        impactGenerator.prepare()
        
        for i in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * delayInterval)) {
                impactGenerator.impactOccurred()
                impactGenerator.prepare() // Re-prepare untuk performance yang lebih baik
                print("pengulangan ke ", i)
            }
        }
    }
}

func hapticToggle(){
    let checker = UserDefaults.standard.bool(forKey: "hapticManager")
    if checker {
        let currentValue = UserDefaults.standard.bool(forKey: "hapticManager")
        let newValue = !currentValue
        UserDefaults.standard.set(newValue, forKey: "hapticManager")
    }
}


