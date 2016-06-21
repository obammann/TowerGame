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
    var blinkSequence: SKAction!
    var loseAction: SKAction!
    
    
    
    // Update time
    var lastUpdateTimeInterval: NSTimeInterval = 0
    
    
    override func didMoveToView(view: SKView) {
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        blinkSequence = SKAction.sequence([SKAction.fadeOutWithDuration(0.1)
            , SKAction.fadeInWithDuration(0.1)])
        
        loseAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(1)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        
        SKAction.playSoundFileNamed("shot.caf", waitForCompletion: false)
        SKAction.playSoundFileNamed("playerHit.caf", waitForCompletion: false)
        SKAction.playSoundFileNamed("playerRicochet.caf", waitForCompletion: false)
        SKAction.playSoundFileNamed("playerExplosion.caf", waitForCompletion: false)
        
        entityManager = EntityManager(scene: self)

        
        attackButtonNode = (self.childNodeWithName("attackButton") as? SKSpriteNode)!
        attackButtonNode.zPosition = 100
        attackButtonNode.size = CGSize(width: 150, height: 150)
        playerNode = (self.childNodeWithName("player") as? SKSpriteNode)!
        player = PlayerEntity(node: playerNode, scene: self, maxHealth: 3)
        player.createGas(0.01)
        
        joystickEntity = JoystickEntity(joystick: joystick, scene: self)
        
        cam = self.childNodeWithName("playerCamera") as! SKCameraNode
        
        playerOldX = playerNode.position.x

        

        //Add Entities to entityManager
        entityManager.addEntityFromEditor(player)
        for child in self.children {
            if child.name == "greenTank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 5, targetNode: playerNode, attackSpeed: 1, sideBullets: 0)
                    entityManager.addEntityFromEditor(tank)
                }
            }
            if child.name == "redTank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 5, targetNode: playerNode, attackSpeed: 1, sideBullets: 1)
                    entityManager.addEntityFromEditor(tank)
                }
            }
            if child.name == "blackTank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 5, targetNode: playerNode, attackSpeed: 1, sideBullets: 2)
                    entityManager.addEntityFromEditor(tank)
                }
            }
            if child.name == "bleigeTank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 5, targetNode: playerNode, attackSpeed: 0.5, sideBullets: 0)
                    entityManager.addEntityFromEditor(tank)
                }
            }
            if child.name == "blueTank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 5, targetNode: playerNode, attackSpeed: 0.25, sideBullets: 0)
                    entityManager.addEntityFromEditor(tank)
                }
            }
            if child.name == "rainbowTank" {
                if let child = child as? SKSpriteNode {
                    let tank = TowerEntity(node: child, scene: self, maxHealth: 15, targetNode: playerNode, attackSpeed: 0.25, sideBullets: 2)
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
        if (playerNode.position.x > 450 && playerNode.position.x < 15310) {
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
                        entity1.node.runAction(SKAction.playSoundFileNamed("playerExplosion.caf", waitForCompletion: true))
                        let playerAnimatedAtlas = SKTextureAtlas(named: "explosion")
                        var walkFrames = [SKTexture]()
                        
                        let numberImages = playerAnimatedAtlas.textureNames.count
                        for i in 0 ..< numberImages {
                            let textureName = "regularExplosion\(i)"
                            walkFrames.append(playerAnimatedAtlas.textureNamed(textureName))
                        }
                        let textureAction = SKAction.animateWithTextures(walkFrames,
                                                                         timePerFrame: 0.1,
                                                                         resize: false,
                                                                         restore: true)
                        self.joystickEntity.stopMovingPlayer()
                        entity1.node.setScale(1)
                        entity1.node.runAction(textureAction, completion: {
                            entity1.node.setScale(0)
                            entity1.node.runAction(self.loseAction)
                        })
                        
                        
                    }
                    if let entity2 = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode) as! BulletEntity?{
                        entityManager.remove(entity2)
                    }
                    
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
                        let smokeEntity = SmokeEntity(position: (secondBody.node?.position)!, sizeScale: 1, scene: self)
                        self.entityManager.add(smokeEntity)
                    }
                    if let entity2 = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode) {
                        entityManager.remove(entity2)
                    }
                    
                    let smokeEntity = SmokeEntity(position: (secondBody.node?.position)!, sizeScale: 0.4, scene: self)
                    self.entityManager.add(smokeEntity)
                }
                let smokeEntity = SmokeEntity(position: (secondBody.node?.position)!, sizeScale: 0.4, scene: self)
                self.entityManager.add(smokeEntity)
            } else if (firstBody.categoryBitMask == Constants.PhysicsCategory.Wall) {
                //firstBody = Wall
                //secondBody = Bullet
                //Evtl Verhalten zwischen Wall und Bullet anpassen
                if let entity = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode) {
                    entityManager.remove(entity)
                }
                
                //Add smoke when shooting
                let smokeEntity = SmokeEntity(position: (secondBody.node?.position)!, sizeScale: 0.4, scene: self)
                self.entityManager.add(smokeEntity)
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
                        let smokeEntity = SmokeEntity(position: (secondBody.node?.position)!, sizeScale: 0.8, scene: self)
                        self.entityManager.add(smokeEntity)
                    }
                }
                
                let entity2 = entityManager.findEntityFromNode(secondBody.node as! SKSpriteNode)
                entityManager.remove(entity2!)
                let smokeEntity = SmokeEntity(position: (secondBody.node?.position)!, sizeScale: 0.4, scene: self)
                self.entityManager.add(smokeEntity)
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
        if (firstBody.categoryBitMask != Constants.PhysicsCategory.Wall) && (secondBody.categoryBitMask == Constants.PhysicsCategory.Bullet) {
            firstBody.node?.runAction(blinkSequence)
        }
        collisionAction(firstBody, secondBody: secondBody)
    }
}

