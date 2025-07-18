//
//  Joystick.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

class Joystick: SKNode {
    var sensitivity: CGFloat = 1
    private var trackingTouch: UITouch?
    private let base = SKShapeNode(circleOfRadius: 60)
    private let knob = SKShapeNode(circleOfRadius: 30)
    private(set) var isActive = false
    private var basePosition = CGPoint.zero
    
    override init() {
        super.init()
        base.fillColor = .gray; base.alpha = 0.4; base.zPosition = 100; base.isHidden = true
        knob.fillColor = .white; knob.alpha = 0.8; knob.zPosition = 101; knob.isHidden = true
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
        let adjustedSpeed = norm * speed * sensitivity  // ✅ pengaruh sensitivitas dimasukkan di sini

        var newX = rocket.position.x + adjustedSpeed
        let halfW = rocket.size.width / 2
        newX = max(halfW, min(rocket.scene!.size.width - halfW, newX))
        rocket.position = CGPoint(x: newX, y: rocketY)

        rocket.zRotation = -norm * 0.3
    }

}
