//
//  JoystickEntity.swift
//  TowerGame
//
//  Created by Mike Hüsing on 14.06.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import Foundation
import GameKit


class JoystickEntity: GKEntity {
    
    
    var joystick: AnalogJoystick
    var scene: GameScene
    
    /* Initializer of the JoystickEntity gets the scene and the joystick
       sets the attributes of the joystick that it is invisible as long 
       as the user is not clicking on the screen */
    
    init(joystick: AnalogJoystick, scene: GameScene) {
        self.scene = scene
        self.joystick = joystick
        super.init()
        joystick.stick.diameter = scene.size.width
        joystick.substrate.diameter = scene.size.width
        joystick.stick.texture = SKTexture(imageNamed: "joystickUp")
        joystick.substrate.texture = SKTexture(imageNamed: "joystickDown")
        joystick.stick.alpha = 0.01
        joystick.substrate.alpha = 0.01
        joystick.zPosition = 120
        self.joystick.position = CGPoint(x:scene.cam.position.x + 500, y:-scene.size.height * 0.4)
        scene.addChild(joystick)
        
        //makes the joystick visible at the touching position 
        //and resizes it so that it is the size we want it to be
        self.joystick.startHandler = { [unowned self] location in
            
            self.joystick.stick.diameter = 100
            self.joystick.substrate.diameter = 150
            self.joystick.position = location
            self.joystick.stick.alpha = 1
            self.joystick.substrate.alpha = 1
        }
        
        //sets the player position depending on where the player pulls the joystick
        //and then creates the gas the leaves behind
        self.joystick.trackingHandler = { [unowned self] data in
            
            let aN = scene.playerNode
            aN.position = CGPointMake(aN.position.x + (data.velocity.x * 0.06), aN.position.y + (data.velocity.y * 0.06))
            aN.zRotation = data.angular
            scene.player.createGas(0.75)

        }
        
        //makes the joystick invisible again and makes it bigger so the
        //player has a bigger field to touch it
        self.joystick.stopHandler = { [unowned self] in
            self.joystick.stick.diameter = scene.size.width + 200
            self.joystick.substrate.diameter = scene.size.width + 200
            self.joystick.stick.alpha = 0.01
            self.joystick.substrate.alpha = 0.01
            self.joystick.position = CGPoint(x:scene.cam.position.x + 500, y:-scene.size.height * 0.3)
            
        }
    }
    
    //overwrites the tracking handler so that the player doesn't move when the game is lost
    func stopMovingPlayer(){
        self.joystick.trackingHandler = { data in
            
        }
    }
    

}