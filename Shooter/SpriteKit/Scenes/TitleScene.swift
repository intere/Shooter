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
    
    let textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        
        setupText()
    }
    
    
    // MARK: - Helper Methods
    
    func setupText() {
        if let view = view {
            btnPlay = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 100))
            if let btnPlay = btnPlay {
                btnPlay.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
                btnPlay.titleLabel?.font = UIFont(name: "Futura", size: 60)
                btnPlay.setTitle("Play!", forState: .Normal)
                btnPlay.setTitleColor(textColorHUD, forState: .Normal)
                btnPlay.addTarget(self, action: Selector("playTheGame"), forControlEvents: .TouchUpInside)
                view.addSubview(btnPlay)
            }
            
            gameTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
            if let gameTitle = gameTitle {
                gameTitle.textColor = textColorHUD
                gameTitle.font = UIFont(name: "Futura", size: 40)
                gameTitle.textAlignment = .Center
                gameTitle.text = "DALEK ATTACK"
                view.addSubview(gameTitle)
            }
        }
        
    }
    
    func playTheGame() {
        if let view = view {
            view.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(1))
            btnPlay?.removeFromSuperview()
            gameTitle?.removeFromSuperview()
            
            
            if let gameScene = GameScene(fileNamed: "GameScene") {
                view.ignoresSiblingOrder = true
                gameScene.scaleMode = .AspectFill
                view.presentScene(gameScene)
            }
        }
        
    }
}
