import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None     : UInt32 = 0
    static let All      : UInt32 = UInt32.max
    static let Asteroid : UInt32 = 0b1
    static let Missile  : UInt32 = 0b10
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x:left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x:left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }

    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    private let titleLabel = SKLabelNode(fontNamed: "Orbitron-Black")
    private let secondTitleLabel = SKLabelNode(fontNamed: "Orbitron-Black")
    private let startLabel = SKLabelNode(fontNamed: "Orbitron-Regular")
    private var userSprite: SKSpriteNode?
    private var isGameStarted = false

    override func didMove(to view: SKView) {
        setupBackground()
        setupLabels()
        presentUser()
        physicsWorld.contactDelegate = self
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
        titleLabel.text = "SPACE"
        titleLabel.fontSize = 35
        titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 220)

        secondTitleLabel.text = "ADVENTURE"
        secondTitleLabel.fontSize = 35
        secondTitleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 180)

        startLabel.text = "Touch to Start Game"
        startLabel.fontSize = 20
        startLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 120)

        addChild(titleLabel)
        addChild(secondTitleLabel)
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

            let userMorph = SKAction.animate(with: GameShip().ship_small_(), timePerFrame: 0.1)
            newUserSprite.run(SKAction.repeatForever(userMorph))
            self.userSprite?.removeFromParent()
            self.userSprite = newUserSprite
        })
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted {
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: self)
            if touchLocation.x > (userSprite?.size.width)!/2 &&
                touchLocation.x < size.width - (userSprite?.size.width)!/2 {
                let offset = touchLocation - userSprite!.position
                let missile = SKSpriteNode(imageNamed: "missile")

                if offset.y < missile.size.height/2 {
                    movePlayer(to: touchLocation)
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted {
            guard let touch = touches.first else {
                return
            }
            let touchLocation = touch.location(in: self)

            let missile = SKSpriteNode(imageNamed: "missile")
            missile.position = userSprite!.position
            setMissilePhysics(to: missile)
            let offset = touchLocation - missile.position

            if offset.y > missile.size.height/2 {
                shootAsteroid(with: missile)
            }
        } else {
            titleLabel.removeFromParent()
            secondTitleLabel.removeFromParent()
            startLabel.removeFromParent()
            animateUser()
            setUserPhysics()
            generateAsteroidsForever()
            isGameStarted = true
        }
    }

    func generateAsteroidsForever() {
        run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(setAsteroid),
                    SKAction.wait(forDuration: 0.6)
                ])
        ))
    }

    func setAsteroid() {
        let asteroidSprite = SKSpriteNode(imageNamed: "asteroid")
        let actualX = random(min: asteroidSprite.size.width/2, max: size.width - asteroidSprite.size.width/2)
        asteroidSprite.position = CGPoint(x: actualX, y: size.height + asteroidSprite.size.height/2)
        setAsteroidPhysics(to: asteroidSprite)
        addChild(asteroidSprite)

        let actualDuration = random(min: CGFloat(1.0), max: CGFloat(2.5))
        let actionMove = SKAction.move(
            to: CGPoint(x: actualX , y: -asteroidSprite.size.height/2),
            duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        asteroidSprite.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }

    func setAsteroidPhysics(to asteroidSprite: SKSpriteNode) {
        asteroidSprite.physicsBody = SKPhysicsBody(circleOfRadius: asteroidSprite.size.width/2)
        asteroidSprite.physicsBody?.isDynamic = true
        asteroidSprite.physicsBody?.categoryBitMask = PhysicsCategory.Asteroid
        asteroidSprite.physicsBody?.contactTestBitMask = PhysicsCategory.Missile
        asteroidSprite.physicsBody?.collisionBitMask = PhysicsCategory.None
        asteroidSprite.physicsBody?.usesPreciseCollisionDetection = true
    }

    func setUserPhysics() {
        userSprite?.physicsBody = SKPhysicsBody(rectangleOf: userSprite!.size)
        userSprite?.physicsBody?.allowsRotation = false
        userSprite?.physicsBody?.affectedByGravity = false
    }

    func setMissilePhysics(to missile: SKSpriteNode) {
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody?.isDynamic = true
        missile.physicsBody?.categoryBitMask = PhysicsCategory.Missile
        missile.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        missile.physicsBody?.collisionBitMask = PhysicsCategory.None
        missile.physicsBody?.usesPreciseCollisionDetection = true
    }

    func movePlayer(to touchLocation: CGPoint) {
        let newLocation = CGPoint(x: touchLocation.x, y: userSprite!.position.y)
        userSprite!.run(SKAction.move(to: newLocation, duration: 0.08))
    }

    func shootAsteroid(with missile: SKSpriteNode) {
        addChild(missile)
        let realDest = CGPoint(x: missile.position.x, y: 2000)
        let shootMove = SKAction.move(to: realDest, duration: 1.0)
        let shootDone = SKAction.removeFromParent()
        missile.run(SKAction.sequence([shootMove, shootDone]))
    }

    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Asteroid != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Missile != 0)) {
            projectileDidCollideWithMonster(missile: firstBody.node as! SKSpriteNode, asteroid: secondBody.node as! SKSpriteNode)
        }
    }

    func projectileDidCollideWithMonster(missile: SKSpriteNode, asteroid: SKSpriteNode) {
        missile.removeFromParent()
        asteroid.removeFromParent()
    }
}
