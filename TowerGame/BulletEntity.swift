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

//    var positionTarget: CGPoint
//    var position: CGPoint
    
    init(imageName: String) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
    }
    
    init(imageName: String, point: CGPoint) {
        super.init()
        
        let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
        addComponent(spriteComponent)
    }
}
