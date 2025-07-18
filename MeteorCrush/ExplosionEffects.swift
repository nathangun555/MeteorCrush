import SpriteKit

struct ExplosionEffects {
    static func playExplosion(at position: CGPoint, in scene: SKScene) {
        let textureNames = ["explo1", "explo2", "explo3", "explo4", "explo5"]

        for (index, name) in textureNames.enumerated() {
            let delay = SKAction.wait(forDuration: Double(index) * 0.1)
            let addExplosion = SKAction.run {
                let texture = SKTexture(imageNamed: name)
                let sprite = SKSpriteNode(texture: texture)
                sprite.position = position
                sprite.zPosition = 999 - CGFloat(index)
                sprite.setScale(0.04)
                sprite.alpha = 1.0 - CGFloat(index) * 0.1

                scene.addChild(sprite)

                let fade = SKAction.fadeOut(withDuration: 0.6)
                let wait = SKAction.wait(forDuration: 0.6)
                let remove = SKAction.removeFromParent()
                sprite.run(SKAction.sequence([wait, fade, remove]))
            }
            scene.run(SKAction.sequence([delay, addExplosion]))
        }
    }
}
