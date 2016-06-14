//
//  GameScene.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright (c) 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var playerWalkingFrames : [SKTexture]!
    var entityManager: EntityManager!
    var player: PlayerEntity!
    var playerNode: SKSpriteNode!
    var joystick = AnalogJoystick(diameters: (1 , 1))
    var cam = SKCameraNode()
    var camOldX: CGFloat = 0.0
    
    // Update time
    var lastUpdateTimeInterval: NSTimeInterval = 0
    
    
    override func didMoveToView(view: SKView) {
        
        entityManager = EntityManager(scene: self)

        playerNode = (self.childNodeWithName("player") as? SKSpriteNode)!
        player = PlayerEntity(node: playerNode, scene: self, maxHealth: 10)
        
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
        
        
        initJoystick()
        
        cam = self.childNodeWithName("playerCamera") as! SKCameraNode
        cam.position = spriteNode.position
        camOldX = cam.position.x
        
        let playerAnimatedAtlas = SKTextureAtlas(named: "player")
        var walkFrames = [SKTexture]()
        
        let numImages = playerAnimatedAtlas.textureNames.count
        for var i=0; i<numImages; i+=1 {
            let bearTextureName = "character\(i)"
            walkFrames.append(playerAnimatedAtlas.textureNamed(bearTextureName))
        }
        playerWalkingFrames = walkFrames
        let firstFrame = playerWalkingFrames[0]
       

    }
    func playerMoveEnded() {
        playerNode.removeAllActions()
    }
    
    func walkingPlayer() {
        //This is our general runAction method to make our bear walk.
        playerNode.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(playerWalkingFrames,
                timePerFrame: 0.12,
                resize: false,
                restore: true)),
                       withKey:"walkingInPlacePlayer")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        entityManager.update(deltaTime)
        cam.position.x = spriteNode.position.x
        joystick.position.x += cam.position.x - camOldX
        camOldX = cam.position.x
        
    }
    
    
    func initJoystick() {
        
        joystick.stick.diameter = size.width
        joystick.substrate.diameter = size.width
        joystick.stick.color = UIColor.whiteColor()
        joystick.substrate.color = UIColor.blueColor()
        joystick.stick.alpha = 0.01
        joystick.substrate.alpha = 0.01
        joystick.position = CGPoint(x:-133, y:50)
        joystick.zPosition = 10
        addChild(joystick)
        
        joystick.startHandler = { [unowned self] location in
            
            self.walkingPlayer()
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
            aN.position = CGPointMake(aN.position.x + (data.velocity.x * 0.15), aN.position.y + (data.velocity.y * 0.15))
            aN.zRotation = data.angular
        }
        
        joystick.stopHandler = { [unowned self] in
            self.joystick.stick.diameter = self.size.width
            self.joystick.substrate.diameter = self.size.width
            self.joystick.zPosition = 10
            self.joystick.stick.alpha = 0.01
            self.joystick.substrate.alpha = 0.01
            self.joystick.position = CGPoint(x:self.cam.position.x - 79, y:-self.size.height * 0.5)
            self.playerMoveEnded()
        }
    }
}
