//
//  LevelConfig.swift
//  Shooter
//
//  Created by Eric Internicola on 1/14/17.
//  Copyright © 2017 Eric Internicola. All rights reserved.
//

import SpriteKit

class LevelConfig {

    /// The gap of time between firing
    let projectileRate: Double

    /// The speed at which the projectile moves
    let projectileSpeed = 1.0

    /// The gap of time between spawning an Enemy
    let enemySpawnRate: Double

    /// The speed multiplier for the enemy
    let enemySpeed: CGFloat

    fileprivate init(projectileRate: Double, enemySpawnRate: Double, enemySpeed: CGFloat = 1.0) {
        self.projectileRate = projectileRate
        self.enemySpawnRate = enemySpawnRate
        self.enemySpeed = enemySpeed
    }
}

// MARK: - Predefined Configurations

extension LevelConfig {

    class func start() -> LevelConfig {
        return LevelConfig(projectileRate: 0.5, enemySpawnRate: 1.5)
    }

    class func step1() -> LevelConfig {
        return LevelConfig(projectileRate: 0.4, enemySpawnRate: 1.0, enemySpeed: 1.2)
    }

    class func step2() -> LevelConfig {
        return LevelConfig(projectileRate: 0.3, enemySpawnRate: 0.75, enemySpeed: 1.5)
    }

}
