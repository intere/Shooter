//
//  GameScene.swift
//  Shooter
//
//  Created by Eric Internicola on 2/19/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var background: SKSpriteNode?
    var player: SKSpriteNode?
    var projectile: SKSpriteNode?
    var enemy: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var mainLabel: SKLabelNode?
    
    var fireProjectileRate = 0.2
    var projectileSpeed = 0.9
    
    var enemySpeed = 2.1
    var enemySpawnRate = 0.6
    
    var isAlive = true
    var score = 0
    var count: CGFloat = 8
    
    let textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = UIColor.blackColor()
        
        spawnBackground()
        spawnPlayer()
        spawnScoreLabel()
        spawnMainLabel()
        spawnEnemy()
        spawnProjectile()
        fireProjectile()
        randomEnemyTimerSpawn()
        updateScore()
        hideLabel()
        resetVariablesOnStart()
    }
    
    override func update(currentTime: CFTimeInterval) {
        if let player = player where !isAlive {
            player.position.x = -200
        }
    }
}

// MARK: - Touch Events

extension GameScene {
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            if let player = player where isAlive {
                player.position.x = touchLocation.x
            } else {
                player?.position.x = -200
            }
        }
    }
}

// MARK: - SKPhysicsContactDelegate Methods

extension GameScene : SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if (firstBody.categoryBitMask == PhysicsCategory.projectile && secondBody.categoryBitMask == PhysicsCategory.enemy ) || (firstBody.categoryBitMask == PhysicsCategory.enemy && secondBody.categoryBitMask == PhysicsCategory.projectile) {
            
            if let firstNode = firstBody.node as? SKSpriteNode, secondNode = secondBody.node as? SKSpriteNode {
                spawnExplosion(firstNode)
                projectileCollision(firstNode, projectileTemp: secondNode)
            }
        }
        if (firstBody.categoryBitMask == PhysicsCategory.enemy && secondBody.categoryBitMask == PhysicsCategory.player ) || (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.enemy) {
            
            if let firstNode = firstBody.node as? SKSpriteNode, secondNode = secondBody.node as? SKSpriteNode {
                enemyPlayerCollision(firstNode, playerTemp: secondNode)
            }
        }
    }

    func enemyPlayerCollision(enemyTemp: SKSpriteNode, playerTemp: SKSpriteNode) {
        runAction(SoundProvider.instance.dalekExterminate)
        if let mainLabel = mainLabel, player = player {
            mainLabel.fontSize = 50
            mainLabel.alpha = 1.0
            mainLabel.text = "Game Over"

            player.removeFromParent()
            isAlive = false
        }

        waitThenMoveToTitleScreen()
    }

    func projectileCollision(enemyTemp: SKSpriteNode, projectileTemp: SKSpriteNode) {
        enemyTemp.removeFromParent()
        projectileTemp.removeFromParent()
        score = score + 1
        updateScore()
    }
}

// MARK: - Spawning Methods
extension GameScene {
    func spawnBackground() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if view?.frame.height > view?.frame.width {
                background = SKSpriteNode(texture: TextureProvider.instance.background1iPadPortrait)
                background?.xScale = 1.2
                background?.yScale = 1.2
            } else {
                background = SKSpriteNode(texture: TextureProvider.instance.background1iPadLandscape)
                background?.xScale = 1.5
                background?.yScale = 1.5
            }
        } else {
            background = SKSpriteNode(texture: TextureProvider.instance.background1)
            background?.xScale = 1.2
            background?.yScale = 1.2
        }
        if let background = background {
            background.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
            background.zPosition = -10
            addChild(background)
        }
    }

    func spawnPlayer() {
        player = SKSpriteNode(texture: TextureProvider.instance.tardisTexture)
        if let player = player {
            player.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + 100)
            player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
            player.physicsBody?.dynamic = false

            addChild(player)
        }
    }

    func spawnEnemy() {
        guard isAlive else {
            return
        }

        enemy = SKSpriteNode(texture: TextureProvider.instance.dalekTexture)
        if let enemy = enemy {

            let maxX = CGRectGetMaxX(frame)
            let maxY = CGRectGetMaxY(frame)
            let randomX = random() * (CGRectGetMaxX(frame) - 2 * enemy.frame.size.width) + enemy.frame.size.width
            enemy.position = CGPoint(x: randomX, y: CGRectGetMaxY(frame) + 300)

            enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            enemy.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
            enemy.physicsBody?.allowsRotation = false
            enemy.physicsBody?.dynamic = true

            let moveForward = SKAction.moveToY(-100, duration: enemySpeed)
            let destroy = SKAction.removeFromParent()

            enemy.runAction(SKAction.sequence([moveForward, destroy]))

            addChild(enemy)

            print("Created Dalek at X: \(enemy.position.x) in size: \(maxX)x\(maxY)")
        }
    }

    func spawnExplosion(enemyTemp: SKSpriteNode) {
        if let explosionEmitterPath = NSBundle.mainBundle().pathForResource("explosion", ofType: "sks"), explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionEmitterPath) as? SKEmitterNode {
            explosion.position = CGPoint(x: enemyTemp.position.x, y: enemyTemp.position.y)
            explosion.zPosition = 1
            explosion.targetNode = self
            addChild(explosion)
            let explosionTimerRemove = SKAction.waitForDuration(0.5)
            let removeExplosion = SKAction.runBlock {
                explosion.removeFromParent()
            }
            runAction(SKAction.sequence([explosionTimerRemove, removeExplosion]))
        } else {
            print("ERROR: Creating explosion")
        }
    }

    func spawnScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        if let scoreLabel = scoreLabel {
            scoreLabel.fontSize = 50
            scoreLabel.fontColor = textColorHUD
            scoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: 5)
            scoreLabel.text = "Score"
            addChild(scoreLabel)
        }
    }

    func spawnMainLabel() {
        mainLabel = SKLabelNode(fontNamed: "Futura")
        if let mainLabel = mainLabel {
            mainLabel.fontSize = 100
            mainLabel.fontColor = textColorHUD
            mainLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
            mainLabel.text = "Start"

            addChild(mainLabel)
        }
    }

    func spawnProjectile() {
        projectile = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 3, height: 15))
        if let projectile = projectile, player = player {
            projectile.position = CGPoint(x: player.position.x, y: player.position.y)
            projectile.physicsBody = SKPhysicsBody(rectangleOfSize: projectile.size)
            projectile.physicsBody?.affectedByGravity = false
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
            projectile.physicsBody?.dynamic = false
            projectile.zPosition = -1

            addChild(projectile)

            let moveForward = SKAction.moveToY(CGRectGetMaxY(frame), duration: projectileSpeed)
            let destroy = SKAction.removeFromParent()

            projectile.runAction(SKAction.sequence([moveForward, destroy]))
        }
    }
}

// MARK: - Spawn Timers
extension GameScene {
    func fireProjectile() {
        let fireProjectileTimer = SKAction.waitForDuration(fireProjectileRate)
        let spawn = SKAction.runBlock {
            self.spawnProjectile()
        }
        let sequence = SKAction.sequence([fireProjectileTimer, spawn])
        runAction(SKAction.repeatActionForever(sequence))
    }

    func randomEnemyTimerSpawn() {
        let spawnEnemyTimer = SKAction.waitForDuration(enemySpawnRate)
        let spawn = SKAction.runBlock {
            self.spawnEnemy()
        }
        let sequence = SKAction.sequence([spawnEnemyTimer, spawn])
        runAction(SKAction.repeatActionForever(sequence))
    }
}


// MARK: - Helper Methods
extension GameScene {
    func waitThenMoveToTitleScreen() {
        let wait = SKAction.waitForDuration(3)
        let transition = SKAction.runBlock {
            if let view = self.view {
                if let titleScene = TitleScene(fileNamed: "TitleScene") {
                    view.ignoresSiblingOrder = true
                    titleScene.scaleMode = .AspectFill
                    view.presentScene(titleScene, transition: SKTransition.crossFadeWithDuration(1.0))
                }
            }
        }
        let sequence = SKAction.sequence([wait, transition])
        runAction(SKAction.repeatAction(sequence, count: 1))
    }
    
    func updateScore() {
        if let scoreLabel = scoreLabel {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    func hideLabel() {
        if let mainLabel = mainLabel {
            let wait = SKAction.waitForDuration(3.0)
            let hide = SKAction.runBlock {
                mainLabel.alpha = 0
            }
            let sequence = SKAction.sequence([wait, hide])
            runAction(SKAction.repeatAction(sequence, count: 1))
        }
    }
    
    func resetVariablesOnStart() {
        isAlive = true
        score = 0
    }
}

// MARK: - Structures

extension GameScene {

    struct PhysicsCategory {
        static let player = UInt32(1 << 0)
        static let enemy = UInt32(1 << 1)
        static let projectile = UInt32(1 << 2)
    }

}
