//
//  HUD.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

class HUD: SKNode {
    private let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let fuelLabel  = SKLabelNode(fontNamed: "AvenirNext-Bold")

    var score: Int = 0
    var fuel: CGFloat = 5
    
    init(size: CGSize) {
        super.init()
        scoreLabel.fontSize = 24; scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width - 80, y: size.height - 70)
        scoreLabel.zPosition = 20; scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        fuelLabel.fontSize = 24; fuelLabel.fontColor = .yellow
        fuelLabel.position = CGPoint(x: 80, y: size.height - 70)
        fuelLabel.zPosition = 20; fuelLabel.text = "Fuel: \(Int(fuel))"
        addChild(fuelLabel)
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateLabels() {
        scoreLabel.text = "Score: \(score)"
        fuelLabel.text  = "Fuel: \(Int(fuel))"
      
    }
}
