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
    var targetPosition: CGPoint
    
    init(imageName: String, targetPosition: CGPoint, bulletOriginPosition: CGPoint) {
        self.bulletOriginPosition = bulletOriginPosition
        self.targetPosition = targetPosition

        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName), position: bulletOriginPosition)
        addComponent(spriteComponent)
        
        
        let physicsComponent = PhysicsComponent(node: (self.componentForClass(SpriteComponent.self)?.node)!)
        addComponent(physicsComponent)
        self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyBullet()
        
        turnToTarget((self.componentForClass(SpriteComponent.self)?.node)!)
        
    }
    func turnFromPlayer(bulletNode: SKSpriteNode, player: SKSpriteNode) {
        bulletNode.removeAllActions()
        
        
        bulletNode.runAction(SKAction.rotateToAngle(player.zRotation + CGFloat(M_PI*1.0), duration: 0.0))
        
        /*
        
        let velocityX = cos(player.zRotation + CGFloat(M_PI*1.0))
        let velocityY = sin(player.zRotation + CGFloat(M_PI*1.0))
        
        let offset = CGPoint(x: velocityX, y: velocityY) - player.position
        
        // Get the direction of where to shoot
        let direction = offset.normalized()
        
        // Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // Add the shoot amount to the current position
        let realDest = shootAmount + player.position
        
        // Create the actions
        bulletNode.runAction(SKAction.moveTo(realDest, duration: Double(Constants.BulletSpeed)))*/
        //player.
    }
    
    func turnToTarget(bulletNode: SKSpriteNode) {
        let angle = atan2(bulletOriginPosition.y - targetPosition.y, bulletOriginPosition.x - targetPosition.x) + CGFloat(M_PI)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        bulletNode.runAction(rotateAction)
    }
}
