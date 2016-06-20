//
//  ControlComponent.swift
//  TowerGame
//
//  Created by Oliver Bammann on 25.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class AttackComponent: GKComponent {
    
    var entityNode: SKSpriteNode
    var entityAttackFrames : [SKTexture]!
    var inAttack = false
    
    init(node: SKSpriteNode) {
        self.entityNode = node
        
        let playerAnimatedAtlas = SKTextureAtlas(named: "playerKnifeAttack")
        var attackFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for i in 0 ..< numImages {
            let playerTextureName = "survivor-meleeattack_knife_\(i)"
            attackFrames.append(playerAnimatedAtlas.textureNamed(playerTextureName))
        }
        entityAttackFrames = attackFrames
        let firstFrame = entityAttackFrames[0]
    }
    
    
    func attack() {
        if !inAttack {
            inAttack = true
            let animationAction = SKAction.animateWithTextures(self.entityAttackFrames,
                                                               timePerFrame: 0.055,
                                                               resize: false,
                                                               restore: true)
            let setInAttackFalse = SKAction.runBlock {
                self.inAttack = false
            }
            entityNode.runAction(SKAction.sequence([animationAction, setInAttackFalse]))
        }
    }
    
    func fend(scene: GameScene, bulletNode: SKSpriteNode) {
        bulletNode.removeAllActions()
        let angle = entityNode.zRotation + CGFloat(M_PI)
        bulletNode.runAction(SKAction.rotateToAngle(angle, duration: 0.0))
        
        let velocityX = cos(angle-CGFloat(M_PI/2))
        let velocityY = sin(angle-CGFloat(M_PI/2))
        
        let offset = CGPoint(x: velocityX, y: velocityY)
        
        // Get the direction of where to shoot
        var direction = offset.normalized()
        
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

