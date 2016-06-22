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
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func add(entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
    }
    
    //Add an entity to the entities collection if the node of this entity
    //is already set in the editor
    func addEntityFromEditor(entity: GKEntity) {
        entities.insert(entity)
    }
    
    //Remove entity and its node
    func remove(entity: GKEntity) {
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
    }
    
    //Find entity to a determined node
    func findEntityFromNode(node: SKSpriteNode) -> GKEntity? {
        for entity in self.entities {
            if let entityNode = entity.componentForClass(SpriteComponent)?.node {
                if (entityNode == node) {
                    return entity
                }
            }
        }
        return nil
    }
    
    //Update all entities
    func update(deltaTime: CFTimeInterval) {
        for entity in entities {
            entity.updateWithDeltaTime(deltaTime)
        }
    }
    
}
