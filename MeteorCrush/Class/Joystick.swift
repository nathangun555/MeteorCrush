//
//  Joystick.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

class Joystick: SKNode {
    private let base = SKShapeNode(circleOfRadius: 60)
    private let knob = SKShapeNode(circleOfRadius: 30)
    private(set) var isActive = false
    private var basePosition = CGPoint.zero
    
    override init() {
        super.init()
        base.fillColor = .clear
        base.alpha = 0.0
        base.zPosition = 100
        base.isHidden = false  // ← jangan hidden, biar tetap interaktif

        knob.fillColor = .clear
        knob.alpha = 0.0
        knob.zPosition = 101
        knob.isHidden = false
 
        
        addChild(base); addChild(knob)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func begin(at position: CGPoint) {
        base.position = position; knob.position = position
        base.isHidden = false; knob.isHidden = false; isActive = true
        basePosition = position
    }

    func move(to position: CGPoint) {
        guard isActive else { return }
        let dx = position.x - basePosition.x, dy = position.y - basePosition.y
        let dist = hypot(dx, dy), maxDist: CGFloat = 60
        if dist <= maxDist {
            knob.position = position
        } else {
            let angle = atan2(dy, dx)
            knob.position = CGPoint(x: basePosition.x + cos(angle)*maxDist,
                                     y: basePosition.y + sin(angle)*maxDist)
        }
    }

    func end(_ rocket: SKSpriteNode) {
            isActive = false

            let moveBack = SKAction.move(to: basePosition, duration: 0.2)
            moveBack.timingMode = .easeOut
            knob.run(moveBack) {
                self.base.isHidden = true
                self.knob.isHidden = true
                
                let resetRotation = SKAction.rotate(toAngle: 0,
                                                    duration: 0.2,
                                                    shortestUnitArc: true)
                resetRotation.timingMode = .easeOut
                rocket.run(resetRotation)
            }
        }

    func updateRocket(_ rocket: SKSpriteNode, fuel: inout CGFloat, rocketY: inout CGFloat) {
        guard isActive else { return }
        let dx = knob.position.x - basePosition.x
        let norm = dx / 60
        let speed: CGFloat = 5
        var newX = rocket.position.x + norm * speed
        
        if let sceneWidth = rocket.scene?.size.width {
            let halfW = rocket.size.width / 2
            newX = max(halfW, min(sceneWidth - halfW, newX))
            rocket.position = CGPoint(x: newX, y: rocketY)
            rocket.zRotation = -norm * 0.3
        }

    }
}
