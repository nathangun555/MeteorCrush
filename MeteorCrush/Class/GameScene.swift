//
//  GameScene.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var rocket: SKSpriteNode!
    var rocketFire: RocketFire!
    var meteorSpawner: FallingMeteorSpawner!
    private var joystick: Joystick!
    private var hud: HUD!
    private var tutorialLabel: SKLabelNode!
    private var tutorialBackground: SKSpriteNode!
    private var hand: SKSpriteNode!
    
    var planets   = [SKSpriteNode]()
    var stars     = [SKSpriteNode]()
    var fuels     = [SKSpriteNode]()
    var gate      = [SKSpriteNode]()
    var distance: Int = 0
    
    private var planetCount = Int.random(in: 1...3)
    private var starCount   = Int.random(in: 1...3)
    private var fuelCount   = Int.random(in: 1...3)
    private var gateCount   = 1
    
    var scrollSpeed: CGFloat = 3.0
    private var rocketY: CGFloat = 0
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .purple
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        meteorSpawner = FallingMeteorSpawner(scene: self)
        
        setupRocket()
        setupJoystick()
        setupHUD()
        spawnInitialObstacles()
        
        
        TutorialOverlay()
        
        // Set up the timer to remove tutorial after 5 seconds
        run(SKAction.wait(forDuration: 5.0)) {
            self.removeTutorialOverlay()
        }
        
        // Consume fuel, manage scroll speed, and check for game over
        let consume = SKAction.run { [weak self] in
            guard let self = self, !self.isGameOver else { return }
            self.hud.fuel -= 1
            self.distance += 1
//            print(self.distance)
            if(self.distance % 5*5 == 0){
                self.scrollSpeed += 0.1
//                print("Increasing speed to \(self.scrollSpeed)")
            }
            self.hud.updateLabels()
            if self.hud.fuel <= 0 {
                NotificationCenter.default.post(
                    name: Notification.Name("GameOver"),
                    object: hud.score
                )
                self.removeAction(forKey: "fuelTimer")
                isGameOver = true
                isPaused = true
            }
        }
        
        let wait = SKAction.wait(forDuration: 0.2)
        let sequence = SKAction.sequence([wait, consume])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: "fuelTimer")
    }
    
    private func TutorialOverlay() {
        tutorialBackground = SKSpriteNode(color: .gray, size: CGSize(width: size.width * 2, height: size.height))
        tutorialBackground.alpha = 0.5
        tutorialBackground.zPosition = 100
        addChild(tutorialBackground)
        
        // Tutorial label
        tutorialLabel = SKLabelNode(text: "Swipe to move the rocket!")
        
        
        tutorialLabel.fontColor = .white
        tutorialLabel.fontSize = 40
        tutorialLabel.position = CGPoint(x: size.width/2, y: size.height/4)
        tutorialLabel.zPosition = 101
        addChild(tutorialLabel)
        
        // Menggunakan SF Symbol hand.draw.fill
        let handImage = UIImage(systemName: "hand.draw.fill")!
      //  handImage = handImage.withTintColor(.white)
        let handTexture = SKTexture(image: handImage)
        
        // Membuat sprite dengan texture dari SF Symbol
        hand = SKSpriteNode(texture: handTexture)
        hand.position = CGPoint(x: size.width / 3, y: size.height / 8) // Di bawah teks
        hand.zPosition = 102
        addChild(hand)
        
        hand.setScale(5.0)
            
        // Animasi geser tangan
        let moveRight = SKAction.moveBy(x: 200, y: 0, duration: 0.7)
        let moveLeft = SKAction.moveBy(x: -200, y: 0, duration: 0.7)
        let moveSequence = SKAction.sequence([moveRight, moveLeft])
        let repeatAction = SKAction.repeatForever(moveSequence)
        hand.run(repeatAction)
    }
    
    private func removeTutorialOverlay() {
        tutorialBackground.removeFromParent()
        tutorialLabel.removeFromParent()
        hand.removeFromParent()
        
    }
    
    private func setupRocket() {
        let randomRocket = ["rocketPink", "rocketGreen", "rocketBlue"]
        let rocketPicker = randomRocket.randomElement()!
        rocket = SKSpriteNode(imageNamed: rocketPicker)
        rocket.size = CGSize(width: 100, height: 100)
        rocketY = size.height / 4
        rocket.position = CGPoint(x: size.width/2, y: rocketY)
        rocket.zPosition = 10
        
        // Set warna roket
        if rocketPicker == "rocketRed" {
            rocket.color = .red
        } else if rocketPicker == "rocketGreen" {
            rocket.color = .green
        } else {
            rocket.color = .blue
        }
        
        let collisionBoxSize = CGSize(width: 35, height: 80)
        let roundedRect = CGRect(origin: CGPoint(x: -collisionBoxSize.width/2, y: -collisionBoxSize.height/2), size: collisionBoxSize)
        
        let collisionBox = SKShapeNode(rect: roundedRect, cornerRadius: 8)
        collisionBox.fillColor = .red
        collisionBox.alpha = 1
        collisionBox.zPosition = -1
        collisionBox.position = CGPoint(x: 0, y: 0)
        
        collisionBox.physicsBody = SKPhysicsBody(rectangleOf: collisionBoxSize)
        collisionBox.physicsBody?.categoryBitMask = PhysicsCategory.Rocket
        collisionBox.physicsBody?.contactTestBitMask = PhysicsCategory.Planet | PhysicsCategory.redStar | PhysicsCategory.blueStar | PhysicsCategory.greenStar | PhysicsCategory.Fuel | PhysicsCategory.Meteor
        collisionBox.physicsBody?.collisionBitMask = PhysicsCategory.None
        collisionBox.physicsBody?.affectedByGravity = false
        collisionBox.physicsBody?.isDynamic = true
        
        rocket.physicsBody = nil
        rocket.addChild(collisionBox)
        rocketFire = RocketFire(rocketSize: rocket.size)
        rocket.addChild(rocketFire.node)
        addChild(rocket)
    }
    
    func changeRocketColor(_ color: UIColor) {
        rocket.color = color
        rocket.colorBlendFactor = 1  // 1.0 = full tint
    }
    
    private func setupJoystick() {
        joystick = Joystick()
        addChild(joystick)
    }
    
    private func setupHUD() {
        hud = HUD(size: size)
        addChild(hud)
    }
    
    public func spawnInitialObstacles() {
        let startY: CGFloat = size.height * 0.8 // Mulai dari 80% tinggi layar
        let planetSpacing = size.height / CGFloat(planetCount)
        for i in 0..<planetCount {
            ObstacleSpawner.spawnPlanet(in: self, atY: startY + CGFloat(i) * planetSpacing)
        }
        let starSpacing = size.height / CGFloat(starCount)
        for i in 0..<starCount { ObstacleSpawner.spawnStar(in: self, atY: startY + CGFloat(i) * starSpacing + 100) }
        let fuelSpacing = size.height / CGFloat(fuelCount)
        for i in 0..<fuelCount { ObstacleSpawner.spawnFuel(in: self, atY: startY + CGFloat(i) * fuelSpacing + 200) }
        let gateSpacing = size.height / CGFloat(gateCount)
        for i in 0..<gateCount { ObstacleSpawner.spawnGate(in: self, atY: startY + CGFloat(i) * gateSpacing + 200) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { joystick.begin(at: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { joystick.move(to: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.end(rocket)
    }
    
    override func update(_ currentTime: TimeInterval) {
        planets.forEach { $0.position.y -= scrollSpeed }
        stars.forEach   { $0.position.y -= scrollSpeed }
        fuels.forEach   { $0.position.y -= scrollSpeed }
        gate.forEach   { $0.position.y -= scrollSpeed }
        
        guard !isGameOver else {
            removeAction(forKey: "fuelTimer")
            return
        }
        joystick.updateRocket(rocket, fuel: &hud.fuel, rocketY: &rocketY)
        rocketFire.update(fuel: hud.fuel)
        
        hud.updateLabels()
        ObstacleSpawner.recycleOffscreen(in: self, speed: scrollSpeed)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        CollisionHandler.handle(contact, in: self, hud: hud)
    }
}

