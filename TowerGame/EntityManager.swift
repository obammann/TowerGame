//
//  EntityManager.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    var entities = Set<GKEntity>()
    let scene: SKScene
    
    //Bullet entities
    var bulletEntities = Set<GKEntity>()
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func addBullet(entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    func add(entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    func addEntityFromEditor(entity: GKEntity) {
        entities.insert(entity)
    }
    
    func removeBullet(entity: GKEntity) {
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        bulletEntities.remove(entity)
    }
    
    func remove(entity: GKEntity) {
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
    }
    
    func update(deltaTime: CFTimeInterval) {
        for entity in entities {
            entity.updateWithDeltaTime(deltaTime)
        }
    }
    
}
