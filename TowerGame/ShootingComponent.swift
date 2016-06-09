//
//  ShootingComponent.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let Player       : UInt32 = 1
    static let Projectile   : UInt32 = 2
}

class ShootingComponent: GKComponent {
    
    init(scene: GameScene, positionBulletOrigin: CGPoint, imageNameBullet: String, positionTarget: CGPoint) {
        let positionTarget = positionTarget
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: imageNameBullet)
        projectile.position = positionBulletOrigin
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        
        // 3 - Determine offset of location to projectile
        let offset = positionTarget - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) {
            return
        }
        
        // 5 - OK to add now - you've double checked position
        scene.addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    

}
