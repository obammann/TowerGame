//
//  GameScene.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright (c) 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var entityManager: EntityManager!
    var player: PlayerEntity!
    var spriteNode: SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        entityManager = EntityManager(scene: self)

        player = PlayerEntity(node: (self.childNodeWithName("player") as? SKSpriteNode)!)
        let spriteNode = player.componentForClass(SpriteComponent.self)?.node
        spriteNode?.zRotation
        
        entityManager.addEntityFromEditor(player)
        
        updateCamera()
        
        
//        var healthBar = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(50, 10))
////        healthBar.anchorPoint = CGPointMake(0, 0.5)
//        let spriteNode = player.componentForClass(SpriteComponent.self)!.node
//        let point = CGPoint(x: spriteNode.position.x, y: spriteNode.position.y + spriteNode.size.height*0.6)
//        healthBar.position = point
//        healthBar.zPosition = 1
        

    }
    
    func updateCamera() {
        let playerNode = player.componentForClass(SpriteComponent.self)?.node
        if let camera = camera {
            camera.position = CGPoint(x: playerNode!.position.x, y: playerNode!.position.y)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
