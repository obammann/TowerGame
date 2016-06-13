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

    var playerNode: SKSpriteNode
    var towerNode: SKSpriteNode
    var didShooting = false
    
    init(node: SKSpriteNode, scene: GameScene, maxHealth: CGFloat, playerNode: SKSpriteNode) {
        self.playerNode = playerNode
        self.towerNode = node
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        let healthComponent = HealthComponent(scene: scene, maxHealth: maxHealth, position: node.position, associatedObject: node)
        addComponent(healthComponent)
        
        let shootingComponent = ShootingComponent(scene: scene, positionBulletOrigin: towerNode.position, imageNameBullet: "bullet", targetSprite: self.playerNode, bulletSpeed: 5, shooterNode: self.towerNode)
        addComponent(shootingComponent)
    }
    
    
    func shoot() {
        if (!didShooting) {
            self.componentForClass(ShootingComponent.self)?.shoot()
            didShooting = !didShooting
            let wait = SKAction.waitForDuration(1)
            let run = SKAction.runBlock {
                self.didShooting = false
            }
            towerNode.runAction(SKAction.sequence([wait, run]))
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        let distanceTowerPlayer = (towerNode.position - playerNode.position).length
        let distanceMax: CGFloat = 300
        if (distanceTowerPlayer() < distanceMax) {
            shoot()
            self.componentForClass(ShootingComponent.self)?.turnToTarget()
        }
    }
}
