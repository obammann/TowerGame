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
    var playerNode: SKSpriteNode!
    var joystick = AnalogJoystick(diameters: (1 , 1))
    var cam = SKCameraNode()
    var camOldX: CGFloat = 0.0
    var joystickEntity: JoystickEntity!
    
    // Update time
    var lastUpdateTimeInterval: NSTimeInterval = 0
    
    
    override func didMoveToView(view: SKView) {
        
        entityManager = EntityManager(scene: self)

        playerNode = (self.childNodeWithName("player") as? SKSpriteNode)!
        player = PlayerEntity(node: playerNode, scene: self, maxHealth: 10)
        
        
        joystickEntity = JoystickEntity(joystick: joystick, scene: self)
        
        cam = self.childNodeWithName("playerCamera") as! SKCameraNode
        cam.position = playerNode.position
        camOldX = cam.position.x
        

        

        
        entityManager.addEntityFromEditor(player)
        let position = CGPoint(x: 50, y: 50)
        for child in self.children {
            if child.name == "tank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 5, playerNode: playerNode)
                    entityManager.addEntityFromEditor(tank)
                }
            }
        }
//        let bulletNode = (self.childNodeWithName("bullet") as? SKSpriteNode)!
//        var bullet = BulletEntity(bulletNode: bulletNode, targetPosition: spriteNode.position, bulletPosition: position, bulletSpeed: 10)
//        entityManager.addEntityFromEditor(bullet)
        
        

       

    }

    

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        entityManager.update(deltaTime)
        cam.position.x = playerNode.position.x
        joystick.position.x += cam.position.x - camOldX
        camOldX = cam.position.x
        
    }
    
    

}
