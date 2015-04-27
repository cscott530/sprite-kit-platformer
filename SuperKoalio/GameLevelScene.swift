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
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor(red: 0.4, green: 0.4, blue: 0.95, alpha: 1.0)
        self.map = JSTileMap(named: "level1.tmx")
        self.addChild(self.map!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}