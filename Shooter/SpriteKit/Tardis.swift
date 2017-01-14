//
//  Tardis.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit

class Tardis: SKSpriteNode {

    init() {
        super.init(texture: SKTexture.tardis, color: .clear, size: SKTexture.tardis.size())
        configurePhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func die() {
        scene?.run(SoundProvider.instance.dalekExterminate)
        guard let gameScene = scene as? GameScene else {
            return
        }
        gameScene.gameOver()
    }
}

// MARK: - PhysicsContactable

extension Tardis: PhysicsContactable {

    func handleContactWith(node: SKNode) {
        if node is Dalek {
            die()
        }
    }
    
}

// MARK: - Helpers

fileprivate extension Tardis {

    func configurePhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = .player
        physicsBody?.contactTestBitMask = .enemy
        physicsBody?.isDynamic = false
    }

}
