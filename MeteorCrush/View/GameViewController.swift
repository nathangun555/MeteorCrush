//
//  GameViewController.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//


// GameViewController.swift
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let skView = view as? SKView else { return }
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    override var prefersStatusBarHidden: Bool { true }
    
}
