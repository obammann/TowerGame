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

    var bulletPosition: CGPoint
    var targetPosition: CGPoint
//    let bulletNode: SKSpriteNode
    let bulletSpeed: CGFloat
    
    init(imageName: String, targetPosition: CGPoint, bulletPosition: CGPoint, bulletSpeed: CGFloat) {
        self.bulletPosition = bulletPosition
        self.targetPosition = targetPosition
        self.bulletSpeed = bulletSpeed

        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
        
        
        
        updateBullet(self.componentForClass(SpriteComponent.self)!.node)
    }
    
    init(bulletNode: SKSpriteNode, targetPosition: CGPoint, bulletPosition: CGPoint, bulletSpeed: CGFloat) {
        self.bulletPosition = bulletPosition
        self.targetPosition = targetPosition
        self.bulletSpeed = bulletSpeed
        
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: bulletNode)
        addComponent(spriteComponent)
        
        
        
        updateBullet(bulletNode)
    }
    
    
    
    func updateBullet(bulletNode: SKSpriteNode) {
        let angle = atan2(bulletPosition.y - targetPosition.y, bulletPosition.x - targetPosition.x) + CGFloat(M_PI)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        bulletNode.runAction(rotateAction)
        
        let direction = targetPosition.normalized()
//        let shootAmount = direction * 1000
        let shootAmount = CGPoint(x: direction.x+100, y: direction.y+100)
        let newDest = shootAmount + bulletPosition
        
        
        bulletNode.runAction(SKAction.moveTo(newDest, duration: 7))
        
//        let velocityX = bulletSpeed * cos(angle)
//        let velocityY = bulletSpeed * sin(angle)
//        
//        let newVelocity = CGVector(dx: velocityX, dy: velocityY)
//        bulletNode.physicsBody!.velocity = newVelocity;
        
    }
    
    
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}
