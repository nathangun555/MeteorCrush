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
    private var joystick: Joystick!
    private var hud: HUD!
    
    var planets   = [SKSpriteNode]()
    var stars     = [SKSpriteNode]()
    var fuels     = [SKSpriteNode]()
    var gate      = [SKSpriteNode]()
    var fireNode: SKSpriteNode!

    
    private var planetCount = Int.random(in: 1...3)
    private var starCount   = Int.random(in: 1...3)
    private var fuelCount   = Int.random(in: 1...3)
    private var gateCount   = 1

    private let scrollSpeed: CGFloat = 2.0
    private var rocketY: CGFloat = 0
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .brown
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        setupRocket()
        setupJoystick()
        setupHUD()
        spawnInitialObstacles()
    }

    private func setupRocket() {
        rocket = SKSpriteNode(imageNamed: "rocket")
        rocket.size = CGSize(width: 100, height: 100)
        rocketY = size.height / 4
        rocket.position = CGPoint(x: size.width/2, y: rocketY)
        rocket.zPosition = 10
        if let tex = rocket.texture {
            rocket.physicsBody = SKPhysicsBody(texture: tex, size: rocket.size)
            rocket.physicsBody?.categoryBitMask = PhysicsCategory.Rocket
            rocket.physicsBody?.contactTestBitMask = PhysicsCategory.Planet | PhysicsCategory.redStar | PhysicsCategory.blueStar | PhysicsCategory.greenStar | PhysicsCategory.Fuel
            rocket.physicsBody?.collisionBitMask = PhysicsCategory.None
            rocket.physicsBody?.affectedByGravity = false
        }
        
        fireNode = SKSpriteNode(imageNamed: "fire1")
        fireNode.size = CGSize(width: 40, height: 60)
        fireNode.position = CGPoint(x: 0, y: -rocket.size.height/1.25)
        fireNode.zPosition = 99
        rocket.addChild(fireNode)

        addChild(rocket)
    }
    
    func changeRocketColor(_ color: UIColor)    {
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
        for i in 0..<starCount     { ObstacleSpawner.spawnStar(in: self, atY: startY + CGFloat(i) * starSpacing + 100) }
        let fuelSpacing = size.height / CGFloat(fuelCount)
        for i in 0..<fuelCount     { ObstacleSpawner.spawnFuel(in: self, atY: startY + CGFloat(i) * fuelSpacing + 200)
        }
        let gateSpacing = size.height / CGFloat(gateCount)
        for i in 0..<gateCount     { ObstacleSpawner.spawnGate(in: self, atY: startY + CGFloat(i) * gateSpacing + 200)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { joystick.begin(at: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { joystick.move(to: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.end()
    }

    override func update(_ currentTime: TimeInterval) {
        planets.forEach { $0.position.y -= scrollSpeed }
        stars.forEach   { $0.position.y -= scrollSpeed }
        fuels.forEach   { $0.position.y -= scrollSpeed }
        gate.forEach   { $0.position.y -= scrollSpeed }

        guard !isGameOver else { return }
        joystick.updateRocket(rocket, fuel: &hud.fuel, rocketY: &rocketY) // bensinnya berkurang
        updateFireEffect()
        hud.updateLabels()
        ObstacleSpawner.recycleOffscreen(in: self, speed: scrollSpeed)
    }
    
    func updateFireEffect() {
        guard hud.fuel > 0 else {
            fireNode.isHidden = true
            return
        }

        fireNode.isHidden = false

        switch hud.fuel {
        case 75...100:
            fireNode.texture = SKTexture(imageNamed: "fire1")
        case 30..<75:
            fireNode.texture = SKTexture(imageNamed: "fire2")
        case 1..<30:
            fireNode.texture = SKTexture(imageNamed: "fire3")
        default:
            fireNode.isHidden = true
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        CollisionHandler.handle(contact, in: self, hud: hud)
    }
}
