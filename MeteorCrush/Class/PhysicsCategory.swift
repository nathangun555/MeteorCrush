//
//  PhysicsCategory.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

struct PhysicsCategory {
    static let None:      UInt32 = 0
    static let Rocket:    UInt32 = 1 << 0
    static let Planet:    UInt32 = 1 << 1
    static let redStar:   UInt32 = 1 << 2
    static let greenStar: UInt32 = 1 << 3
    static let blueStar:  UInt32 = 1 << 4
    static let Fuel:      UInt32 = 1 << 5
    static let redGate:   UInt32 = 1 << 6
    static let greenGate: UInt32 = 1 << 7
    static let blueGate:  UInt32 = 1 << 8
    static let Meteor: UInt32 = 1 << 9
    static let gateEdge: UInt32 = 0b10000   // 16

}
