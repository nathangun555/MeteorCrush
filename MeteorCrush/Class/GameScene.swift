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
    
    private let planetCount = Int.random(in: 1...3)
    private let starCount   = 5
    private let fuelCount   = 3
    private let scrollSpeed: CGFloat = 2.0
    private var rocketY: CGFloat = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        setupRocket()
        setupJoystick()
        setupHUD()
        spawnInitialObstacles()
    }

    private func setupRocket() {
        rocket = SKSpriteNode(imageNamed: "rocket")
        rocket.size = CGSize(width: 100, height: 150)
        rocketY = size.height / 4
        rocket.position = CGPoint(x: size.width/2, y: rocketY)
        rocket.zPosition = 10
        if let tex = rocket.texture {
            rocket.physicsBody = SKPhysicsBody(texture: tex, size: rocket.size)
            rocket.physicsBody?.categoryBitMask = PhysicsCategory.Rocket
            rocket.physicsBody?.contactTestBitMask = PhysicsCategory.Planet | PhysicsCategory.Star | PhysicsCategory.Fuel
            rocket.physicsBody?.collisionBitMask = PhysicsCategory.None
            rocket.physicsBody?.affectedByGravity = false
        }
        addChild(rocket)
    }

    private func setupJoystick() {
        joystick = Joystick()
        addChild(joystick)
    }

    private func setupHUD() {
        hud = HUD(size: size)
        addChild(hud)
    }

    private func spawnInitialObstacles() {
        let startY = size.height + 50
        let planetSpacing = size.height / CGFloat(planetCount)
        for i in 0..<planetCount {
                let p = ObstacleSpawner.spawnPlanet(in: self,
                                                    atY: startY + CGFloat(i) * planetSpacing)
                addChild(p)
                planets.append(p)
            }
        let starSpacing = size.height / CGFloat(starCount)
        for i in 0..<starCount     { ObstacleSpawner.spawnStar(in: self, atY: startY + CGFloat(i) * starSpacing + 100) }
        let fuelSpacing = size.height / CGFloat(fuelCount)
        for i in 0..<fuelCount     { ObstacleSpawner.spawnFuel(in: self, atY: startY + CGFloat(i) * fuelSpacing + 200)
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
        joystick.updateRocket(rocket, fuel: &hud.fuel, rocketY: &rocketY) // bensinnya berkurang
        hud.updateLabels()
        ObstacleSpawner.recycleOffscreen(in: self, speed: scrollSpeed)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        CollisionHandler.handle(contact, in: self, hud: hud)
    }
}
