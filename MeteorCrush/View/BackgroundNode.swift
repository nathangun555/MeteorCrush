//
//  BackgroundView.swift
//  MeteorCrush
//
//  Created by Vivi on 17/07/25.
//
import SpriteKit

class BackgroundNode: SKNode {
    let sceneSize: CGSize
    var bgScrollSpeed: CGFloat = 50.0
    
    private var totalBackgroundHeight: CGFloat = 0
    private var backgroundNodes: [SKSpriteNode] = []

    init(sceneSize: CGSize) {
        self.sceneSize = sceneSize
        super.init()
        setBackground()
    }

    required init?(coder aDecoder: NSCoder) {
        self.sceneSize = CGSize(width: 768, height: 1024) // default fallback
        super.init(coder: aDecoder)
        setBackground()
    }

    func setBackground() { // first layer
        // Remove existing backgrounds
        children.filter { $0.name == "scrollingBackground" }.forEach { $0.removeFromParent() }
        backgroundNodes.removeAll()
        
        let textureNames = [SKTexture(imageNamed: "bg1"), SKTexture(imageNamed: "bg2"), SKTexture(imageNamed: "bg3")]
        
        // Hitung tinggi total dari satu set background
        let singleSetHeight = textureNames.reduce(0) { $0 + $1.size().height }
        
        // Buat 3 set background untuk memastikan seamless loop
        var currentY: CGFloat = 0
        
        for setIndex in 0..<3 {
            for (textureIndex, texture) in textureNames.enumerated() {
                let bg = SKSpriteNode(texture: texture)
                bg.setScale(0.35)
                bg.position = CGPoint(x: 0, y: currentY)
                bg.zPosition = -5
                bg.name = "scrollingBackground"
                bg.userData = ["setIndex": setIndex, "textureIndex": textureIndex]
                currentY += bg.frame.size.height
                addChild(bg)
                backgroundNodes.append(bg)
            }
        }
        
        self.totalBackgroundHeight = singleSetHeight
    }

    func updateScrollingSpeed() {
        // Stop all existing actions
        backgroundNodes.forEach { $0.removeAllActions() }
        
        let bgMoveDuration = TimeInterval(totalBackgroundHeight / bgScrollSpeed)
        
        // Animate each background individually for infinite loop
        for bg in backgroundNodes {
            let initialY = 0
            
            // Move down continuously
            let moveDown = SKAction.moveBy(x: 0, y: -bgScrollSpeed, duration: 1.0)
            let moveForever = SKAction.repeatForever(moveDown)
            
            // Check and reset position when needed
            let checkPosition = SKAction.run {
                if bg.position.y < -bg.size.height {
                    // Reset to top position
                    bg.position.y += self.totalBackgroundHeight
                }
            }
            
            let checkForever = SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.wait(forDuration: 0.1),
                    checkPosition
                ])
            )
            
            // Run both actions
            bg.run(moveForever, withKey: "moveDown")
            bg.run(checkForever, withKey: "checkPosition")
        }
    }
    
    private func updateBackgroundPositions() {
        let deltaTime: CGFloat = 1.0/60.0
        let moveDistance = bgScrollSpeed * deltaTime
        
        for bg in backgroundNodes {
            // Move background down
            bg.position.y -= moveDistance
            
            // Reset position when background goes off screen
            if bg.position.y < -bg.size.height {
                bg.position.y += totalBackgroundHeight
            }
        }
    }
}
