//
//  Dalek.swift
//  Shooter
//
//  Created by Eric Internicola on 1/13/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit

class Dalek: SKSpriteNode {
    static let enemySpeed: TimeInterval = 3
    var alive = true

    init() {
        super.init(texture: SKTexture.dalek, color: .clear, size: SKTexture.dalek.size())
        configurePhysics()
        attack()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRandomPosition() {
        guard let scene = scene else {
            return
        }

        let maxX = scene.frame.maxX
        let maxY = scene.frame.maxY
        let randomX = CGFloat.random * (maxX - 2 * frame.size.width) + frame.size.width
        position = CGPoint(x: randomX, y: maxY + 300)
    }

    func explode() {
        guard let scene = scene,
            let explosionEmitterPath = Bundle.main.path(forResource: "explosion", ofType: "sks"),
            let explosion = NSKeyedUnarchiver.unarchiveObject(withFile: explosionEmitterPath) as? SKEmitterNode else
        {
            return
        }

        removeAllActions()

        explosion.position = CGPoint(x: position.x, y: position.y)
        explosion.zPosition = 1
        explosion.targetNode = scene
        scene.addChild(explosion)
        explosion.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]))
        run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
    }
}

// MARK: - PhysicsContactable

extension Dalek: PhysicsContactable {

    func handleContactWith(node: SKNode) {
        guard alive else {
            return
        }
        if let player = node as? Tardis {
            player.die()
        }
        if node is Projectile {
            alive = false
            explode()
            if let scene = scene as? GameScene {
                scene.killedEnemyFor(points: 1)
            }
        }
    }

}

// MARK: - Helpers

fileprivate extension Dalek {

    func attack() {
        let moveForward = SKAction.moveTo(y: -100, duration: Dalek.enemySpeed)
        let destroy = SKAction.removeFromParent()
        run(SKAction.sequence([moveForward, destroy]))
    }

    func configurePhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = .enemy
        physicsBody?.contactTestBitMask = .projectile
        physicsBody?.allowsRotation = false
        physicsBody?.isDynamic = true
    }
}
