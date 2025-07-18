//
//  BackgroundView.swift
//  MeteorCrush
//
//  Created by Vivi on 17/07/25.
//
import SpriteKit

class BackgroundNode: SKNode {
    let sceneSize: CGSize
    var scrollSpeed: CGFloat = 50.0
    private var totalBackgroundHeight: CGFloat = 0
    private var backgroundNodes: [SKSpriteNode] = []

    init(sceneSize: CGSize) {
        self.sceneSize = sceneSize
        super.init()
        setBackground()
        setupStars()
    }

    required init?(coder aDecoder: NSCoder) {
        self.sceneSize = CGSize(width: 768, height: 1024) // default fallback
        super.init(coder: aDecoder)
        setBackground()
        setupStars()
      //  setupClouds()
    }

    func setBackground() {
        // Remove existing backgrounds
        children.filter { $0.name == "scrollingBackground" }.forEach { $0.removeFromParent() }
        backgroundNodes.removeAll()
        
        let textureNames = [SKTexture(imageNamed: "bg1"), SKTexture(imageNamed: "bg3"), SKTexture(imageNamed: "bg3")]
        
        // Hitung tinggi total dari satu set background
        let singleSetHeight = textureNames.reduce(0) { $0 + $1.size().height }
        
        // Buat 3 set background untuk memastikan seamless loop
        var currentY: CGFloat = 0
        
        for setIndex in 0..<3 {
            for (textureIndex, texture) in textureNames.enumerated() {
                let bg = SKSpriteNode(texture: texture)
                bg.size = CGSize(width: sceneSize.width, height: texture.size().height)
                bg.position = CGPoint(x: 0, y: currentY)
                bg.zPosition = -1
                bg.name = "scrollingBackground"
                bg.userData = ["setIndex": setIndex, "textureIndex": textureIndex]
                
                currentY += texture.size().height
                addChild(bg)
                backgroundNodes.append(bg)
            }
        }
        
        self.totalBackgroundHeight = singleSetHeight
        
        print("Single set height: \(singleSetHeight)")
        print("Total background nodes: \(backgroundNodes.count)")
    }

    func updateScrollingSpeed() {
        // Stop all existing actions
        backgroundNodes.forEach { $0.removeAllActions() }
        
        let moveDuration = TimeInterval(totalBackgroundHeight / scrollSpeed)
        
        // Animate each background individually for infinite loop
        for bg in backgroundNodes {
            let initialY = bg.position.y
            
            // Move down continuously
            let moveDown = SKAction.moveBy(x: 0, y: -scrollSpeed, duration: 1.0)
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
        let moveDistance = scrollSpeed * deltaTime
        
        for bg in backgroundNodes {
            // Move background down
            bg.position.y -= moveDistance
            
            // Reset position when background goes off screen
            if bg.position.y < -bg.size.height {
                bg.position.y += totalBackgroundHeight
            }
        }
    }


    private func setupStars() {
        var stars: [SKShapeNode] = []

        for _ in 0..<100 {
            let radius = CGFloat.random(in: 4.0...6.5)
            let star = SKShapeNode(circleOfRadius: radius)
            star.fillColor = .white
            star.strokeColor = .white
            star.lineWidth = 1.0
         //   star.glowWidth = CGFloat.random(in: 1.0...2.0)
            star.alpha = CGFloat.random(in: 0.15...0.4)
            star.zPosition = -9

            let startX = CGFloat.random(in: -1000.0...1000.0)
            let startY = CGFloat.random(in: -1000.0...1000.0)
            star.position = CGPoint(x: startX, y: startY)

            stars.append(star)
            addChild(star)
        }

        for star in stars {
            // Gerakan ke bawah dan reset ke atas
            let moveDistance = CGFloat.random(in: 60...120)
            let moveDuration = TimeInterval(CGFloat.random(in: 6.0...10.0))
            let moveDown = SKAction.moveBy(x: 0, y: -moveDistance, duration: moveDuration)
            let reset = SKAction.moveBy(x: 0, y: moveDistance, duration: 0)
            let loop = SKAction.sequence([moveDown, reset])
            let forever = SKAction.repeatForever(loop)
            
            // Delay random supaya tidak sinkron
            let movementDelay = SKAction.wait(forDuration: TimeInterval.random(in: 0...3.0))
            let movementSequence = SKAction.sequence([movementDelay, forever])
            star.run(movementSequence)

            // Efek kelap-kelip dengan delay acak
            let baseAlpha = star.alpha
            let fadeOut = SKAction.fadeAlpha(to: baseAlpha * 0.5, duration: Double.random(in: 1.5...3.0))
            let fadeIn = SKAction.fadeAlpha(to: baseAlpha, duration: Double.random(in: 1.5...3.0))
            let twinkle = SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn]))
            let twinkleDelay = SKAction.wait(forDuration: TimeInterval.random(in: 0...2.0))
            let twinkleSequence = SKAction.sequence([twinkleDelay, twinkle])
            star.run(twinkleSequence)
        }
    }
}
