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
}
