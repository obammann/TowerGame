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
    let attackSpeed: Double!
    let sideBullets: Int
    
    //SpriteNode of associated Entity
    let entityNode: SKSpriteNode
    
    //SpriteNode of Target
    let targetNode: SKSpriteNode
    
    
    
    init(scene: GameScene, bulletOriginPosition: CGPoint, bulletImageName: String, entityNode: SKSpriteNode, targetNode: SKSpriteNode, attackSpeed: Double, sideBullets: Int) {
        self.bulletOriginPosition = bulletOriginPosition
        self.bulletImageName = bulletImageName
        self.scene = scene
        self.entityNode = entityNode
        self.targetNode = targetNode
        self.attackSpeed = attackSpeed
        self.sideBullets = sideBullets
        
        super.init()
        
    }
    
    //Create and shoot the bullet in the target's direction
    func shoot() {
        if (!didShooting) {
            
            
            //Angle to the target's direction
            let angle = atan2(bulletOriginPosition.y - targetNode.position.y, bulletOriginPosition.x - targetNode.position.x) + CGFloat(M_PI)
            
            // Determine offset of location to bullet
            let offset = targetNode.position - bulletOriginPosition
            
            // Get the direction where to shoot
            let direction = offset.normalized()
            
            // Make it shoot far enough
            let shootAmount = direction * 1000
            
            // Add the shoot amount to the current position
            let realDest = shootAmount + bulletOriginPosition
            
            //Create BulletEntity and add it to the EntityManager
            let bullet = BulletEntity(imageName: bulletImageName, bulletOriginPosition: bulletOriginPosition+direction*50)
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
                let smokeEntity = SmokeEntity(position: self.bulletNode!.position, sizeScale: 0.4, scene: self.scene)
                self.scene.entityManager.add(smokeEntity)
            }
            bulletNode!.runAction(SKAction.sequence([actionMove, actionMoveDone]))
            
            for i in 0 ..< sideBullets {
                //Calculate the angles of the bullets
                let angle2 = angle + CGFloat(M_PI * 0.1 * Double(i+1))
                let angle3 = angle - CGFloat(M_PI * 0.1 * Double(i+1))
                
                //Calculate the direction x and y value from the angle
                let velocityX2 = cos(angle2)
                let velocityY2 = sin(angle2)
                let velocityX3 = cos(angle3)
                let velocityY3 = sin(angle3)
                
                let offset2 = CGPoint(x: velocityX2, y: velocityY2)
                let offset3 = CGPoint(x: velocityX3, y: velocityY3)
                
                // Get the direction where to shoot
                let direction2 = offset2.normalized()
                let direction3 = offset3.normalized()
                
                // Make it shoot far enough
                let shootAmount2 = direction2 * 1000
                let shootAmount3 = direction3 * 1000
                
                // Add the shoot amount to the current position
                let realDest2 = shootAmount2 + bulletOriginPosition
                let realDest3 = shootAmount3 + bulletOriginPosition
                
                //Create BulletEntities and add it to the EntityManager
                let bullet2 = BulletEntity(imageName: bulletImageName, bulletOriginPosition: bulletOriginPosition+direction2*50)
                scene.entityManager.add(bullet2)
                let bulletNode2 = (bullet2.componentForClass(SpriteComponent.self)?.node)!
                
                let bullet3 = BulletEntity(imageName: bulletImageName, bulletOriginPosition: bulletOriginPosition+direction3*50)
                scene.entityManager.add(bullet3)
                let bulletNode3 = (bullet3.componentForClass(SpriteComponent.self)?.node)!
                
                //Turn the bullets to the appropriate angle
                bulletNode2.runAction(SKAction.rotateToAngle(angle2 + CGFloat(M_PI*0.5), duration: 0.0))
                bulletNode3.runAction(SKAction.rotateToAngle(angle3 + CGFloat(M_PI*0.5), duration: 0.0))
                
                //Create the shooting actions
                let actionMove2 = SKAction.moveTo(realDest2, duration: Double(Constants.BulletSpeed))
                let actionMove3 = SKAction.moveTo(realDest3, duration: Double(Constants.BulletSpeed))
                
                //Actions which remove the bullets
                let actionMoveDone2 = SKAction.runBlock {
                    let bulletEntity2 = self.scene.entityManager.findEntityFromNode(bulletNode2)
                    self.scene.entityManager.remove(bulletEntity2!)
                    
                    //Create smoke when bullet disappears
                    let smokeEntity = SmokeEntity(position: bulletNode2.position, sizeScale: 0.4, scene: self.scene)
                    self.scene.entityManager.add(smokeEntity)
                }
                let actionMoveDone3 = SKAction.runBlock {
                    let bulletEntity3 = self.scene.entityManager.findEntityFromNode(bulletNode3)
                    self.scene.entityManager.remove(bulletEntity3!)
                    
                    //Create smoke when bullet disappears
                    let smokeEntity = SmokeEntity(position: bulletNode3.position, sizeScale: 0.4, scene: self.scene)
                    self.scene.entityManager.add(smokeEntity)
                }
                //Set the actions to the bullets
                bulletNode2.runAction(SKAction.sequence([actionMove2, actionMoveDone2]))
                bulletNode3.runAction(SKAction.sequence([actionMove3, actionMoveDone3]))
            }
 
            //Add smoke when shooting
            let smokeEntity = SmokeEntity(position: bulletOriginPosition+direction*45, sizeScale: 0.4, scene: self.scene)
            self.scene.entityManager.add(smokeEntity)
            
            //Set the attackSpeed - how fast should the shoot function be repeated
            didShooting = !didShooting
            let wait = SKAction.waitForDuration(self.attackSpeed)
            let run = SKAction.runBlock {
                self.didShooting = false
            }
            entityNode.runAction(SKAction.sequence([wait, run]))
        }
    }
    
    //Turn the entityNode to the target
    func turnToTarget() {
        let angle = atan2(entityNode.position.y - targetNode.position.y, entityNode.position.x - targetNode.position.x) + CGFloat(M_PI)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        entityNode.runAction(rotateAction)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
        let distanceTowerPlayer = (entityNode.position - targetNode.position).length
        //Only shoot if the player has a specific distance to the tower
        if (distanceTowerPlayer() < CGFloat(Constants.DistanceToTarget)) {
            turnToTarget()
            shoot()
        }
    }

}
