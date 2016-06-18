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
        
        let healthComponent = HealthComponent(scene: scene, maxHealth: maxHealth, healthBarVisible: true)
        addComponent(healthComponent)
        
        let movementComponent = MovementComponent(textureName: "survivor-move_", textureAtlasName: "playerMove", node: self.node)
        addComponent(movementComponent)
    }
    
    func playerWalk() {
        self.componentForClass(MovementComponent)?.doMovement()
    }
    
    func playerStand() {
        
    }
    
    func attack() {
        self.componentForClass(AttackComponent)?.attack()
    }
    
    func fend() {
        if ((self.componentForClass(AttackComponent)?.inAttack) == true) {
            self.componentForClass(AttackComponent)?.fend(scene, shootAngle: node.zRotation + CGFloat(M_PI))
        }
    }
    
    func playerEndAnimations() {
        self.node.removeAllActions()
    }
    
}
