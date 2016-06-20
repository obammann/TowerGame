//
//  GameScene.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright (c) 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var entityManager: EntityManager!
    var player: PlayerEntity!
    var playerNode: SKSpriteNode!
    var attackButtonNode: SKSpriteNode!
    var joystick = AnalogJoystick(diameters: (1 , 1))
    var cam = SKCameraNode()
    var playerOldX: CGFloat = 0.0
    var joystickEntity: JoystickEntity!
    
    
    // Update time
    var lastUpdateTimeInterval: NSTimeInterval = 0
    
    
    override func didMoveToView(view: SKView) {
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        
        SKAction.playSoundFileNamed("shot.caf", waitForCompletion: false)
        SKAction.playSoundFileNamed("playerHit.caf", waitForCompletion: false)
        SKAction.playSoundFileNamed("playerRicochet.caf", waitForCompletion: false)
        
        entityManager = EntityManager(scene: self)

        
        attackButtonNode = (self.childNodeWithName("attackButton") as? SKSpriteNode)!
        attackButtonNode.zPosition = 100
        attackButtonNode.size = CGSize(width: 150, height: 150)
        playerNode = (self.childNodeWithName("player") as? SKSpriteNode)!
        player = PlayerEntity(node: playerNode, scene: self, maxHealth: 3)
        view.showsPhysics = true
        
        
        joystickEntity = JoystickEntity(joystick: joystick, scene: self)
        
        cam = self.childNodeWithName("playerCamera") as! SKCameraNode
        
        playerOldX = playerNode.position.x
        
        print(playerNode.position)
        print(cam.position)
        

        //Add Entities to entityManager
        entityManager.addEntityFromEditor(player)
        for child in self.children {
            if child.name == "tank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 5, targetNode: playerNode)
                    entityManager.addEntityFromEditor(tank)
                }
            }
            if child.name == "box" {
                if let child = child as? SKSpriteNode {
                    let box = ObjectEntity(node: child, scene: self, maxHealth: 5, object: "box")
                    entityManager.addEntityFromEditor(box)
                }
            }
            if child.name == "border" {
                if let child = child as? SKSpriteNode {
                    let wall = ObjectEntity(node: child, scene: self, object: "wall")
                    entityManager.addEntityFromEditor(wall)
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        if (self.nodeAtPoint(location) == self.attackButtonNode) {
            player.playerProtect()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        if (self.nodeAtPoint(location) == self.attackButtonNode) {
            player.playerShieldDown()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        //Update all entities
        entityManager.update(deltaTime)
        
        //Update camera and button/joystick with player position
        if (playerNode.position.x > 300 && playerNode.position.x < 15164) {
            cam.position.x += playerNode.position.x - playerOldX
            joystick.position.x += playerNode.position.x - playerOldX
            attackButtonNode.position.x += playerNode.position.x - playerOldX
        }
        
        playerOldX = playerNode.position.x
    }
    
    func collisionAction(firstBody: SKPhysicsBody, secondBody: SKPhysicsBody) {
        if (secondBody.categoryBitMask == Constants.PhysicsCategory.Bullet) {
            if (firstBody.categoryBitMask == Constants.PhysicsCategory.Player) {
                //firstBody = Player
                //secondBody = Bullet
                let entity1 = entityManager.findEntityFromNode(firstBody.node as! SKSpriteNode) as! PlayerEntity
                if let healthComponent = entity1.componentForClass(HealthComponent) {
                    firstBody.node?.runAction(SKAction.playSoundFileNamed("playerHit.caf", waitForCompletion: false))
                    healthComponent.doDamage(1)
                    if healthComponent.currentHealth == 0 {
                        entityManager.remove(entity1)
                    }
                    let entity2 = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode) as! BulletEntity
                    entityManager.remove(entity2)
                }
            } else if (firstBody.categoryBitMask == Constants.PhysicsCategory.Shield) {
                //firstBody = Shield
                //secondBody = Bullet
                firstBody.node!.runAction(SKAction.playSoundFileNamed("playerRicochet.caf", waitForCompletion: false))
                player.fend(secondBody.node as! SKSpriteNode)
            } else if (firstBody.categoryBitMask == Constants.PhysicsCategory.Tower) {
                //firstBody = Tower
                //secondBody = Bullet
                let entity1 = entityManager.findEntityFromNode(firstBody.node as! SKSpriteNode)
                if let healthComponent = entity1!.componentForClass(HealthComponent) {
                    healthComponent.doDamage(1)
                    if healthComponent.currentHealth == 0 {
                        entityManager.remove(entity1!)
                    }
                    let entity2 = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode)
                    entityManager.remove(entity2!)
                }
            } else if (firstBody.categoryBitMask == Constants.PhysicsCategory.Wall) {
                //firstBody = Wall
                //secondBody = Bullet
                //Evtl Verhalten zwischen Wall und Bullet anpassen
                let entity = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode)
                entityManager.remove(entity!)
            } else if (firstBody.categoryBitMask == Constants.PhysicsCategory.Object) {
                //firstBody = Object
                //secondBody = Bullet
                //Evtl Verhalten zwischen Object und Bullet anpassen
                let entity1 = entityManager.findEntityFromNode(firstBody.node as! SKSpriteNode)
                if let healthComponent = entity1!.componentForClass(HealthComponent) {
                    healthComponent.doDamage(1)
                    firstBody.node?.runAction(SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 0, duration: 1))
                    if healthComponent.currentHealth == 0 {
                        entityManager.remove(entity1!)
                    }
                }
                
                let entity2 = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode)
                entityManager.remove(entity2!)
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // SecondBody = Bullet
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        collisionAction(firstBody, secondBody: secondBody)
    }
}

