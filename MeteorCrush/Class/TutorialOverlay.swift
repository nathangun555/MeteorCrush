//
//  TutorialOverlay.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 22/07/25.
//


import SpriteKit

class TutorialOverlay {
    private var tutorialBackground: SKSpriteNode!
    private var tutorialLabel: SKLabelNode!
    private var hand: SKSpriteNode!

    init(scene: SKScene) {
        tutorialBackground = SKSpriteNode(color: .gray, size: CGSize(width: scene.size.width * 2, height: scene.size.height / 1.5))
        tutorialBackground.alpha = 0.5
        tutorialBackground.zPosition = 100
        scene.addChild(tutorialBackground)

        tutorialLabel = SKLabelNode(text: "Swipe to move the rocket!")
        tutorialLabel.fontColor = .white
        tutorialLabel.fontSize = 30
        tutorialLabel.fontName = "Arial-Bold"
        tutorialLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 4)
        tutorialLabel.zPosition = 101
        scene.addChild(tutorialLabel)

        if let handImage = UIImage(named: "hand") {
            let handTexture = SKTexture(image: handImage)
            let handSprite = SKSpriteNode(texture: handTexture)
            handSprite.position = CGPoint(x: scene.size.width / 3, y: scene.size.height / 8)
            handSprite.zPosition = 999
            scene.addChild(handSprite)
            handSprite.setScale(0.07)
            handSprite.alpha = 0.7

            let moveRight = SKAction.moveBy(x: 200, y: 0, duration: 0.7)
            let moveLeft = SKAction.moveBy(x: -200, y: 0, duration: 0.7)
            let moveSequence = SKAction.sequence([moveRight, moveLeft])
            let repeatAction = SKAction.repeatForever(moveSequence)
            handSprite.run(repeatAction)
            self.hand = handSprite
        } else {
            print("Error: hand image not found!")
        }
    }

    func removeOverlay() {
        tutorialBackground.removeFromParent()
        tutorialLabel.removeFromParent()
        hand?.removeFromParent()
    }
}
