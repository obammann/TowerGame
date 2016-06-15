//
//  const.swift
//  TowerGame
//
//  Created by Oliver Bammann on 14.06.16.
//  Copyright © 2016 Oliver Bammann. All rights reserved.
//

import Foundation

struct Constants {
    struct PhysicsCategory {
        static let None         : UInt32 = 0
        static let All          : UInt32 = UInt32.max
        static let Player       : UInt32 = 1
        static let Projectile   : UInt32 = 2
        static let Tower        : UInt32 = 1
    }
    
    static let BulletSpeed = 5
    
    //Distance to target when the tower begins to shoot
    static let DistanceToTarget = 300
}
