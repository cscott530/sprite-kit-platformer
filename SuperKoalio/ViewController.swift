//
//  ViewController.swift
//  SuperKoalio
//
//  Created by Chris on 4/26/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation
import SpriteKit
class ViewController: UIViewController {
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let view = self.view as! SKView
        view.showsFPS = true
        view.showsNodeCount = true
        
        let scene = GameLevelScene(size: view.bounds.size)
        scene.scaleMode = .AspectFill
        
        view.presentScene(scene)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }
}