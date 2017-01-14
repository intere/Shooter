//
//  Projectile.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit

/// Sprite for the projectile (what the Tardis shoots out)
class Projectile: SKSpriteNode {

    init(player: SKNode) {
        super.init(texture: nil, color: .green, size: CGSize(width: 3, height: 15))
        configurePhysics()
        zPosition = -1
        position = CGPoint(x: player.position.x, y: player.position.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

fileprivate extension Projectile {

    /// Configures the physics body for this node
    func configurePhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = .projectile
        physicsBody?.contactTestBitMask = .enemy
        physicsBody?.isDynamic = false
    }

}
