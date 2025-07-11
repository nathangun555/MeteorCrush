////
////  galaxyGameView.swift
////  MeteorCrush
////
////  Created by Vivi on 10/07/25.
////
//
//import UIKit
//import SpriteKit
//import GameplayKit
//
//// Physics categories for collision detection
//struct PhysicsCategory {
//    static let None:   UInt32 = 0
//    static let Rocket: UInt32 = 0x1 << 0
//    static let Planet: UInt32 = 0x1 << 1
//    static let Star:   UInt32 = 0x1 << 2
//    static let Fuel:   UInt32 = 0x1 << 3
//}
//
//class GameViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let skView = self.view as? SKView {
//            let scene = GameScene(size: skView.bounds.size)
//            scene.scaleMode = .resizeFill
//            skView.presentScene(scene)
//            skView.ignoresSiblingOrder = true
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//        }
//    }
//    override var prefersStatusBarHidden: Bool { return true }
//}
//
//class GameScene: SKScene, SKPhysicsContactDelegate {
//    private var rocket: SKSpriteNode!
//    private var joystickBase: SKShapeNode!
//    private var joystickKnob: SKShapeNode!
//    private var joystickActive = false
//
//    private var fuel: CGFloat = 50
//    private var fuelLabel: SKLabelNode!
//    private var score: Int = 0
//    private var scoreLabel: SKLabelNode!
//
//    private var planets = [SKSpriteNode]()
//    private var stars   = [SKSpriteNode]()
//    private var fuels   = [SKSpriteNode]()
//
//    private let planetCount = Int.random(in: 1...3)
//    private let starCount   = 5
//    private let fuelCount   = 3
//
//    private let scrollSpeed: CGFloat = 2.0
//    private var rocketY: CGFloat = 0
//    private let maxTilt: CGFloat = 0.2
//
//    override func didMove(to view: SKView) {
//        backgroundColor = .black
//        physicsWorld.gravity = .zero
//        physicsWorld.contactDelegate = self
//
//        setupRocket()
//        setupJoystick()
//        setupLabels()
//        spawnInitialObstacles()
//    }
//
//    // MARK: - Setup Rocket & Labels
//    private func setupRocket() {
//        rocket = SKSpriteNode(imageNamed: "rocket")
//        rocket.size = CGSize(width: 100, height: 150)
//        rocketY = size.height / 4
//        rocket.position = CGPoint(x: size.width/2, y: rocketY)
//        rocket.zPosition = 10
//        guard let tex = rocket.texture else { fatalError("Rocket asset missing") }
//        rocket.physicsBody = SKPhysicsBody(texture: tex, size: rocket.size)
//        rocket.physicsBody?.categoryBitMask = PhysicsCategory.Rocket
//        rocket.physicsBody?.contactTestBitMask = PhysicsCategory.Planet | PhysicsCategory.Star | PhysicsCategory.Fuel
//        rocket.physicsBody?.collisionBitMask = PhysicsCategory.None
//        rocket.physicsBody?.affectedByGravity = false
//        addChild(rocket)
//    }
//
//    private func setupLabels() {
//        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
//        scoreLabel.fontSize = 24
//        scoreLabel.fontColor = .white
//        scoreLabel.position = CGPoint(x: size.width-80, y: size.height-50)
//        scoreLabel.zPosition = 20
//        scoreLabel.text = "Score: 0"
//        addChild(scoreLabel)
//
//        fuelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
//        fuelLabel.fontSize = 24
//        fuelLabel.fontColor = .yellow
//        fuelLabel.position = CGPoint(x: 100, y: size.height-50)
//        fuelLabel.zPosition = 20
//        fuelLabel.text = "Fuel: \(Int(fuel))"
//        addChild(fuelLabel)
//    }
//
//    // MARK: - Setup Joystick
//    private func setupJoystick() {
//        // Base circle
//        joystickBase = SKShapeNode(circleOfRadius: 60)
//        joystickBase.fillColor = .gray
//        joystickBase.alpha = 0.4
//        joystickBase.zPosition = 100
//        joystickBase.isHidden = true
//        addChild(joystickBase)
//        // Knob circle
//        joystickKnob = SKShapeNode(circleOfRadius: 30)
//        joystickKnob.fillColor = .white
//        joystickKnob.alpha = 0.8
//        joystickKnob.zPosition = 101
//        joystickKnob.isHidden = true
//        addChild(joystickKnob)
//    }
//
//    // MARK: - Obstacle Spawning
//    private func spawnInitialObstacles() {
//        let startY = size.height + 50
//        let planetSpacing = size.height / CGFloat(planetCount)
//        for i in 0..<planetCount {
//            spawnPlanet(atY: startY + CGFloat(i) * planetSpacing)
//        }
//        let starSpacing = size.height / CGFloat(starCount)
//        for i in 0..<starCount {
//            spawnStar(atY: startY + CGFloat(i) * starSpacing + 100)
//        }
//        let fuelSpacing = size.height / CGFloat(fuelCount)
//        for i in 0..<fuelCount {
//            spawnFuel(atY: startY + CGFloat(i) * fuelSpacing + 200)
//        }
//    }
//
//    private func spawnPlanet(atY y: CGFloat) {
//        let planet = SKSpriteNode(imageNamed: "planet")
//        planet.size = CGSize(width: 100, height: 100)
//        let halfW = planet.size.width/2
//        planet.position = CGPoint(x: CGFloat.random(in: halfW...(size.width-halfW)), y: y)
//        planet.zPosition = 5
//        planet.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
//        planet.physicsBody?.categoryBitMask = PhysicsCategory.Planet
//        planet.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
//        planet.physicsBody?.collisionBitMask = PhysicsCategory.None
//        planet.physicsBody?.affectedByGravity = false
//        addChild(planet)
//        planets.append(planet)
//    }
//
//    private func spawnStar(atY y: CGFloat) {
//        let star = SKSpriteNode(imageNamed: "star")
//        star.size = CGSize(width: 50, height: 50)
//        let halfW = star.size.width/2
//        star.position = CGPoint(x: CGFloat.random(in: halfW...(size.width-halfW)), y: y)
//        star.zPosition = 5
//        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
//        star.physicsBody?.categoryBitMask = PhysicsCategory.Star
//        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
//        star.physicsBody?.collisionBitMask = PhysicsCategory.None
//        star.physicsBody?.affectedByGravity = false
//        addChild(star)
//        stars.append(star)
//    }
//
//    private func spawnFuel(atY y: CGFloat) {
//        let pickup = SKSpriteNode(imageNamed: "fuel")
//        pickup.size = CGSize(width: 50, height: 50)
//        let halfW = pickup.size.width/2
//        pickup.position = CGPoint(x: CGFloat.random(in: halfW...(size.width-halfW)), y: y)
//        pickup.zPosition = 5
//        pickup.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
//        pickup.physicsBody?.categoryBitMask = PhysicsCategory.Fuel
//        pickup.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
//        pickup.physicsBody?.collisionBitMask = PhysicsCategory.None
//        pickup.physicsBody?.affectedByGravity = false
//        addChild(pickup)
//        fuels.append(pickup)
//    }
//
//    // MARK: - Touch Handling for Joystick
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let t = touches.first else { return }
//        let loc = t.location(in: self)
//        joystickBase.position = loc
//        joystickKnob.position = loc
//        joystickBase.isHidden = false
//        joystickKnob.isHidden = false
//        joystickActive = true
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard joystickActive, let t = touches.first else { return }
//        let loc = t.location(in: self)
//        let basePos = joystickBase.position
//        let dx = loc.x - basePos.x
//        let dy = loc.y - basePos.y
//        let dist = hypot(dx, dy)
//        let maxDist: CGFloat = 60
//        if dist <= maxDist {
//            joystickKnob.position = loc
//        } else {
//            let angle = atan2(dy, dx)
//            joystickKnob.position = CGPoint(
//                x: basePos.x + cos(angle)*maxDist,
//                y: basePos.y + sin(angle)*maxDist
//            )
//        }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        joystickActive = false
//        let moveBack = SKAction.move(to: joystickBase.position, duration: 0.2)
//        moveBack.timingMode = .easeOut
//        joystickKnob.run(moveBack) {
//            self.joystickBase.isHidden = true
//            self.joystickKnob.isHidden = true
//        }
//    }
//
//    // MARK: - Game Loop
//    override func update(_ currentTime: TimeInterval) {
//        // Move obstacles downward
//        planets.forEach { $0.position.y -= scrollSpeed }
//        stars.forEach   { $0.position.y -= scrollSpeed }
//        fuels.forEach   { $0.position.y -= scrollSpeed }
//        
//        // Move rocket based on joystick
//        if joystickActive {
//            let dx = joystickKnob.position.x - joystickBase.position.x
//            let norm = dx / 60
//            let speed: CGFloat = 5
//            var newX = rocket.position.x + norm*speed
//            let halfW = rocket.size.width/2
//            newX = max(halfW, min(size.width-halfW, newX))
//            rocket.position = CGPoint(x: newX, y: rocketY)
//            rocket.zRotation = -norm * 0.3
//            // Consume fuel
//            fuel -= abs(norm) * 0.2
//            fuel = max(fuel, 0)
//            fuelLabel.text = "Fuel: \(Int(fuel))"
//        }
//
//        // Loop obstacles offscreen
//        let offscreenY: CGFloat = -100
//        let topY: CGFloat       = size.height + 100
//        for p in planets {
//            if p.position.y < offscreenY {
//                p.position.y = topY + CGFloat.random(in: 0...200)
//                p.position.x = CGFloat.random(in: p.size.width/2...(size.width-p.size.width/2))
//            }
//        }
//        for s in stars {
//            if s.position.y < offscreenY {
//                s.position.y = topY + CGFloat.random(in: 0...200)
//                s.position.x = CGFloat.random(in: s.size.width/2...(size.width-s.size.width/2))
//            }
//        }
//        for f in fuels {
//            if f.position.y < offscreenY {
//                f.position.y = topY + CGFloat.random(in: 0...200)
//                f.position.x = CGFloat.random(in: f.size.width/2...(size.width-f.size.width/2))
//            }
//        }
//    }
//
//    // MARK: - Collision Detection
//    func didBegin(_ contact: SKPhysicsContact) {
//        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Rocket ? contact.bodyB : contact.bodyA
//        switch other.categoryBitMask {
//        case PhysicsCategory.Planet:
//            rocket.removeFromParent()
//            let gameOver = SKLabelNode(fontNamed: "AvenirNext-Bold")
//            gameOver.text = "Game Over"
//            gameOver.fontSize = 48
//            gameOver.position = CGPoint(x: size.width/2, y: size.height/2)
//            addChild(gameOver)
//        case PhysicsCategory.Star:
//            score += 5
//            scoreLabel.text = "Score: \(score)"
//            other.node?.removeFromParent()
//        case PhysicsCategory.Fuel:
//            fuel = min(fuel+20, 100)
//            fuelLabel.text = "Fuel: \(Int(fuel))"
//            other.node?.removeFromParent()
//        default: break
//        }
//    }
//}
