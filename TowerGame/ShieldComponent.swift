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
//    let shieldEntity: GKEntity?
    var shieldNode: SKSpriteNode?
    var shieldBar: SKSpriteNode?
    let shieldBarWidth: CGFloat
    var holdingShield = false
    var shieldBarEmpty = false
    let maxShieldCapacity: CGFloat
    let currentShieldCapacity: CGFloat
    
    init(node: SKSpriteNode, maxShieldCapacity: CGFloat, scene: GameScene) {
        self.scene = scene
        self.entityNode = node
        self.maxShieldCapacity = maxShieldCapacity
        self.currentShieldCapacity = maxShieldCapacity
        self.shieldBarWidth = maxShieldCapacity * 20
        super.init()
        createShieldBar()
    }
    
    func createShield() {
//        self.shieldNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: entityNode.size.width, height: 20))
        self.shieldNode = SKSpriteNode(imageNamed: "shield")
        self.shieldNode?.size = CGSize(width: entityNode.size.width+40, height: 52 )
        self.shieldNode!.zPosition = 50
        let angle = entityNode.zRotation + CGFloat(M_PI)
        self.shieldNode!.runAction(SKAction.rotateToAngle(angle, duration: 0.0))
        
        let directionX = cos(angle-CGFloat(M_PI/2))
        let directionY = sin(angle-CGFloat(M_PI/2))
        
        let offset = CGPoint(x: directionX, y: directionY)
        let direction = offset.normalized()
//        shieldNode!.position = entityNode.position + (direction * 50)
        self.shrinkShieldBar()
        self.scene.entityManager.add(ShieldEntity(shieldNode: shieldNode!))
        
//        self.scene.addChild(shieldNode!)
    }
    
    func createShieldBar() {
        if !shieldBarEmpty {
            let bar = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: shieldBarWidth, height: 30))
            bar.anchorPoint = CGPointMake(0, 0.5)
            bar.zPosition = 100
            self.shieldBar = bar
            self.scene.addChild(shieldBar!)
        }
    }
    
    func shrinkShieldBar() {
        if !holdingShield {
            holdingShield = true
            shieldBar!.runAction(SKAction.resizeToWidth(0, duration: Double((shieldBar?.size.width)!/20)))
        }
    }
    
    func putShieldDown() {
        if holdingShield {
            shieldBar!.removeAllActions()
            let shieldEntity = self.scene.entityManager.findEntityFromNode(shieldNode!)
            self.scene.entityManager.remove(shieldEntity!)
//            self.shieldNode?.removeFromParent()
            holdingShield = false
            let shieldLoadDuration = maxShieldCapacity - (shieldBar!.size.width)/20
            shieldBar!.runAction(SKAction.resizeToWidth(shieldBarWidth, duration: Double(shieldLoadDuration)))
        }
    }
    
    func updatePosition() {
        shieldBar?.position.x = scene.cam.position.x - 100//scene.cam.size.width/2 + 32
        shieldBar?.position.y = scene.cam.position.y + 200//scene.cam.height/2 - 32
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
        bulletNode.removeAllActions()
        
        let angle = shieldNode!.zRotation
        bulletNode.runAction(SKAction.rotateToAngle(angle, duration: 0.0))
        
        let velocityX = cos(angle-CGFloat(M_PI/2))
        let velocityY = sin(angle-CGFloat(M_PI/2))
        
        let offset = CGPoint(x: velocityX, y: velocityY)
        
        // Get the direction of where to shoot
        let direction = offset.normalized()
        
        // Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // Add the shoot amount to the current position
        let realDest = shootAmount + entityNode.position
        
        // Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: Double(Constants.BulletSpeed))
        let actionMoveDone = SKAction.runBlock {
            let bulletEntity = scene.entityManager.findEntityFromNode(bulletNode)
            scene.entityManager.remove(bulletEntity!)
        }
        bulletNode.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updatePosition()
        if shieldBar?.size.width == 0 {
            putShieldDown()
            shieldBarEmpty = true
        }
        if shieldBar?.size.width == shieldBarWidth/2 {
            shieldBarEmpty = false
        }
    }
    
}

