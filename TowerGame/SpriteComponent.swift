//
//  SpriteComponent.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    let node: SKSpriteNode
    
    init(texture: SKTexture, position: CGPoint) {
        node = SKSpriteNode(texture: texture, color: SKColor.whiteColor(), size: texture.size())
        node.position = position
    }
    
    init(spriteNode: SKSpriteNode) {
        node = spriteNode
    }
    

}
