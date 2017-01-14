//
//  Tardis.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit

/// This class is the Tardis (or your player)
class Tardis: SKSpriteNode {
    var alive = true

    init() {
        super.init(texture: SKTexture.tardis, color: .clear, size: SKTexture.tardis.size())
        configurePhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Handles the death of your character and delegates the game over back to the GameScene
    func die() {
        alive = false
        scene?.run(SoundProvider.instance.dalekExterminate)
        guard let gameScene = scene as? GameScene else {
            return
        }
        gameScene.gameOver()
    }
}

// MARK: - PhysicsContactable

extension Tardis: PhysicsContactable {

    /// Handles contact with other nodes
    ///
    /// - Parameter node: The other node to handle contact with
    func handleContactWith(node: SKNode) {
        if node is Dalek {
            // If we are hit by a Dalek, then we die
            die()
        }
    }
    
}

// MARK: - Helpers

fileprivate extension Tardis {

    /// Configures the Physics Body for this Sprite
    func configurePhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = .player
        physicsBody?.contactTestBitMask = .enemy
        physicsBody?.isDynamic = false
    }

}
