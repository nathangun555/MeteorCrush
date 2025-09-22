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
    var joystick: Joystick!
    var sensitivity: CGFloat = UserDefaults.standard.double(forKey: "joystickSensitivity")
    var hud: HUD!
    private var tutorialLabel: SKLabelNode!
    private var tutorialBackground: SKSpriteNode!
    private var hand: SKSpriteNode!
    private var arrow: SKSpriteNode!
    
    var planets   = [SKSpriteNode]()
  //  var stars     = [SKSpriteNode]()
    var redStar     = [SKSpriteNode]()
    var greenStar     = [SKSpriteNode]()
    var blueStar     = [SKSpriteNode]()
    var fuels     = [SKSpriteNode]()
    var gate      = [SKSpriteNode]()
    var powerups  = [SKSpriteNode]()
    var fireNode: SKSpriteNode!
    var distance: Int = 0
    
    var upcomingGate: CGFloat = 0.0
    var futureGate: CGFloat = 0.0
    var gateColor: UIColor = .red
    
    var isPowerupSpawned: Bool = false
    var isShield: Bool = false
    var multiplier: Int = 1
    var isDoublePoint: Bool = false
    var multiplierTimer: CGFloat = 0
    var shieldTimer: CGFloat = 0
    var shieldEffect: SKSpriteNode?
    
    var onPause: (() -> Void)?

    // Track planet positioning for alternating pattern
    var planetIndex: Int = 0
    
    private var planetCount = 100
    private var starCount   = 100
    private var fuelCount   = 1
    private var gateCount   = 1
    
    var scrollSpeed: CGFloat = 3.0
    private var rocketY: CGFloat = 0
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        self.upcomingGate = self.size.height + CGFloat.random(in: 0...200)
        self.futureGate = self.upcomingGate + self.size.height + CGFloat.random(in: 100...200)
        
        let background = BackgroundNode(sceneSize: self.size) // misalnya ini adalah SKSpriteNode
        background.zPosition = -1 // pastikan ada di belakang semua elemen
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)

        //backgroundColor = .brown
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        meteorSpawner = FallingMeteorSpawner(scene: self)
        
        SoundManager.shared.playGameMusic()
        SoundManager.shared.playSFX(named: "rocketTakeOff", withExtension: "wav")
        setupHUD()
        setupRocket()
        setupJoystick()
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
                // background speed controller
                background.bgScrollSpeed += 10
                background.updateScrollingSpeed()
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
        
        let powerupAction = SKAction.run { [weak self] in
            guard let self = self, !self.isGameOver else { return }
            
            if(self.isShield) { self.shieldTimer -= 0.1; print("Shield time : \(self.shieldTimer)") }
            if(self.isDoublePoint) { self.multiplierTimer -= 0.1; print("Multiplier time : \(self.multiplierTimer)") }
            
            if(self.shieldTimer <= 0) { self.isShield = false
                self.shieldEffect?.removeFromParent()
                self.shieldEffect = nil}
            if(self.multiplierTimer <= 0) { self.isDoublePoint = false; self.multiplier = 1 }
        }
        
        let powerupWait = SKAction.wait(forDuration: 0.1)
        let powerupSequence = SKAction.sequence([powerupWait, powerupAction])
        run(SKAction.repeatForever(powerupSequence), withKey: "powerupTimer")
        
        // Spawn fuel every 5 seconds
        let fuelSpawnAction = SKAction.run { [weak self] in
            guard let self = self, !self.isGameOver else { return }
            FuelSpawner.spawnFuel(in: self, atY: self.size.height)
        }
        
        let fuelWait = SKAction.wait(forDuration: 5.0)
        let fuelSequence = SKAction.sequence([fuelWait, fuelSpawnAction])
        let fuelRepeatForever = SKAction.repeatForever(fuelSequence)
        run(fuelRepeatForever, withKey: "fuelSpawnTimer")
    }
    
    private func TutorialOverlay() {
        tutorialLabel = SKLabelNode(fontNamed: "Baloo2-ExtraBold")
        tutorialLabel.text = "Match stars with your rocket's color!"
        tutorialLabel.fontSize = 22
        tutorialLabel.fontColor = .white
        tutorialLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.65) // Sesuaikan posisi
        tutorialLabel.zPosition = 103
        addChild(tutorialLabel)
       
       // let tutorialImage = SKSpriteNode(imageNamed: "arrowTutorial")
        arrow = SKSpriteNode(imageNamed: "arrowTutorial")
        arrow.position = CGPoint(x: (scene?.size.width)! / 2, y: (scene?.size.height)! / 4)
        arrow.zPosition = 101
        arrow.setScale(0.35) // Sesuaikan skala gambar jika perlu
        addChild(arrow)

        if let handImage = UIImage(named: "hand.png") {
            let handTexture = SKTexture(image: handImage)
            hand = SKSpriteNode(texture: handTexture)
            hand.position = CGPoint(x: size.width / 3, y: size.height / 8) // Di bawah teks
            hand.zPosition = 102
            addChild(hand)
            hand.setScale(0.06)
            hand.alpha = 0.6

            // Animasi geser tangan
            let moveRight = SKAction.moveBy(x: 200, y: 0, duration: 0.7)
            let moveLeft = SKAction.moveBy(x: -200, y: 0, duration: 0.7)
            let moveSequence = SKAction.sequence([moveRight, moveLeft])
            let repeatAction = SKAction.repeatForever(moveSequence)
            hand.run(repeatAction)
        } else {
            print("Gambar tangan tidak ditemukan!")
        }
    }
    
    private func removeTutorialOverlay() {
   //    tutorialBackground.removeFromParent()
        arrow.removeFromParent()
        hand.removeFromParent()
        tutorialLabel.removeFromParent()
        
    }
    
    private func setupRocket() {
        let randomRocket = ["rocketRed", "rocketGreen", "rocketBlue"]
        let rocketPicker = randomRocket.randomElement()!
        rocket = SKSpriteNode(imageNamed: rocketPicker)
        rocket.size = CGSize(width: 100, height: 100)
        rocketY = size.height / 4
        rocket.position = CGPoint(x: size.width/2, y: rocketY)
        rocket.zPosition = 10
        if rocketPicker == "rocketRed" {
            rocket.color = .red
            hud.star.texture = SKTexture(imageNamed: "starRed")
        } else if rocketPicker == "rocketGreen" {
            rocket.color = .green
            hud.star.texture = SKTexture(imageNamed: "starGreen")
        } else {
            rocket.color = .blue
            hud.star.texture = SKTexture(imageNamed: "starBlue")
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
        joystick.sensitivity = sensitivity
        addChild(joystick)
    }
    
    private func setupHUD() {
        hud = HUD(size: size)
        hud.onPauseTapped = { [weak self] in
               self?.showPaused()
            SoundManager.shared.meteor?.pause()
            self?.meteorSpawner.stopSpawning()
           }
        addChild(hud)
    }
    
    public func spawnInitialObstacles() {
        var planetUnitRandom = 4
        var starUnit = planetUnitRandom * 2 - 1
        var counter = 0
        
        let startY: CGFloat = size.height * 0.8 // Mulai dari 80% tinggi layar
        let planetSpacing = size.height / CGFloat(planetUnitRandom)
        for i in 0..<planetUnitRandom {
            ObstacleSpawner.spawnPlanet(in: self, atY: startY + CGFloat(i) * planetSpacing, index: i)
        }
        let starSpacing = size.height / CGFloat(starUnit)
        // LOGIC STAR ROCKET DISINI
        let rocketColor = rocket.color
        var redStarUnit = 0
        var greenStarUnit = 0
        var blueStarUnit = 0

        if rocketColor == .red {
            redStarUnit = Int((Double(starUnit) * 0.75).rounded())
            let remaining = starUnit - redStarUnit
            if remaining > 0 {
                greenStarUnit = Int.random(in: 0...remaining)
                blueStarUnit = remaining - greenStarUnit
            }
        } else if rocketColor == .green {
            greenStarUnit = Int((Double(starUnit) * 0.75).rounded())
            let remaining = starUnit - greenStarUnit
           
            if remaining > 0 {
               redStarUnit = Int.random(in: 0...remaining)
               blueStarUnit = remaining - redStarUnit
            }
        } else {
            blueStarUnit = Int((Double(starUnit) * 0.75).rounded())
               let remaining = starUnit - blueStarUnit
               
               if remaining > 0 {
                   redStarUnit = Int.random(in: 0...remaining)
                   greenStarUnit = remaining - redStarUnit
               }
        }
        for i in 0..<redStarUnit     { ObstacleSpawner.spawnStar(in: self, atY: CGFloat.random(in: self.upcomingGate...self.futureGate)) }
        for i in 0..<greenStarUnit     { ObstacleSpawner.spawnGreenStar(in: self, atY: CGFloat.random(in: self.upcomingGate...self.futureGate)) }
        for i in 0..<blueStarUnit     { ObstacleSpawner.spawnBlueStar(in: self, atY: CGFloat.random(in: self.upcomingGate...self.futureGate)) }
//        for i in 0..<starUnit     { ObstacleSpawner.spawnStar(in: self, atY: startY + CGFloat(i) * starSpacing + 100) }
        let fuelSpacing = size.height / CGFloat(fuelCount)
        for i in 0..<fuelCount { FuelSpawner.spawnFuel(in: self, atY: startY + CGFloat(i) * fuelSpacing + 200) }
        let gateSpacing = size.height / CGFloat(gateCount)
        for i in 0..<gateCount { ObstacleSpawner.spawnGate(in: self, atY: startY + self.upcomingGate) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if let node = self.atPoint(location) as? SKSpriteNode, node.name == "settingsOverlay" {
            node.removeFromParent()
            self.isPaused = false
            return
        }
        // Hanya panggil joystick jika sentuhan BUKAN di settingsOverlay
        joystick.begin(at: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { joystick.move(to: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.end(rocket)
    }
    
    override func update(_ currentTime: TimeInterval) {
        planets.forEach { $0.position.y -= scrollSpeed }
        redStar.forEach   { $0.position.y -= scrollSpeed }
        greenStar.forEach   { $0.position.y -= scrollSpeed }
        blueStar.forEach   { $0.position.y -= scrollSpeed }
        fuels.forEach   { $0.position.y -= scrollSpeed }
        gate.forEach   { $0.position.y -= scrollSpeed }
        powerups.forEach { $0.position.y -= scrollSpeed }
        
        guard !isGameOver else {
            removeAction(forKey: "fuelTimer")
            return
        }
        joystick.updateRocket(rocket, fuel: &hud.fuel, rocketY: &rocketY)
        rocketFire.update(fuel: hud.fuel)
        
        hud.updateLabels()
        hud.updatePowerupState(in: self)
        ObstacleSpawner.recycleOffscreen(in: self, speed: scrollSpeed)
        PowerUpSpawner.recyclePowerup(in: self, speed: scrollSpeed)
        FuelSpawner.recycleFuel(in: self, speed: scrollSpeed)
        
        // Remove any colliding objects
        ObstacleSpawner.removeCollidingObjects(in: self)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        CollisionHandler.handle(contact, in: self, hud: hud)
    }
    
    func showPaused() {
           self.isPaused = true
           onPause?()
       }
}

