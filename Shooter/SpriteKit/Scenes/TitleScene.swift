//
//  TitleScene.swift
//  Shooter
//
//  Created by Eric Internicola on 2/19/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import UIKit
import SpriteKit

class TitleScene: SKScene {
    var btnPlay: UIButton?
    var gameTitle: UILabel?
    var tardisNode: SKSpriteNode?
    let textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.black
        
        spawnTardis()
        setupText()
    }
    
    // MARK: - Helper Methods
    
    func spawnTardis() {
        tardisNode = SKSpriteNode(texture: SKTexture.tardisLarge)
        if let tardisNode = tardisNode {
            tardisNode.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(tardisNode)
        }
    }
    
    func setupText() {
        if let view = view {
            btnPlay = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 100))
            if let btnPlay = btnPlay {
                btnPlay.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
                btnPlay.titleLabel?.font = UIFont(name: "Futura", size: 60)
                btnPlay.setTitle("Play!", for: UIControlState())
                btnPlay.setTitleColor(textColorHUD, for: UIControlState())
                btnPlay.addTarget(self, action: #selector(playTheGame), for: .touchUpInside)
                view.addSubview(btnPlay)
            }
            
            gameTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
            if let gameTitle = gameTitle {
                gameTitle.textColor = textColorHUD
                gameTitle.font = UIFont(name: "Futura", size: 40)
                gameTitle.textAlignment = .center
                gameTitle.text = "DALEK ATTACK"
                view.addSubview(gameTitle)
            }
        }
    }
    
    func playTheGame() {
        if let view = view {
            view.presentScene(GameScene(), transition: SKTransition.crossFade(withDuration: 1))
            tardisNode?.removeFromParent()
            btnPlay?.removeFromSuperview()
            gameTitle?.removeFromSuperview()
            
            if let gameScene = GameScene(fileNamed: "GameScene") {
                view.ignoresSiblingOrder = true
                gameScene.scaleMode = .resizeFill
                view.presentScene(gameScene)
            }
        }
        
    }
}
