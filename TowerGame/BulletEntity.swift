//
//  BulletEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit


class BulletEntity: GKEntity {

    var bulletOriginPosition: CGPoint
    
    init(imageName: String, bulletOriginPosition: CGPoint) {
        self.bulletOriginPosition = bulletOriginPosition

        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName), position: bulletOriginPosition)
        addComponent(spriteComponent)
        
        
        let physicsComponent = PhysicsComponent(node: (self.componentForClass(SpriteComponent.self)?.node)!)
        addComponent(physicsComponent)
        self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyBullet()
    }
    
//    func turnFromPlayer(bulletNode: SKSpriteNode, player: SKSpriteNode) {
//        bulletNode.removeAllActions()
//        
//        let angle = player.zRotation + CGFloat(M_PI)
//        bulletNode.runAction(SKAction.rotateToAngle(angle, duration: 0.0))
//        
//        let velocityX = cos(angle-CGFloat(M_PI/2))
//        let velocityY = sin(angle-CGFloat(M_PI/2))
//        
//        let offset = CGPoint(x: velocityX, y: velocityY)
//        
//        // Get the direction of where to shoot
//        var direction = offset.normalized()
//        
//        // Make it shoot far enough to be guaranteed off screen
//        let shootAmount = direction * 1000
//        
//        // Add the shoot amount to the current position
//        let realDest = shootAmount + player.position
//        
//        // Create the actions
//        let actionMove = SKAction.moveTo(realDest, duration: Double(Constants.BulletSpeed))
//        let actionMoveDone = SKAction.runBlock {
//            bulletNode.removeFromParent()
//        }
//        bulletNode.runAction(SKAction.sequence([actionMove, actionMoveDone]))
//    }
}
