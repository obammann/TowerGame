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
    
    init(node: SKSpriteNode, scene: GameScene, maxHealth: Int, object: String) {
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(scene: scene, maxHealth: maxHealth, healthBarVisible: false)
        addComponent(healthComponent)
        
        createPhysicsComponent(node, object: object)
    }
    
    init(node: SKSpriteNode, scene: GameScene, object: String) {
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        createPhysicsComponent(node, object: object)
    }
    
    func createPhysicsComponent(node: SKSpriteNode, object: String) {
        let physicsComponent = PhysicsComponent(node: node)
        addComponent(physicsComponent)
        if object == "wall" {
            self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyWall()
        } else {
            self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyObjects()
        }
    }

}
