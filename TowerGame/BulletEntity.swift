//
//  BulletEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit


class BulletEntity: GKEntity {

    var bulletOriginPosition: CGPoint
    var bulletFend: Bool
    
    init(imageName: String, bulletOriginPosition: CGPoint) {
        self.bulletOriginPosition = bulletOriginPosition
        bulletFend = false

        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName), position: bulletOriginPosition)
        addComponent(spriteComponent)
        
        
        let physicsComponent = PhysicsComponent(node: (self.componentForClass(SpriteComponent.self)?.node)!)
        addComponent(physicsComponent)
        self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyBullet()
    }
    

}
