//
//  PlayerEntity.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit


class PlayerEntity: GKEntity {

    var node: SKSpriteNode
    var scene: GameScene
    var movementFrames: [SKTexture]!
    let group: SKAction
    var didSmoke: Bool = false
    
    init(node: SKSpriteNode, scene: GameScene, maxHealth: Int) {
        
        self.scene = scene
        self.node = node
        
        /*var actions = Array<SKAction>()
         
         actions.append(SKAction.sequence([animationWait, animationScale]))
         actions.append(SKAction.sequence([animationWait, animationAlpha]))
         
         let group = SKAction.group(actions)
         
         node.runAction(group)*/
        
        /*self.node.runAction(SKAction.repeatActionForever(
         SKAction.animateWithTextures(self.movementFrames,
         timePerFrame: 0.08,
         resize: false,
         restore: true)),
         withKey:"movement")*/
        
        let scaleAction = SKAction.scaleTo(0.25, duration: 1)

        
        let playerAnimatedAtlas = SKTextureAtlas(named: "puff")
        var walkFrames = [SKTexture]()
        
        let numberImages = playerAnimatedAtlas.textureNames.count + 10
        for i in 10 ..< numberImages {
            let textureName = "whitePuff\(i)"
            walkFrames.append(playerAnimatedAtlas.textureNamed(textureName))
        }
        movementFrames = walkFrames
        
        let textureAction = SKAction.animateWithTextures(self.movementFrames,
                timePerFrame: 0.1,
                resize: false,
                restore: true)
        
        var actions = Array<SKAction>()
        
        actions.append(scaleAction)
        actions.append(textureAction)
        
        group = SKAction.group(actions)
        
        super.init()
        
        let spriteComponent = SpriteComponent(spriteNode: node)
        addComponent(spriteComponent)
        
        let attackComponent = AttackComponent(node: self.node)
        addComponent(attackComponent)
        
        let physicsComponent = PhysicsComponent(node: node)
        addComponent(physicsComponent)
        self.componentForClass(PhysicsComponent.self)?.setPhysicsBodyPlayer()

        let healthComponent = HealthComponent(scene: scene, maxHealth: Int(maxHealth), healthBarVisible: true)
        addComponent(healthComponent)
        
        let movementComponent = MovementComponent(textureName: "whitePuff", textureAtlasName: "puff", node: self.node)
        addComponent(movementComponent)
        
        let shieldComponent = ShieldComponent(node: self.node, maxShieldCapacity: 10, scene: self.scene)
        addComponent(shieldComponent)
        
        
        
    }
    func createGas() {
        if !self.didSmoke{
            
            self.didSmoke = !self.didSmoke
            let wait = SKAction.waitForDuration(0.25)
            let run = SKAction.runBlock {
                self.didSmoke = false
            }
            self.node.runAction(SKAction.sequence([wait, run]))
            
            let gas = SKSpriteNode(imageNamed: "whitePuff10")
            gas.alpha = 0.75
            gas.zPosition = 100
            gas.setScale(0.05)
            gas.position = scene.playerNode.position
            scene.addChild(gas)
            print(gas)
            gas.runAction(SKAction.sequence([group, SKAction.removeFromParent()]))
        }
        

    }
    
    func playerWalk() {
        self.componentForClass(MovementComponent)?.doMovement()
    }
    
    func playerProtect() {
        self.componentForClass(ShieldComponent)?.createShield()
    }
    
    func playerShieldDown() {
        self.componentForClass(ShieldComponent)?.putShieldDown()
    }
    
    func attack() {
        self.componentForClass(AttackComponent)?.attack()
    }
    
    func fend(bulletNode: SKSpriteNode) {
        if ((self.componentForClass(ShieldComponent)?.holdingShield) == true) {
            self.componentForClass(ShieldComponent)?.fend(scene, bulletNode: bulletNode)
        }
    }
    

    
}
