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
    
    /// The Dalek (enemy - 40x75)
    let dalekTexture = SKTexture(imageNamed: "dalek_40x75")
}
