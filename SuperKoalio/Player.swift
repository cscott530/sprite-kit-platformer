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
    var desiredPosition: CGPoint
    var onGround: Bool
    var moving = false
    var jumping = false
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
        desiredPosition = CGPointMake(0, 0)
        onGround = true
        super.init(texture: texture, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(timeDelta: NSTimeInterval) {
        let delta = CGFloat(timeDelta)
        let gravity = CGPointMake(0, -450)
        let gStep = CGPointMultiplyScalar(gravity, delta)
        
        let forwardMove = CGPointMake(800, 0)
        let forwardStep = CGPointMultiplyScalar(forwardMove, delta)
        
        self.velocity = CGPointAdd(velocity, gStep)
        self.velocity = CGPointMake(self.velocity.x * 0.9, self.velocity.y)
        
        let jumpForce = CGPointMake(0, 310)
        let jumpCutoff = CGFloat(150)
        if self.jumping && self.onGround {
            self.velocity = CGPointAdd(self.velocity, jumpForce)
        } else if !self.jumping && self.velocity.y > jumpCutoff {
            self.velocity = CGPointMake(self.velocity.x, jumpCutoff)
        }
        if self.moving {
            self.velocity = CGPointAdd(self.velocity, forwardStep)
        }
        
        let minMove = CGPointMake(0, -450)
        let maxMove = CGPointMake(120, 250)
        self.velocity = CGPointMake(Clamp(self.velocity.x, minMove.x, maxMove.x), Clamp(self.velocity.y, minMove.y, maxMove.y))
        let vStep = CGPointMultiplyScalar(velocity, delta)
        self.desiredPosition = CGPointAdd(self.position, vStep)
    }
    
    func collisionBoundingBox() -> CGRect {
        let box = CGRectInset(self.frame, 2, 0)
        let diff = CGPointSubtract(self.desiredPosition, self.position)
        return CGRectOffset(box, diff.x, diff.y)
    }
}