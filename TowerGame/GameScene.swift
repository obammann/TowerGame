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
        
        entityManager = EntityManager(scene: self)

        attackButtonNode = (self.childNodeWithName("attackButton") as? SKSpriteNode)!
        attackButtonNode.zPosition = 100
        attackButtonNode.size = CGSize(width: 150, height: 150)
        playerNode = (self.childNodeWithName("player") as? SKSpriteNode)!
        player = PlayerEntity(node: playerNode, scene: self, maxHealth: 10)
        view.showsPhysics = true
        
        
        joystickEntity = JoystickEntity(joystick: joystick, scene: self)
        
        cam = self.childNodeWithName("playerCamera") as! SKCameraNode
        cam.position = playerNode.position
        cam.position.x += 47
        playerOldX = playerNode.position.x
        

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
                    let box = ObjectEntity(node: child, scene: self, maxHealth: 2)
                    entityManager.addEntityFromEditor(box)
                }
            }
            if child.name == "border" {
                if let child = child as? SKSpriteNode {
                    let wall = ObjectEntity(node: child, scene: self)
                    entityManager.addEntityFromEditor(wall)
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if (node.name! == "attackButton") {
            player.playerProtect()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if (node.name! == "attackButton") {
            player.playerShieldDown()
//            for component in player.components{
//                if (component is AttackComponent){
//                    let comp = component as! AttackComponent
//                    self.player.setPlayerAttack(true)
//                    comp.attack()
//                }
//            }
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        //Update all entities
        entityManager.update(deltaTime)
        
        //Update camera and button/joystick with player position
        if (playerNode.position.x > 200 && playerNode.position.x < 1065) {
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
                
                            let entity1 = entityManager.findEntityFromNode(firstBody.node as! SKSpriteNode)
                            if let healthComponent = entity1!.componentForClass(HealthComponent) {
                                healthComponent.doDamage(1)
                                if healthComponent.currentHealth == 0 {
                                    entityManager.remove(entity1!)
                                }
                            }
                let entity2 = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode) as! BulletEntity
                //            entityManager.remove(entity2!)
//                let entity1 = entityManager.findEntityFromNode(firstBody.node as! SKSpriteNode) as! PlayerEntity
                if (entity1!.componentForClass(AttackComponent)?.inAttack == true) {
                    //                entity2.turnFromPlayer(secondBody.node as! SKSpriteNode, player: playerNode)
                    player.fend(secondBody.node as! SKSpriteNode)
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

