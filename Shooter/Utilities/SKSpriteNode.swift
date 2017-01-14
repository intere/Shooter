//
//  SKNode.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {

    func update(_ currentTime: TimeInterval) {
        
    }

    func gameOver() {
        removeAllActions()
        run(SKAction.fadeOut(withDuration: 2)) {
            self.removeFromParent()
        }
    }

}
