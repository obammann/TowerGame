////
////  HealthComponent.swift
////  TowerGame
////
////  Created by Oliver Bammann on 24.05.16.
////  Copyright © 2016 Oliver Bammann. All rights reserved.
////
//
//import SpriteKit
//import GameplayKit
//
//class HealthComponent: GKComponent {
//    
//    weak var scene: GameScene!
//    let maxHealth: Float
//    var currentHealth: Float
//    var healthBar: SKSpriteNode
//    
//    init(scene: GameScene, maxHealth: Float, position: CGPoint, associatedObject: SKSpriteNode) {
//        self.maxHealth = maxHealth
//        self.currentHealth = maxHealth
//        self.scene = scene
//        
//        super.init()
//        self.healthBar = createHealthBar(associatedObject)
//        updateHealthBar()
//    }
//    
//    func updateHealthBar() {
//        
//        if (currentHealth > 0) {
//            healthBar.runAction(SKAction.resizeToWidth((healthBar.size.width * 1.3) * 0.5, duration: 1))
//        } else {
//            healthBar.removeFromParent()
//        }
//        
//    }
//    
//    func createHealthBar(associatedObject: SKSpriteNode) -> SKSpriteNode {
//        let barSize = CGSize(width: associatedObject.size.width * 1.3, height: 10)
//        var bar = SKSpriteNode(color: UIColor.redColor(), size: barSize)
//        bar.anchorPoint = CGPointMake(0, 0.5)
//        bar.position = CGPoint(x: associatedObject.position.x, y: associatedObject.position.y + associatedObject.size.height*0.6)
//        bar.zPosition = 1
//        return bar
////        scene.addChild(healthBar)
//    }
//    
//    func doDamage(damage: Float) {
//        currentHealth -= damage
//        if currentHealth <= 0 {
//            currentHealth = 0
//        }
//        updateHealthBar()
//    }
//    
//    
//    
//    
//    
//    
//
//}
