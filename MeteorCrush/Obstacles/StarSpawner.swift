//
//  StarSpawner.swift
//  MeteorCrush
//
//  Created by Ammar Alifian Fahdan on 25/07/25.
//

import Foundation
import SpriteKit

class StarSpawner {
    static func handleSpawn(color: UIColor, in scene: GameScene, atY: CGFloat) -> Void {
        var colorStr = String(describing: color)
        switch color {
        case .red:
            ObstacleSpawner.spawnStar(in: scene, atY: atY)
        case .blue:
            ObstacleSpawner.spawnBlueStar(in: scene, atY: atY)
        case .green:
            ObstacleSpawner.spawnGreenStar(in: scene, atY: atY)
        default:
            print("Color invalid!! Invalid color : \(colorStr)")
        }
        
        
        
//        print("Summoned! Color : \(colorStr)")
    }
    
    static func colorFromCode(_ color: UIColor) -> String {
        let colorString: String
        switch color {
            case .red:
            colorString = "Red"
        case .blue:
            colorString = "Blue"
        case .green:
            colorString = "Green"
        default:
            fatalError("Unknown color!")
        }
        
        return colorString
    }
    
    static func spawnStar(in scene: GameScene) {
        
//        if(scene.starLimit >= scene.redStar.count + scene.greenStar.count + scene.blueStar.count){
            let preferredColor = scene.gateColor
            let possColor: [UIColor] = [.red, .green, .blue]
            if(CGFloat.random(in: 0...1) < 0.6) {
                handleSpawn(color: preferredColor, in: scene, atY: CGFloat.random(in: scene.upcomingGate...scene.futureGate))
                print("Summoned prefered. Color : \(colorFromCode(preferredColor))")
            }else{
                let summonedColor = possColor.randomElement()!
                handleSpawn(color: summonedColor, in: scene, atY: CGFloat.random(in: scene.upcomingGate...scene.futureGate))
                print("Summoned random. Color : \(colorFromCode(summonedColor))")
            }
//        }
    }
    
    static func removeStar(in scene: GameScene){
        let offscreenY: CGFloat = -100
        
        for star in scene.redStar.reversed() {
            if star.position.y < offscreenY {
                star.removeFromParent()
                scene.redStar.removeAll { $0 === star }
            }
        }
        
        for star in scene.blueStar.reversed() {
            if star.position.y < offscreenY {
                star.removeFromParent()
                scene.blueStar.removeAll { $0 === star }
            }
        }
        
        for star in scene.greenStar.reversed() {
            if star.position.y < offscreenY {
                star.removeFromParent()
                scene.greenStar.removeAll { $0 === star }
            }
        }
    }
}
