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
    var playerAttackFrames : [SKTexture]!
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
        playerAttackFrames = attackFrames
        let firstFrame = playerAttackFrames[0]
    }
    
    
    func attack() {
        if !inAttack {
            inAttack = true
            let animationAction = SKAction.animateWithTextures(self.playerAttackFrames,
                                                               timePerFrame: 0.055,
                                                               resize: false,
                                                               restore: true)
            let setInAttackFalse = SKAction.runBlock {
                self.inAttack = false
            }
            entityNode.runAction(SKAction.sequence([animationAction, setInAttackFalse]))
        }
        
//        node.runAction(SKAction.animateWithTextures(self.playerAttackFrames,
//            timePerFrame: 0.055,
//            resize: false,
//            restore: true))
    }
    
    func fend(scene: GameScene, shootAngle: CGFloat) {
        //Create BulletEntity and add it to the EntityManager
        let bullet = BulletEntity(imageName: "bullet", /*targetPosition: targetNode.position,*/ bulletOriginPosition: entityNode.position)
        scene.entityManager.add(bullet)
        let bulletNode = (bullet.componentForClass(SpriteComponent.self)?.node)!
        
        //Rotate the bullet to the target's direction
        let angle = shootAngle
        
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.0)
        bulletNode.runAction(rotateAction)
        
        let velocityX = cos(angle)
        let velocityY = sin(angle)
        
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
            scene.entityManager.remove(bullet)
        }
        bulletNode.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
}

