//
//  MenuScene.swift
//  TowerGame
//
//  Created by Mike Hüsing on 16.06.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate {
    
    var startGameButton: SKSpriteNode!
    var optionsGameButton: SKSpriteNode!
    var exitGameButton: SKSpriteNode!
    
    
    // Update time
    var lastUpdateTimeInterval: NSTimeInterval = 0
    
    
    override func didMoveToView(view: SKView) {
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 640, y: 330),
                                size: CGSize(width: 360, height: 95)))
        let imageButton = UIImage(named: "blue_button")
        button.setImage(imageButton, forState: UIControlState.Normal)
        
        
        self.view?.addSubview(button)
        
        //startGameButton = (self.childNodeWithName("attackButton") as? SKSpriteNode)!
        //startGameButton.zPosition = 100
        //startGameButton.size = CGSize(width: 150, height: 150)
        
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if (node.name == "startButtonNode") {
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
    }
    
}
