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
    
    
    
    init(joystick: AnalogJoystick, scene: GameScene) {
        self.scene = scene
        self.joystick = joystick
        super.init()
        joystick.stick.diameter = scene.size.width
        joystick.substrate.diameter = scene.size.width
        joystick.stick.color = UIColor.whiteColor()
        joystick.substrate.color = UIColor.blueColor()
        joystick.stick.alpha = 0.01
        joystick.substrate.alpha = 0.01
        joystick.position = CGPoint(x:-133, y:50)
        joystick.zPosition = 10
        scene.addChild(joystick)
        
        self.joystick.startHandler = { [unowned self] location in
            
            self.scene.player.playerWalk()
            self.joystick.stick.diameter = 100
            self.joystick.substrate.diameter = 150
            self.joystick.position = location
            self.joystick.stick.alpha = 1
            self.joystick.substrate.alpha = 1
            self.joystick.stick.color = UIColor.whiteColor()
            self.joystick.substrate.color = UIColor.blueColor()
        }
        
        
        self.joystick.trackingHandler = { [unowned self] data in
            
            let aN = scene.playerNode
            aN.position = CGPointMake(aN.position.x + (data.velocity.x * 0.05), aN.position.y + (data.velocity.y * 0.05))
            aN.zRotation = data.angular
        }
        
        self.joystick.stopHandler = { [unowned self] in
            self.joystick.stick.diameter = scene.size.width
            self.joystick.substrate.diameter = scene.size.width
            self.joystick.zPosition = 10
            self.joystick.stick.alpha = 0.01
            self.joystick.substrate.alpha = 0.01
            self.joystick.position = CGPoint(x:scene.cam.position.x - 79, y:-scene.size.height * 0.5)
            self.scene.player.playerEndAnimations()
        }
    }
    

}