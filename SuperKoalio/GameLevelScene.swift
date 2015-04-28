//
//  GameLevelScene.swift
//  SuperKoalio
//
//  Created by Chris on 4/26/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation
import SpriteKit

class GameLevelScene: SKScene {
    var map : JSTileMap?
    var player: Player?
    var previousUpdateTime: NSTimeInterval = 0.0
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor(red: 0.4, green: 0.4, blue: 0.95, alpha: 1.0)
        self.map = JSTileMap(named: "level1.tmx")
        self.addChild(self.map!)
        
        self.player = Player(imageNamed: "koalio_stand")
        self.player!.position = CGPointMake(100, 50)
        self.player!.zPosition = 15
        self.map!.addChild(self.player!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: NSTimeInterval) {
        var delta = currentTime - self.previousUpdateTime
        if delta > 0.02 {
            delta = 0.02
        }
        
        self.previousUpdateTime = currentTime
        self.player!.update(delta)
    }
    
    /*
    //1
    - (void)update:(NSTimeInterval)currentTime
    {
    //2
    NSTimeInterval delta = currentTime - self.previousUpdateTime;
    //3
    if (delta > 0.02) {
    delta = 0.02;
    }
    //4
    self.previousUpdateTime = currentTime;
    //5
    [self.player update:delta];
    }
*/
}