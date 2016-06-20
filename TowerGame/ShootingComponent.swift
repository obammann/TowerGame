//
//  ShootingComponent.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit


class ShootingComponent: GKComponent {

    var bulletOriginPosition: CGPoint
    var didShooting = false
    let bulletImageName: String
    let scene: GameScene
    var bulletNode: SKSpriteNode?
    
    //SpriteNode of associated Entity
    let entityNode: SKSpriteNode
    
    //SpriteNode of Target
    let targetNode: SKSpriteNode
    
    
    
    init(scene: GameScene, bulletOriginPosition: CGPoint, bulletImageName: String, entityNode: SKSpriteNode, targetNode: SKSpriteNode) {
        self.bulletOriginPosition = bulletOriginPosition
        self.bulletImageName = bulletImageName
        self.scene = scene
        self.entityNode = entityNode
        self.targetNode = targetNode
        
        super.init()
        
    }
    
    //Create and shoot the bullet in the target's direction
    func shoot() {
        if (!didShooting) {
            
            
            //Angle to the target's direction
            let angle = atan2(bulletOriginPosition.y - targetNode.position.y, bulletOriginPosition.x - targetNode.position.x) + CGFloat(M_PI)
            
            // Determine offset of location to bullet
            let offset = targetNode.position - bulletOriginPosition
            
            // Get the direction of where to shoot
            let direction = offset.normalized()
            
            // Make it shoot far enough to be guaranteed off screen
            let shootAmount = direction * 1000
            
            // Add the shoot amount to the current position
            let realDest = shootAmount + bulletOriginPosition
            
            //Create BulletEntity and add it to the EntityManager
            let bullet = BulletEntity(imageName: bulletImageName, /*targetPosition: targetNode.position,*/ bulletOriginPosition: bulletOriginPosition+direction*50)
            scene.entityManager.add(bullet)
            self.bulletNode = (bullet.componentForClass(SpriteComponent.self)?.node)!
            
            //Rotate the bullet to the target's direction
            let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
            bulletNode!.runAction(rotateAction)
            bulletNode?.runAction(SKAction.playSoundFileNamed("shot.caf", waitForCompletion: false))
            // Create the actions
            let actionMove = SKAction.moveTo(realDest, duration: Double(Constants.BulletSpeed))
            let actionMoveDone = SKAction.runBlock {
                self.scene.entityManager.remove(bullet)
            }
            bulletNode!.runAction(SKAction.sequence([actionMove, actionMoveDone]))
            
            //Add smoke when shooting
            let smokeEntity = SmokeEntity(position: bulletOriginPosition+direction*45, imageName: "smokeWhiteSmall", sizeScale: 0.4, scene: self.scene)
            self.scene.entityManager.add(smokeEntity)
            
            didShooting = !didShooting
            let wait = SKAction.waitForDuration(1)
            let run = SKAction.runBlock {
                self.didShooting = false
            }
            entityNode.runAction(SKAction.sequence([wait, run]))
        }
        
    }
    
    func turnToTarget() {
        let angle = atan2(entityNode.position.y - targetNode.position.y, entityNode.position.x - targetNode.position.x) + CGFloat(M_PI)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        entityNode.runAction(rotateAction)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        let distanceTowerPlayer = (entityNode.position - targetNode.position).length
        if (distanceTowerPlayer() < CGFloat(Constants.DistanceToTarget)) {
            turnToTarget()
            shoot()
        }
    }

}
