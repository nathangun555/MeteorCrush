//
//  PhysicsCategory.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

struct PhysicsCategory {
    static let None:   UInt32 = 0
    static let Rocket: UInt32 = 0x1 << 0
    static let Planet: UInt32 = 0x1 << 1
    static let Star:   UInt32 = 0x1 << 2
    static let Fuel:   UInt32 = 0x1 << 3
}
