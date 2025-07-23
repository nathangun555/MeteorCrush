//
//  SFX.swift
//  MeteorCrush
//
//  Created by Vivi on 22/07/25.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    var playSound = true
    func playSFX(named fileName: String, withExtension ext: String = "mp3") {
        self.playSound = UserDefaults.standard.bool(forKey: "musicManager")
        if playSound {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
                print("❌ Sound file \(fileName).\(ext) not found.")
                return
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("❌ Error playing sound: \(error.localizedDescription)")
            }
        }
    }
}
