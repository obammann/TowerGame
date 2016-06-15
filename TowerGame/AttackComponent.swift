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
    
    var player: SKSpriteNode
    var playerAttackFrames : [SKTexture]!
    
    init(player: SKSpriteNode) {
        self.player = player
        
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
    
    func attack(){
        player.runAction(SKAction.animateWithTextures(self.playerAttackFrames,
            timePerFrame: 0.08,
            resize: false,
            restore: true))
            
    }
}
