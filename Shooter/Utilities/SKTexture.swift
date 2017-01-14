//
//  SKTexture.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit

extension SKTexture {

    /// The Tardis (player - 40x75)
    static let tardis = SKTexture(imageNamed: "tardis_40x67")

    // The Tardis (large: 341x547)
    static let tardisLarge = SKTexture(imageNamed: "tardis_341x547")

    /// The Dalek (enemy - 40x75)
    static let dalek = SKTexture(imageNamed: "dalek_40x75")

    /// Level 1 background
    static let background1 = SKTexture(imageNamed: "background-1_414x736")

    /// Level 1 background: iPad Portrait
    static let background1iPadPortrait = SKTexture(imageNamed: "background-1P_512x682")

    /// Level 1 background: iPad Landscape
    static let background1iPadLandscape = SKTexture(imageNamed: "background-1L_682x512")
}
