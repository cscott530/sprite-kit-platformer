//
//  Player.swift
//  SuperKoalio
//
//  Created by Chris on 4/26/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import Foundation
import SpriteKit

class Player : SKSpriteNode {
    var velocity: CGPoint
    /**
    Initialize a sprite with an image from your app bundle (An SKTexture is created for the image and set on the sprite. Its size is set to the SKTexture's pixel width/height)
    The position of the sprite is (0, 0) and the texture anchored at (0.5, 0.5), so that it is offset by half the width and half the height.
    Thus the sprite has the texture centered about the position. If you wish to have the texture anchored at a different offset set the anchorPoint to another pair of values in the interval from 0.0 up to and including 1.0.
    @param name the name or path of the image to load.
    */
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)!
        let color = UIColor.clearColor()
        let size = texture.size()
        velocity = CGPointMake(0, 0)
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(timeDelta: NSTimeInterval) {
        let delta = CGFloat(timeDelta)
        let gravity = CGPointMake(0, -450)
        let gStep = CGPointMultiplyScalar(gravity, delta)
        self.velocity = CGPointAdd(velocity, gStep)
        
        let vStep = CGPointMultiplyScalar(velocity, delta)
        self.position = CGPointAdd(self.position, vStep)
    }
    
    func collisionBoundingBox() -> CGRect {
        return CGRectInset(self.frame, 2, 0)
    }
}