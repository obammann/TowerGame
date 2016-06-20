//
//  MovementComponent.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {

    var movementFrames: [SKTexture]!
    let node: SKSpriteNode
    
    init(textureName: String, textureAtlasName: String, node: SKSpriteNode) {
        self.node = node
        
        let playerAnimatedAtlas = SKTextureAtlas(named: textureAtlasName)
        var walkFrames = [SKTexture]()
        
        let numberImages = playerAnimatedAtlas.textureNames.count
        for i in 0 ..< numberImages {
            let textureName = textureName + "\(i)"
            walkFrames.append(playerAnimatedAtlas.textureNamed(textureName))
        }
        movementFrames = walkFrames
    }
    
    func doMovement() {
        /*self.node.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(self.movementFrames,
                timePerFrame: 0.08,
                resize: false,
                restore: true)),
                withKey:"movement")*/
    }
    
}
