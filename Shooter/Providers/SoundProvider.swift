//
//  SoundProvider.swift
//  Shooter
//
//  Created by Eric Internicola on 2/20/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import SpriteKit

class SoundProvider {
    static let instance = SoundProvider()
    
    /// Dalek screams "Exterminate"
    let dalekExterminate = SKAction.playSoundFileNamed("exterminate.mp3", waitForCompletion: false)
}
