import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private let titleLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    private let startLabel = SKLabelNode(fontNamed: "Arial")

    override func didMove(to view: SKView) {
        setupBackground()
        setupLabels()
    }

    func setupBackground() {
        let atlas = SKTextureAtlas(named: "BgStars")
        let texture = atlas.textureNamed("bg-stars_00")
        let bgSprite = SKSpriteNode(texture: texture)
        bgSprite.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addChild(bgSprite)

        let bg_move = SKAction.animate(with: BgStars().bg_stars_(), timePerFrame:0.025)
        bgSprite.run(SKAction.repeatForever(bg_move))
    }

    func setupLabels() {
        titleLabel.text = "SPACE ADVENTURE"
        titleLabel.fontSize = 32
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)

        startLabel.text = "Touch to Start Game"
        startLabel.fontSize = 20
        startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 20)

        addChild(titleLabel)
        addChild(startLabel)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleLabel.removeFromParent()
        startLabel.removeFromParent()
    }
}
