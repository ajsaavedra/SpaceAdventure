// ---------------------------------------
// Sprite definitions for 'GameShip'
// Generated with TexturePacker 4.3.1
//
// http://www.codeandweb.com/texturepacker
// ---------------------------------------

import SpriteKit


class GameShip {

    // sprite names
    let SHIP_SMALL_01 = "ship-small_01"
    let SHIP_SMALL_02 = "ship-small_02"
    let SHIP_SMALL_03 = "ship-small_03"
    let SHIP_SMALL_04 = "ship-small_04"


    // load texture atlas
    let textureAtlas = SKTextureAtlas(named: "GameShip")


    // individual texture objects
    func ship_small_01() -> SKTexture { return textureAtlas.textureNamed(SHIP_SMALL_01) }
    func ship_small_02() -> SKTexture { return textureAtlas.textureNamed(SHIP_SMALL_02) }
    func ship_small_03() -> SKTexture { return textureAtlas.textureNamed(SHIP_SMALL_03) }
    func ship_small_04() -> SKTexture { return textureAtlas.textureNamed(SHIP_SMALL_04) }


    // texture arrays for animations
    func ship_small_() -> [SKTexture] {
        return [
            ship_small_01(),
            ship_small_02(),
            ship_small_03(),
            ship_small_04()
        ]
    }


}
