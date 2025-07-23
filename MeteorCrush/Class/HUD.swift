//
//  HUD.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

class HUD: SKNode {
    let powerupSize: CGFloat = 60.0
    
    private let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let fuelLabel  = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    private let shieldLabel = SKSpriteNode(imageNamed: "casingShield")
    private let shieldTimerLabel = SKShapeNode()
    private let multiplierLabel = SKSpriteNode(imageNamed: "casing2x")
    private let multiplierTimerLabel = SKShapeNode()
    

    var score: Int = 0
    var fuel: CGFloat = 100
    var starCount: Int = 0
    
    var shieldPos: CGPoint
    var multiplierPos: CGPoint
    
    init(size: CGSize) {
        self.shieldPos = CGPoint(x: size.width - 80, y: size.height - 100)
        self.multiplierPos = CGPoint(x: self.shieldPos.x, y: self.shieldPos.y - powerupSize - 50)

        super.init()
        scoreLabel.fontSize = 24; scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width - 80, y: size.height - 70)
        scoreLabel.zPosition = 20; scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        fuelLabel.fontSize = 24; fuelLabel.fontColor = .yellow
        fuelLabel.position = CGPoint(x: 80, y: size.height - 70)
        fuelLabel.zPosition = 20; fuelLabel.text = "Fuel: \(Int(fuel))"
        addChild(fuelLabel)
        
        shieldLabel.size = CGSize(width: powerupSize, height: powerupSize)
        shieldLabel.position = shieldPos
        shieldLabel.zPosition = 20
        shieldLabel.isHidden = true
        addChild(shieldLabel)
        
        shieldTimerLabel.strokeColor = .white
        shieldTimerLabel.zPosition = 21
        shieldTimerLabel.lineWidth = 8
        shieldTimerLabel.lineCap = .round
        shieldTimerLabel.isHidden = true
        shieldTimerLabel.alpha = 0.5
        addChild(shieldTimerLabel)
        
        multiplierLabel.size = CGSize(width: powerupSize, height: powerupSize)
        multiplierLabel.position = self.multiplierPos
        multiplierLabel.zPosition = 20
        multiplierLabel.isHidden = true
        addChild(multiplierLabel)
        
        multiplierTimerLabel.strokeColor = .white
        multiplierTimerLabel.zPosition = 21
        multiplierTimerLabel.lineWidth = 8
        multiplierTimerLabel.lineCap = .round
        multiplierTimerLabel.isHidden = true
        multiplierTimerLabel.alpha = 0.5
        addChild(multiplierTimerLabel)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateLabels() {
        scoreLabel.text = "Score: \(score)"
        fuelLabel.text  = "Fuel: \(Int(fuel))"
    }
    
    func updatePowerupState(in scene: GameScene){
        shieldLabel.isHidden = !scene.isShield
        shieldTimerLabel.isHidden = !scene.isShield
        if(!shieldTimerLabel.isHidden){
            let path = CGMutablePath()
            let currentAngle: CGFloat = (scene.shieldTimer / 10) * (.pi * 2)
            path.addArc(center: self.shieldPos, radius: 30, startAngle: .pi / 2, endAngle: currentAngle + .pi / 2, clockwise: false)
            shieldTimerLabel.path = path
        }
        
        multiplierLabel.isHidden = !scene.isDoublePoint
        multiplierTimerLabel.isHidden = !scene.isDoublePoint
        if(!multiplierTimerLabel.isHidden){
            let path = CGMutablePath()
            let currentAngle: CGFloat = (scene.multiplierTimer / 10) * (.pi * 2)
            path.addArc(center: self.multiplierPos, radius: 30, startAngle: .pi / 2, endAngle: currentAngle + .pi / 2, clockwise: false)
            multiplierTimerLabel.path = path
        }
    }
    
}
