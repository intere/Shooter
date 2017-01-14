//
//  SKNode.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit

extension SKNode {

    func update() {
        
    }

    func gameOver() {
        removeAllActions()
        run(SKAction.fadeOut(withDuration: 2)) {
            self.removeFromParent()
        }
    }

}
