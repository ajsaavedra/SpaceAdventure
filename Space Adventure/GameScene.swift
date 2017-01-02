import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private let titleLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    private let startLabel = SKLabelNode(fontNamed: "Arial")
    private var userSprite: SKSpriteNode?
    private var isGameStarted = false

    override func didMove(to view: SKView) {
        setupBackground()
        setupLabels()
        presentUser()
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

    func presentUser() {
        let userAtlas = SKTextureAtlas(named: "Ship")
        let userTexture = userAtlas.textureNamed("ship-morph01")
        userSprite = SKSpriteNode(texture: userTexture)
        userSprite?.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        userSprite?.setScale(0.75)
        self.addChild(userSprite!)

        let userMorph = SKAction.animate(with: Ship().ship_morph(), timePerFrame: 0.04)
        userSprite?.run(userMorph)
    }

    func animateUser() {
        let scale = SKAction.scale(to: 0.3, duration: 0.5)
        userSprite?.run(scale, completion: {() -> Void in
            let userAtlas = SKTextureAtlas(named: "GameShip")
            let userTexture = userAtlas.textureNamed("ship-small_01")
            let newUserSprite = SKSpriteNode(texture: userTexture)
            newUserSprite.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 130)
            newUserSprite.setScale(0.75)
            self.addChild(newUserSprite)

            let userMorph = SKAction.animate(withNormalTextures: GameShip().ship_small_(), timePerFrame: 0.5, resize: true, restore: false)
            newUserSprite.run(SKAction.repeatForever(userMorph))
            self.userSprite?.removeFromParent()
            self.userSprite = newUserSprite
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted {
            
        } else {
            titleLabel.removeFromParent()
            startLabel.removeFromParent()
            animateUser()
            isGameStarted = true
        }
    }
}
