//
//  ControlComponent.swift
//  TowerGame
//
//  Created by Oliver Bammann on 25.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class ShieldComponent: GKComponent {
    
    let scene: GameScene
    var entityNode: SKSpriteNode
    var shieldNode: SKSpriteNode?
    var shieldBar: SKSpriteNode?
    var shieldBarBorder: SKSpriteNode?
    let shieldBarWidth: CGFloat
    var holdingShield = false
    var shieldBarEmpty = false
    let maxShieldCapacity: CGFloat
    let currentShieldCapacity: CGFloat
    let barShrinkDuration: CGFloat
    
    init(node: SKSpriteNode, maxShieldCapacity: CGFloat, scene: GameScene) {
        self.scene = scene
        self.entityNode = node
        self.maxShieldCapacity = maxShieldCapacity
        self.currentShieldCapacity = maxShieldCapacity
        self.shieldBarWidth = maxShieldCapacity * 25
        self.barShrinkDuration = 3.0
        super.init()
        createShieldBar()
    }
    
    func createShield() {
        if !self.shieldBarEmpty {
            self.shieldNode = SKSpriteNode(imageNamed: "shield")
            self.shieldNode?.size = CGSize(width: entityNode.size.width+40, height: 52)
            self.shieldNode!.zPosition = 50
            let angle = entityNode.zRotation + CGFloat(M_PI)
            self.shieldNode!.runAction(SKAction.rotateToAngle(angle, duration: 0.0))
            
            self.shrinkShieldBar()
            self.scene.entityManager.add(ShieldEntity(shieldNode: shieldNode!))
        }
    }
    
    func createShieldBar() {
        if !shieldBarEmpty {
            let bar = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: shieldBarWidth, height: 30))
            bar.anchorPoint = CGPointMake(0, 0.5)
            bar.zPosition = 100
            //shieldBar border
            self.shieldBarBorder = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: shieldBarWidth + 10, height: 40))
            self.shieldBarBorder!.zPosition = 99
            self.scene.addChild(self.shieldBarBorder!)
            self.shieldBar = bar
            self.scene.addChild(shieldBar!)
        }
    }
    
    func shrinkShieldBar() {
        if !holdingShield {
            holdingShield = true
            let shrinkDuration = barShrinkDuration * (((shieldBar?.size.width)!/25) / (self.maxShieldCapacity))
            shieldBar!.runAction(SKAction.resizeToWidth(0, duration: Double(shrinkDuration)))
        }
    }
    
    func putShieldDown() {
        if holdingShield {
            shieldBar!.removeAllActions()
            let shieldEntity = self.scene.entityManager.findEntityFromNode(shieldNode!)
            self.scene.entityManager.remove(shieldEntity!)
            holdingShield = false
            let shieldLoadDuration = (maxShieldCapacity - (shieldBar!.size.width)/25)
            shieldBar!.runAction(SKAction.resizeToWidth(shieldBarWidth, duration: Double(shieldLoadDuration/2)))
        }
    }
    
    func updatePosition() {
        shieldBar?.position.x = scene.cam.position.x - 518//scene.cam.size.width/2 + 32
        shieldBar?.position.y = scene.cam.position.y + 190//scene.cam.height/2 - 32
        shieldBarBorder?.position.x = (shieldBar?.position.x)! + 125
        shieldBarBorder?.position.y = (shieldBar?.position.y)!
        if holdingShield {
            let angle = entityNode.zRotation + CGFloat(M_PI)
            self.shieldNode!.runAction(SKAction.rotateToAngle(angle, duration: 0.0))
            
            let directionX = cos(angle-CGFloat(M_PI/2))
            let directionY = sin(angle-CGFloat(M_PI/2))
            
            let offset = CGPoint(x: directionX, y: directionY)
            let direction = offset.normalized()
            shieldNode!.position = entityNode.position + (direction * 35)
        }
    }
    
    func fend(scene: GameScene, bulletNode: SKSpriteNode) {
        if let bulletEntity = scene.entityManager.findEntityFromNode(bulletNode) as! BulletEntity? {
            
            if bulletEntity.bulletFend == false {
                bulletNode.removeAllActions()
                
                let angle = shieldNode!.zRotation
                bulletNode.runAction(SKAction.rotateToAngle(angle, duration: 0.0))
                
                let velocityX = cos(angle-CGFloat(M_PI/2))
                let velocityY = sin(angle-CGFloat(M_PI/2))
                
                let offset = CGPoint(x: velocityX, y: velocityY)
                
                // Get the direction where to fend the bullet
                let direction = offset.normalized()
                
                // Make it shoot far enough
                let shootAmount = direction * 1000
                
                // Add the shoot amount to the current position
                let realDest = shootAmount + entityNode.position
                
                // Create the actions
                let actionMove = SKAction.moveTo(realDest, duration: Double(Constants.BulletSpeedShield))
                let actionMoveDone = SKAction.runBlock {
                    let bulletEntity = scene.entityManager.findEntityFromNode(bulletNode)
                    scene.entityManager.remove(bulletEntity!)
                    
                    //Create smoke when bullet disappears
                    let smokeEntity = SmokeEntity(position: bulletNode.position, sizeScale: 0.4, scene: self.scene)
                    self.scene.entityManager.add(smokeEntity)
                }
                bulletNode.runAction(SKAction.sequence([actionMove, actionMoveDone]))
                
                bulletEntity.bulletFend = true
            }
        
        }
        

    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updatePosition()
        if shieldBar?.size.width < 1 {
            shieldBar?.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0, duration: 0))
            putShieldDown()
            shieldBarEmpty = true
        }
        if shieldBar?.size.width > shieldBarWidth/2 && shieldBarEmpty {
            shieldBar?.runAction(SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 0, duration: 0))
            shieldBarEmpty = false
        }
    }
    
}

