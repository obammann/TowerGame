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
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: SKColor.whiteColor(), size: texture.size())
    }
    
    init(spriteNode: SKSpriteNode) {
        node = spriteNode
    }
    
    func setPhysicsBody() {
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
        node.physicsBody?.affectedByGravity = false
    }

}
