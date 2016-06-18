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
    var holdingShield = false
    let maxShieldCapacity: CGFloat
    let currentShieldCapacity: CGFloat
    
    init(node: SKSpriteNode, maxShieldCapacity: CGFloat, scene: GameScene) {
        self.scene = scene
        self.entityNode = node
        self.maxShieldCapacity = maxShieldCapacity
        self.currentShieldCapacity = maxShieldCapacity
        super.init()
        createShieldBar()

    }
    
    func createShield() {
        self.shieldNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: entityNode.size.width, height: 20))
        self.shieldNode!.zPosition = 50
        let angle = entityNode.zRotation + CGFloat(M_PI)
        self.shieldNode!.runAction(SKAction.rotateToAngle(angle, duration: 0.0))
        
        let directionX = cos(angle-CGFloat(M_PI/2))
        let directionY = sin(angle-CGFloat(M_PI/2))
        
        let offset = CGPoint(x: directionX, y: directionY)
        let direction = offset.normalized()
        shieldNode!.position = direction * 5
        self.shrinkShieldBar()
        self.scene.addChild(shieldNode!)
    }
    
    func createShieldBar() {
        let bar = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: maxShieldCapacity, height: 20))
        bar.anchorPoint = CGPointMake(0, 0.5)
        bar.position = CGPoint(x: entityNode.position.x, y: entityNode.position.y + entityNode.size.height*2.0)
        bar.zPosition = 100
        self.shieldBar = bar
        self.scene.addChild(shieldBar!)
    }
    
    func shrinkShieldBar() {
        if !holdingShield {
            holdingShield = true
            shieldBar!.runAction(SKAction.resizeToWidth(0, duration: Double(maxShieldCapacity)))
        }
    }
    
    func putShieldDown() {
        shieldBar!.removeAllActions()
        shieldNode!.removeFromParent()
        holdingShield = false
        let shieldLoadDuration = maxShieldCapacity - shieldBar!.size.width
        shieldBar!.runAction(SKAction.resizeToWidth(maxShieldCapacity, duration: Double(shieldLoadDuration)))
    }
    
    func fend(scene: GameScene, bulletNode: SKSpriteNode) {
        bulletNode.removeAllActions()
        
        let angle = entityNode.zRotation + CGFloat(M_PI)
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
    
}

