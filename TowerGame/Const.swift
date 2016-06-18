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
        static let Bullet       : UInt32 = 50
        static let Tower        : UInt32 = 2
        static let Object       : UInt32 = 3
        static let Wall         : UInt32 = 10
    }
    
    static let BulletSpeed = 5
    
    //Distance to target when the tower begins to shoot
    static let DistanceToTarget = 300
}
