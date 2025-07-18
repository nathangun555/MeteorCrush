//
//  RocketFire.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 16/07/25.
//


import SpriteKit

struct RocketFire {
    let node: SKSpriteNode
    private var currentLevel = 0
    private let rocketSize: CGSize

    init(rocketSize: CGSize) {
        self.rocketSize = rocketSize

        // Prevent crash in Preview mode
        #if targetEnvironment(simulator)
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        let isPreview = false
        #endif

        if isPreview {
            node = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: 1))
            return
        }

        node = SKSpriteNode(imageNamed: "fire1")
        node.zPosition = 99
        node.size = CGSize(width: 40, height: 100)
        node.position = CGPoint(x: 0, y: -rocketSize.height / 1.2)
    }

    mutating func update(fuel: CGFloat) {
        guard fuel > 0 else {
            node.isHidden = true
            node.removeAllActions()
            return
        }

        node.isHidden = false

        var newLevel = 0
        var firePrefix = ""
        var fireSize = CGSize(width: 40, height: 100)
        var fireOffsetY: CGFloat = -rocketSize.height / 1.05

        switch fuel {
        case 75...100:
            newLevel = 1
            firePrefix = "fire1"
        case 30..<75:
            newLevel = 2
            firePrefix = "fire2"
        case 1..<30:
            newLevel = 3
            firePrefix = "fire3"
        default:
            break
        }

        if newLevel != currentLevel {
            currentLevel = newLevel
            node.removeAllActions()

            let textures = (1...9).map { SKTexture(imageNamed: "\(firePrefix).\($0)") }
            node.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.07)), withKey: "fireAnim")

            node.size = fireSize
            node.position = CGPoint(x: 0, y: fireOffsetY)
        }
    }
}
