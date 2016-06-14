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
    
    let targetSprite: SKSpriteNode
    let shooterNode: SKSpriteNode
    var bulletPosition: CGPoint
    //    let bulletNode: SKSpriteNode
    let bulletSpeed: CGFloat
    let bulletImageName: String
    let scene: GameScene
    
    
    
    init(scene: GameScene, positionBulletOrigin: CGPoint, imageNameBullet: String, targetSprite: SKSpriteNode, bulletSpeed: CGFloat, shooterNode: SKSpriteNode) {
        self.targetSprite = targetSprite
        self.shooterNode = shooterNode
        self.bulletPosition = positionBulletOrigin
        self.bulletImageName = imageNameBullet
        self.scene = scene
        self.bulletSpeed = bulletSpeed
        super.init()
    }
    
    func shoot() {
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: bulletImageName)
        projectile.position = bulletPosition
        projectile.zPosition = 10
        
        let angle = atan2(bulletPosition.y - targetSprite.position.y, bulletPosition.x - targetSprite.position.x) + CGFloat(M_PI)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        projectile.runAction(rotateAction)

        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
//        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
//        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Player
//        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
//        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        
        // 3 - Determine offset of location to projectile
        let offset = targetSprite.position - projectile.position
        
        // 5 - OK to add now - you've double checked position
        scene.addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: Double(bulletSpeed))
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func turnToTarget() {
        let angle = atan2(shooterNode.position.y - targetSprite.position.y, shooterNode.position.x - targetSprite.position.x) + CGFloat(M_PI)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        shooterNode.runAction(rotateAction)

    }

}
