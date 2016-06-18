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

    var targetNode: SKSpriteNode
    var towerNode: SKSpriteNode
    var didShooting = false
    let scene: GameScene
    
    init(node: SKSpriteNode, scene: GameScene, maxHealth: Int, targetNode: SKSpriteNode) {
        self.targetNode = targetNode
        self.towerNode = node
        self.scene = scene
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(scene: scene, maxHealth: maxHealth, healthBarVisible: true)
        addComponent(healthComponent)
        
        let shootingComponent = ShootingComponent(scene: scene, bulletOriginPosition: towerNode.position, bulletImageName: "bullet", entityNode: towerNode, targetNode: targetNode)
        addComponent(shootingComponent)
        
        let physicsComponent = PhysicsComponent(node: self.towerNode)
        addComponent(physicsComponent)
        self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyTower()
    }
    
    func turnToTarget() {
        let angle = atan2(towerNode.position.y - targetNode.position.y, towerNode.position.x - targetNode.position.x) + CGFloat(M_PI)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        towerNode.runAction(rotateAction)
    }
}
