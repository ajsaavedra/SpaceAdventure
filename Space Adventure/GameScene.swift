import SpriteKit
import GameplayKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
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

}
