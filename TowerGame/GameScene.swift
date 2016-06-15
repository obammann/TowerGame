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
        

        
        entityManager.addEntityFromEditor(player)
        let position = CGPoint(x: 50, y: 50)
        for child in self.children {
            if child.name == "tank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 5, targetNode: playerNode)
                    entityManager.addEntityFromEditor(tank)
                }
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if (node.name == "attackButton") {
            for component in player.components{
                if (component is AttackComponent){
                    let comp = component as! AttackComponent
                    comp.attack()
                }
            }
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
        
        // 2
        if ((firstBody.categoryBitMask == Constants.PhysicsCategory.Player) &&
            (secondBody.categoryBitMask == Constants.PhysicsCategory.Bullet)) {
//            projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
            for entity in entityManager.entities {
                let entityNode = entity.componentForClass(SpriteComponent)?.node
                if (entityNode == firstBody.node && !player.playerInAttack) {
                    if let healthComponent = entity.componentForClass(HealthComponent) {
                        healthComponent.doDamage(1)
                        if healthComponent.currentHealth == 0 {
                            entityManager.remove(entity)
                            //lose()
                        }
                    }
                }
                if (entityNode == secondBody.node && !player.playerInAttack) {
                    if (player.playerInAttack){
                        entityNode?.setScale(2)
                    }else{
                        entityManager.remove(entity)
                    }
                    
                    
                }
            }
        }

    }
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
    }
}
