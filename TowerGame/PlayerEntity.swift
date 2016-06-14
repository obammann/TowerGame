//
//  PlayerEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit


class PlayerEntity: GKEntity {

    var player: SKSpriteNode
    var scene: GameScene
    var playerWalkingFrames : [SKTexture]!
    
    init(node: SKSpriteNode, scene: GameScene, maxHealth: CGFloat) {
        
        self.scene = scene
        self.player = node
        
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        self.componentForClass(SpriteComponent.self)?.setPhysicsBody()
        
        let healthComponent = HealthComponent(scene: scene, maxHealth: maxHealth, position: node.position, associatedObject: node)
        addComponent(healthComponent)
        
//        let playerAnimatedAtlas = SKTextureAtlas(named: "player")
//        var walkFrames = [SKTexture]()
//        
//        let numImages = playerAnimatedAtlas.textureNames.count
//        for i in 0 ..< numImages {
//            let playerTextureName = "character\(i)"
//            walkFrames.append(playerAnimatedAtlas.textureNamed(playerTextureName))
//        }
//        playerWalkingFrames = walkFrames
//        let firstFrame = playerWalkingFrames[0]
        
        let playerAnimatedAtlas = SKTextureAtlas(named: "player2")
        var walkFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for i in 0 ..< numImages {
            let playerTextureName = "survivor-move_knife_\(i)"
            walkFrames.append(playerAnimatedAtlas.textureNamed(playerTextureName))
        }
        playerWalkingFrames = walkFrames
        let firstFrame = playerWalkingFrames[0]
        
        
    }

    
    func playerWalk() {
        self.player.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(self.playerWalkingFrames,
                timePerFrame: 0.12,
                resize: false,
                restore: true)),
                                        withKey:"walkingInPlacePlayer")
    }
    
    func playerEndAnimations() {
        self.player.removeAllActions()
    }
}
