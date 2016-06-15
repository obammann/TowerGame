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
        self.componentForClass(SpriteComponent.self)?.setPhysicsBodyBullet()
        
        turnToTarget((self.componentForClass(SpriteComponent.self)?.node)!)
        
    }
    
    func turnToTarget(bulletNode: SKSpriteNode) {
        let angle = atan2(bulletOriginPosition.y - targetPosition.y, bulletOriginPosition.x - targetPosition.x) + CGFloat(M_PI)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        bulletNode.runAction(rotateAction)
    }
}
