//
//  TowerEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit


class TowerEntity: GKEntity {

    init(imageName: String) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
    }
    
    init(node: SKSpriteNode, scene: GameScene, maxHealth: CGFloat) {
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(scene: scene, maxHealth: maxHealth, position: node.position, associatedObject: node)
        addComponent(healthComponent)
    }
    
    init(imageName: String, point: CGPoint) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
    }
}
