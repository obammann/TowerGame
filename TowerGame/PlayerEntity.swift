//
//  PlayerEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit


class PlayerEntity: GKEntity {

    var node: SKSpriteNode
    var scene: GameScene
    
    init(node: SKSpriteNode, scene: GameScene, maxHealth: Int) {
        
        self.scene = scene
        self.node = node
        
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        let attackComponent = AttackComponent(node: self.node)
        addComponent(attackComponent)
        
        let physicsComponent = PhysicsComponent(node: node)
        addComponent(physicsComponent)
        self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyPlayer()
        print(maxHealth)

        let healthComponent = HealthComponent(scene: scene, maxHealth: Int(maxHealth), healthBarVisible: true)
        addComponent(healthComponent)
        
        let movementComponent = MovementComponent(textureName: "survivor-move_", textureAtlasName: "playerMove", node: self.node)
        addComponent(movementComponent)
        
        let shieldComponent = ShieldComponent(node: self.node, maxShieldCapacity: 10, scene: self.scene)
        addComponent(shieldComponent)
    }
    
    func playerWalk() {
        self.componentForClass(MovementComponent)?.doMovement()
    }
    
    func playerProtect() {
        self.componentForClass(ShieldComponent)?.createShield()
    }
    
    func playerShieldDown() {
        self.componentForClass(ShieldComponent)?.putShieldDown()
    }
    
    func attack() {
        self.componentForClass(AttackComponent)?.attack()
    }
    
    func fend(bulletNode: SKSpriteNode) {
        if ((self.componentForClass(ShieldComponent)?.holdingShield) == true) {
            self.componentForClass(ShieldComponent)?.fend(scene, bulletNode: bulletNode)
        }
    }
    
    func playerEndAnimations() {
        self.node.removeAllActions()
    }
    
}
