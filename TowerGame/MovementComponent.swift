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

    
    let node: SKSpriteNode
    
    init(textureName: String, textureAtlasName: String, node: SKSpriteNode) {
        self.node = node
        let scale = self.node.xScale
        self.node.runAction(SKAction.repeatActionForever(
        SKAction.sequence([SKAction.scaleTo(scale*1.05, duration: 0.1),
            SKAction.scaleTo(scale, duration: 0.1)])))
        

    }
    
    func doMovement() {
        
    }
    
    
}
