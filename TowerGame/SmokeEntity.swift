//
//  SmokeEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 20.06.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class SmokeEntity: GKEntity {

    let sizeScale: CGFloat
    let scene: GameScene
    
    init(position: CGPoint, imageName: String, sizeScale: CGFloat, scene: GameScene) {
        self.sizeScale = sizeScale
        self.scene = scene
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName), position: position)
        addComponent(spriteComponent)
        createSmoke()
    }
    
    init(position: CGPoint, sizeScale: CGFloat, scene: GameScene) {
        self.sizeScale = sizeScale
        self.scene = scene
        super.init()
        createRandomSmoke(position)
    }
    
    func createSmoke() {
        let smoke = self.componentForClass(SpriteComponent)?.node
        smoke!.size = CGSize(width: smoke!.size.width * sizeScale, height: smoke!.size.height * sizeScale)
        smoke!.zPosition = 40
        smoke!.alpha = 0.7
        let scaleAction = SKAction.scaleBy(2, duration: 0.6)
        let removeAction = SKAction.runBlock {
            self.scene.entityManager.remove(self)
        }
        smoke!.runAction(SKAction.sequence([scaleAction, removeAction]))
    }
    
    func createRandomSmoke(position: CGPoint) {
        let randomNumber = Int(arc4random_uniform(24))
        var textureString: String
        switch randomNumber {
        case 1: textureString = "smokeGrey0"
        case 2: textureString = "smokeGrey1"
        case 3: textureString = "smokeGrey2"
        case 4: textureString = "smokeGrey3"
        case 5: textureString = "smokeGrey4"
        case 6: textureString = "smokeGrey5"
        case 7: textureString = "smokeOrange0"
        case 8: textureString = "smokeOrange1"
        case 9: textureString = "smokeOrange2"
        case 10: textureString = "smokeOrange3"
        case 11: textureString = "smokeOrange4"
        case 12: textureString = "smokeOrange5"
        case 13: textureString = "smokeWhite0"
        case 14: textureString = "smokeWhite1"
        case 15: textureString = "smokeWhite2"
        case 16: textureString = "smokeWhite3"
        case 17: textureString = "smokeWhite4"
        case 18: textureString = "smokeWhite5"
        case 19: textureString = "smokeYellow0"
        case 20: textureString = "smokeYellow1"
        case 21: textureString = "smokeYellow2"
        case 22: textureString = "smokeYellow3"
        case 23: textureString = "smokeYellow4"
        case 24: textureString = "smokeYellow5"
        default: textureString = "smokeWhite0"
        }
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: textureString), position: position)
        addComponent(spriteComponent)
        let smoke = self.componentForClass(SpriteComponent)?.node
        smoke!.size = CGSize(width: smoke!.size.width * sizeScale, height: smoke!.size.height * sizeScale)
        smoke!.zPosition = 40
        smoke!.alpha = 0.8
        let scaleAction = SKAction.scaleBy(2, duration: 0.6)
        let removeAction = SKAction.runBlock {
            self.scene.entityManager.remove(self)
        }
        smoke!.runAction(SKAction.sequence([scaleAction, removeAction]))
    }
}
