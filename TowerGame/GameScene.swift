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
    var spriteNode: SKSpriteNode!
    var joystick = AnalogJoystick(diameters: (1 , 1))
    
    override func didMoveToView(view: SKView) {
        entityManager = EntityManager(scene: self)

        player = PlayerEntity(node: (self.childNodeWithName("player") as? SKSpriteNode)!)
        spriteNode = player.componentForClass(SpriteComponent.self)!.node
        
        
        entityManager.addEntityFromEditor(player)
        
        updateCamera()
        
        
        
        joystick.stick.diameter = size.width
        joystick.substrate.diameter = size.width
        joystick.stick.color = UIColor.whiteColor()
        joystick.substrate.color = UIColor.blueColor()
        self.joystick.stick.alpha = 0.01
        self.joystick.substrate.alpha = 0.01
        joystick.position = CGPoint(x:0, y:0)
        joystick.zPosition = 10
        addChild(joystick)
        
        joystick.startHandler = { [unowned self] location in
            
            self.joystick.stick.diameter = 100
            self.joystick.substrate.diameter = 150
            self.joystick.position = location
            self.joystick.stick.alpha = 1
            self.joystick.substrate.alpha = 1
            self.joystick.stick.color = UIColor.whiteColor()
            self.joystick.substrate.color = UIColor.blueColor()
        }
        
        
        joystick.trackingHandler = { [unowned self] data in
            
            let aN = self.spriteNode
            aN.position = CGPointMake(aN.position.x + (data.velocity.x * 0.12), aN.position.y + (data.velocity.y * 0.12))
            aN.zRotation = data.angular
        }
        
        joystick.stopHandler = { [unowned self] in
            self.joystick.stick.diameter = self.size.width
            self.joystick.substrate.diameter = self.size.width
            self.joystick.zPosition = -1
            self.joystick.stick.alpha = 0.01
            self.joystick.substrate.alpha = 0.01
            self.joystick.position = CGPoint(x:0, y:-self.size.height * 0.5)
        }
        
        
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
