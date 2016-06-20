//
//  ShieldEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 18.06.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class ShieldEntity: GKEntity {
    
    init(shieldNode: SKSpriteNode) {
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: shieldNode)
        addComponent(spriteComponent)
        
        let physicsComponent = PhysicsComponent(node: shieldNode)
        addComponent(physicsComponent)
        physicsComponent.setPhysicsBodyShield()
    }
    
}
