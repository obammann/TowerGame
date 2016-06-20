//
//  HealthComponent.swift
//  TowerGame
//
//  Created by Oliver Bammann on 24.05.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {
    
    weak var scene: GameScene!
    let maxHealth: Int
    var currentHealth: Int
    var healthContainerSize: CGSize
    var healthContainer: [SKSpriteNode]!
    var healthBarVisible: Bool
    
    init(scene: GameScene, maxHealth: Int, healthBarVisible: Bool) {
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        self.scene = scene
        self.healthBarVisible = healthBarVisible
        healthContainer = [SKSpriteNode]()
        healthContainerSize = CGSize(width: 96, height: 54)
        
        
        if healthBarVisible {
            for i in (0) ..< self.maxHealth {
                healthContainer.append(SKSpriteNode(imageNamed: "heart"))
                healthContainer[i].zPosition = 100
                healthContainer[i].position.y = scene.cam.position.y + 570
                scene.addChild(healthContainer[i])
                
            }
            
        }else {
            
        }

        
        super.init()

    }
    
    func updateHealthBar(hearts: Float) {
        
        if (hearts < 0) {
            for _ in 0 ..< Int(hearts * -1) {
                
                healthContainer.last!.removeFromParent()
                healthContainer.removeLast()
                
            }
        } else {
            for _ in 0 ..< Int(hearts) {
                healthContainer.append(SKSpriteNode(imageNamed: "heart"))
                healthContainer[healthContainer.count].zPosition = 100
            }
            
        }
        
    }
    

    
    func doDamage(damage: Int) {
        currentHealth -= damage
        
        if currentHealth <= 0 {
            currentHealth = 0
        } else {
//            healthBar.runAction(SKAction.resizeToWidth(healthBar.size.width - damage, duration: 1))
            //healthBar.size.width -= damage
        }
        if self.healthBarVisible {
            updateHealthBar(Float(-damage))
        }
    }
    
    func updatePosition() {
        let startXPosition = scene.attackButtonNode.position.x - scene.attackButtonNode.size.width*3/4
        for i in (0) ..< healthContainer.count {
            healthContainer[i].position.x = startXPosition
                + healthContainerSize.width*CGFloat(i+1)
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updatePosition()
    }
   

}
