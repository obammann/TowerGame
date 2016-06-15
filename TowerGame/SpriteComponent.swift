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
    
    func setPhysicsBodyPlayer() {
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2-8)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = Constants.PhysicsCategory.Player
        node.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.Projectile
        node.physicsBody?.collisionBitMask = Constants.PhysicsCategory.None
    }
    
    func setPhysicsBodyBullet() {
        node.zPosition = 10
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2-3)
        node.physicsBody?.dynamic = true
        node.physicsBody?.categoryBitMask = Constants.PhysicsCategory.Projectile
        node.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.Player
        node.physicsBody?.collisionBitMask = Constants.PhysicsCategory.None
        node.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    

}
