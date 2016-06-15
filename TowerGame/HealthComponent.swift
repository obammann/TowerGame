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
    let maxHealth: CGFloat
    let barSize: CGSize
    var currentHealth: CGFloat
    var healthBar: SKSpriteNode
    let associatedObject: SKSpriteNode
    
    init(scene: GameScene, maxHealth: CGFloat, position: CGPoint, associatedObject: SKSpriteNode) {
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        self.scene = scene
        self.healthBar = SKSpriteNode()
        self.barSize = CGSize(width: associatedObject.size.width * 1.3, height: 20)
        self.associatedObject = associatedObject
        super.init()
        self.healthBar = createHealthBar(associatedObject)
        scene.addChild(healthBar)
    }
    
    func updateHealthBar() {
        
        if (currentHealth > 0) {
            self.healthBar.size = CGSize(width: associatedObject.size.width * 1.3 *
                self.currentHealth/self.maxHealth, height: 20)
        } else {
            healthBar.removeFromParent()
        }
        
    }
    
    func createHealthBar(associatedObject: SKSpriteNode) -> SKSpriteNode {
        var bar = SKSpriteNode(color: UIColor.redColor(), size: barSize)
        bar.anchorPoint = CGPointMake(0, 0.5)
        bar.position = CGPoint(x: associatedObject.position.x, y: associatedObject.position.y + associatedObject.size.height*0.8)
        bar.zPosition = 2
        return bar
    }
    
    func doDamage(damage: CGFloat) {
        currentHealth -= damage
        if currentHealth <= 0 {
            currentHealth = 0
        } else {
//            healthBar.runAction(SKAction.resizeToWidth(healthBar.size.width - damage, duration: 1))
            healthBar.size.width -= damage
        }
        updateHealthBar()
    }
    
    func updatePosition() {
        healthBar.position = CGPoint(x: associatedObject.position.x, y: associatedObject.position.y + associatedObject.size.height*0.8)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        updatePosition()
    }
    
    
    

}
