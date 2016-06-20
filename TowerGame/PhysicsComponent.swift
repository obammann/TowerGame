//
//  AIComponent.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class PhysicsComponent: GKComponent {

    let node: SKSpriteNode
    
    init(node: SKSpriteNode) {
        self.node = node
    }
    
    func setPhysicsBodyPlayer() {
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2-8)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.dynamic = true
        node.physicsBody?.categoryBitMask = Constants.PhysicsCategory.Player
        node.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.Bullet
//        node.physicsBody?.collisionBitMask = Constants.PhysicsCategory.None
    }
    
    func setPhysicsBodyBullet() {
        node.zPosition = 10
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2-3)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = Constants.PhysicsCategory.Bullet
        node.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.Player
//        node.physicsBody?.collisionBitMask = Constants.PhysicsCategory.None
        node.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func setPhysicsBodyObjects() {
//        node.zPosition = 10
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.dynamic = true
        node.physicsBody?.categoryBitMask = Constants.PhysicsCategory.Object
        node.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.Bullet
//        node.physicsBody?.collisionBitMask = Constants.PhysicsCategory.None
    }
    
    func setPhysicsBodyWall() {
        //        node.zPosition = 10
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = Constants.PhysicsCategory.Object
        node.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.Bullet
    }
    
    func setPhysicsBodyTower() {
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.dynamic = false
        node.physicsBody?.categoryBitMask = Constants.PhysicsCategory.Tower
//        node.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.Bullet
//        node.physicsBody?.collisionBitMask = Constants.PhysicsCategory.None
    }
    
    func setPhysicsBodyShield() {
        node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.dynamic = true
        node.physicsBody?.categoryBitMask = Constants.PhysicsCategory.Shield
        node.physicsBody?.contactTestBitMask = Constants.PhysicsCategory.Bullet
        //        node.physicsBody?.collisionBitMask = Constants.PhysicsCategory.None
    }
    
}
