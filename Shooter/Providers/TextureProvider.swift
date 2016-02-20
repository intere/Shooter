//
//  TextureProvider.swift
//  Shooter
//
//  Created by Eric Internicola on 2/19/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import SpriteKit

class TextureProvider {
    static let instance = TextureProvider()
    
    /// The Tardis (player - 40x75)
    let tardisTexture = SKTexture(imageNamed: "tardis_40x67")
    
    // The Tardis (large: 341x547)
    let tardisLargeTexture = SKTexture(imageNamed: "tardis_341x547")
    
    /// The Dalek (enemy - 40x75)
    let dalekTexture = SKTexture(imageNamed: "dalek_40x75")
    
    /// Level 1 background
    let background1 = SKTexture(imageNamed: "background-1_414x736")
    
    /// Level 1 background: iPad Portrait
    let background1iPadPortrait = SKTexture(imageNamed: "background-1P_512x682")
    
    /// Level 1 background: iPad Landscape
    let background1iPadLandscape = SKTexture(imageNamed: "background-1L_682x512")
}
