//
//  SFX.swift
//  MeteorCrush
//
//  Created by Vivi on 22/07/25.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var musicPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?
    private var collectStar: AVAudioPlayer?
    
    var playSound = true
    func playSFX(named fileName: String, withExtension ext: String = "mp3") {
        self.playSound = UserDefaults.standard.bool(forKey: "musicManager")
        if playSound {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
                print("❌ Sound file \(fileName).\(ext) not found.")
                return
            }
            do {
                if fileName == "collectStar"{
                    collectStar = try AVAudioPlayer(contentsOf: url)
                    collectStar?.prepareToPlay()
                    collectStar?.play()
                } else {
                    sfxPlayer = try AVAudioPlayer(contentsOf: url)
                    sfxPlayer?.prepareToPlay()
                    sfxPlayer?.play()
                }
            } catch {
                print("❌ Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    func playGameMusic() {
        guard let url = Bundle.main.url(forResource: "starGame", withExtension: "wav") else {
            print("❌ Sound file \("starGame").\("wav") not found.")
            return
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.volume = 0.3
            musicPlayer?.numberOfLoops = -1 // 🔁 Loop tanpa batas
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        } catch {
            print("❌ Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playLobbyMusic() {
        guard let url = Bundle.main.url(forResource: "lobbyMusic", withExtension: "wav") else {
            print("❌ Sound file lobbyMusic.wav not found.")
            return
        }
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.volume = 0.3
            musicPlayer?.numberOfLoops = -1 // 🔁 Loop tanpa batas
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
            print("🎵 Lobby music playing in loop.")
        } catch {
            print("❌ Error playing sound: \(error.localizedDescription)")
        }
    }

    func stopAllSounds() {
        musicPlayer?.stop()
        sfxPlayer?.stop()
        musicPlayer = nil
        sfxPlayer = nil
    }
    
}
