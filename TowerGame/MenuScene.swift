//
//  MenuScene.swift
//  TowerGame
//
//  Created by Mike Hüsing on 16.06.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene, SKPhysicsContactDelegate {
    
    var startGameButton: SKButtonNode!
    var optionsGameButton: SKButtonNode!
    var exitGameButton: SKButtonNode!
    
    
    // Update time
    var lastUpdateTimeInterval: NSTimeInterval = 0
    
    
    override func didMoveToView(view: SKView) {
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        let startGameButton = SKButtonNode(defaultButtonImage: "blue_button_up", activeButtonImage: "blue_button_down" , buttonAction: startGame)
            
        startGameButton.position = CGPoint(x: 640, y: 330)
        startGameButton.activeButton.size = CGSize(width: 360, height: 95)
        startGameButton.defaultButton.size = CGSize(width: 360, height: 95)
        startGameButton.name = "startGameButton"
        
        
        let startOptionsButton = SKButtonNode(defaultButtonImage: "blue_button_up", activeButtonImage: "blue_button_down" , buttonAction: startGame)
        
        startOptionsButton.position = CGPoint(x: 640, y: 210)
        startOptionsButton.activeButton.size = CGSize(width: 360, height: 95)
        startOptionsButton.defaultButton.size = CGSize(width: 360, height: 95)
        startOptionsButton.name = "startOptionsButton"
        
        let exitGameButton = SKButtonNode(defaultButtonImage: "blue_button_up", activeButtonImage: "blue_button_down" , buttonAction: startGame)
        
        exitGameButton.position = CGPoint(x: 640, y: 90)
        exitGameButton.activeButton.size = CGSize(width: 360, height: 95)
        exitGameButton.defaultButton.size = CGSize(width: 360, height: 95)
        exitGameButton.name = "exitGameButton"
        
        addChild(startGameButton)
        addChild(startOptionsButton)
        addChild(exitGameButton)
        
        
    }
    func exitGame() {
        
    }
    
    func startOptions(){
        
    }
    
    func startGame() {
        print("test")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        print("test2")
        if (node.name == "startGameButton") {
            let currentNode = node as! SKButtonNode
            currentNode.activeButton.hidden = false
            currentNode.defaultButton.hidden = true
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if (node.name == "startGameButton") {
            let currentNode = node as! SKButtonNode
            if currentNode.defaultButton.containsPoint(location) {
                currentNode.activeButton.hidden = false
                currentNode.defaultButton.hidden = true
            } else {
                currentNode.activeButton.hidden = true
                currentNode.defaultButton.hidden = false
            }
        }

    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        print("test3")
        if (node.name == "startGameButton") {
            let currentNode = node as! SKButtonNode
            if currentNode.defaultButton.containsPoint(location) {
                startGame()
            }
            currentNode.activeButton.hidden = true
            currentNode.defaultButton.hidden = false
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
