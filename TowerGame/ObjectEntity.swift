//
//  ObjectEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 25.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class ObjectEntity: GKEntity {
    
    init(node: SKSpriteNode, scene: GameScene, maxHealth: CGFloat) {
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(scene: scene, maxHealth: maxHealth, associatedObject: node, healthBarVisible: false)
        addComponent(healthComponent)
        
        let physicsComponent = PhysicsComponent(node: node)
        addComponent(physicsComponent)
        self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyObjects()
    }
    
    init(node: SKSpriteNode, scene: GameScene) {
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        let physicsComponent = PhysicsComponent(node: node)
        addComponent(physicsComponent)
        self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyObjects()
    }

}
