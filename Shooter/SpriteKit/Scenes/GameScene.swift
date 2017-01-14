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
    var scoreLabel: SKLabelNode?
    var mainLabel: SKLabelNode?
    
    var fireProjectileRate = 0.2
    var projectileSpeed = 0.9
    
    var enemySpawnRate = 0.6
    
    var isAlive = true
    var score = 0
    var count: CGFloat = 8
    
    let textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = UIColor.black
        
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
    
    override func update(_ currentTime: TimeInterval) {

    }

    func gameOver() {
        showGameOver()
        guard let player = player else {
            return
        }
        player.position.x = -200
        self.player = nil
        for child in children {
            if let node = child as? SKSpriteNode {
                node.gameOver()
            }
        }
    }
}

// MARK: - Touch Events

extension GameScene {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if let player = player, isAlive {
                player.position.x = touchLocation.x
            } else {
                player?.position.x = -200
            }
        }
    }
}

// MARK: - SKPhysicsContactDelegate Methods

extension GameScene : SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else {
            return
        }

        if let contactNode = nodeA as? PhysicsContactable {
            contactNode.handleContactWith(node: nodeB)
            return
        }
        if let contactNode = nodeB as? PhysicsContactable {
            contactNode.handleContactWith(node: nodeA)
        }
    }

    func showGameOver() {
        isAlive = false
        guard let mainLabel = mainLabel else {
            return
        }

        mainLabel.fontSize = 50
        mainLabel.alpha = 1.0
        mainLabel.text = "Game Over"

        waitThenMoveToTitleScreen()
    }

    func killedEnemyFor(points: Int) {
        score += points
        updateScore()
    }
}

// MARK: - Spawning Methods
extension GameScene {

    func spawnBackground() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if view?.frame.height > view?.frame.width {
                background = SKSpriteNode(texture: SKTexture.background1iPadPortrait)
                background?.xScale = 1.2
                background?.yScale = 1.2
            } else {
                background = SKSpriteNode(texture: SKTexture.background1iPadLandscape)
                background?.xScale = 1.5
                background?.yScale = 1.5
            }
        } else {
            background = SKSpriteNode(texture: SKTexture.background1)
            background?.xScale = 1.2
            background?.yScale = 1.2
        }
        if let background = background {
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            background.zPosition = -10
            addChild(background)
        }
    }

    func spawnPlayer() {
        let player = Tardis()
        player.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        addChild(player)

        self.player = player
    }

    func spawnEnemy() {
        guard isAlive else {
            return
        }

        let enemy = Dalek()
        addChild(enemy)
        enemy.setRandomPosition()

        print("Created Dalek at \(enemy.position)")
    }

    func spawnScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        if let scoreLabel = scoreLabel {
            scoreLabel.fontSize = 50
            scoreLabel.fontColor = textColorHUD
            scoreLabel.position = CGPoint(x: frame.midX, y: 5)
            scoreLabel.text = "Score"
            addChild(scoreLabel)
        }
    }

    func spawnMainLabel() {
        mainLabel = SKLabelNode(fontNamed: "Futura")
        if let mainLabel = mainLabel {
            mainLabel.fontSize = 100
            mainLabel.fontColor = textColorHUD
            mainLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            mainLabel.text = "Start"

            addChild(mainLabel)
        }
    }

    func spawnProjectile() {
        guard let player = player else {
            return
        }
        let projectile = Projectile(player: player)
        addChild(projectile)
        let moveForward = SKAction.moveTo(y: frame.maxY, duration: projectileSpeed)
        let destroy = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([moveForward, destroy]))
    }
}

// MARK: - Spawn Timers
extension GameScene {
    
    func fireProjectile() {
        let fireProjectileTimer = SKAction.wait(forDuration: fireProjectileRate)
        let spawn = SKAction.run {
            self.spawnProjectile()
        }
        let sequence = SKAction.sequence([fireProjectileTimer, spawn])
        run(SKAction.repeatForever(sequence))
    }

    func randomEnemyTimerSpawn() {
        let spawnEnemyTimer = SKAction.wait(forDuration: enemySpawnRate)
        let spawn = SKAction.run {
            self.spawnEnemy()
        }
        let sequence = SKAction.sequence([spawnEnemyTimer, spawn])
        run(SKAction.repeatForever(sequence))
    }
}


// MARK: - Helper Methods
extension GameScene {

    func waitThenMoveToTitleScreen() {
        let wait = SKAction.wait(forDuration: 3)
        let transition = SKAction.run {
            if let view = self.view {
                if let titleScene = TitleScene(fileNamed: "TitleScene") {
                    view.ignoresSiblingOrder = true
                    titleScene.scaleMode = .aspectFill
                    view.presentScene(titleScene, transition: SKTransition.crossFade(withDuration: 1.0))
                }
            }
        }
        let sequence = SKAction.sequence([wait, transition])
        run(SKAction.repeat(sequence, count: 1))
    }
    
    func updateScore() {
        if let scoreLabel = scoreLabel {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    func hideLabel() {
        if let mainLabel = mainLabel {
            let wait = SKAction.wait(forDuration: 3.0)
            let hide = SKAction.run {
                mainLabel.alpha = 0
            }
            let sequence = SKAction.sequence([wait, hide])
            run(SKAction.repeat(sequence, count: 1))
        }
    }
    
    func resetVariablesOnStart() {
        isAlive = true
        score = 0
    }
}

