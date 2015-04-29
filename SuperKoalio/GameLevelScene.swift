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
    var map : JSTileMap
    var player: Player
    var previousUpdateTime: NSTimeInterval = 0.0
    var walls: TMXLayer
    override init(size: CGSize) {
        self.map = JSTileMap(named: "level1.tmx")
        self.player = Player(imageNamed: "koalio_stand")
        self.walls = map.layerNamed("walls")
        super.init(size: size)
        
        self.backgroundColor = SKColor(red: 0.4, green: 0.4, blue: 0.95, alpha: 1.0)
        self.addChild(self.map)
        
        self.player.position = CGPointMake(100, 50)
        self.player.zPosition = 15
        self.map.addChild(self.player)
        
        self.userInteractionEnabled = true
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
        self.player.update(delta)
        
        self.checkForAndResolveCollisionsForPlayer(player, layer: walls)
        self.setViewpointCenter(self.player.position)
    }

    func tileRectFromTileCoords(coords: CGPoint) -> CGRect {
        let levelHeight = self.map.mapSize.height * self.map.tileSize.height
        let origin = CGPointMake(coords.x * self.map.tileSize.width, levelHeight - ((coords.y + 1) * (self.map.tileSize.height)))
        return CGRectMake(origin.x, origin.y, self.map.tileSize.width, self.map.tileSize.height)
    }
    
    func tileGIDAtCoordinate(coord: CGPoint, layer: TMXLayer) -> Int {
        let info = layer.layerInfo
        return info.tileGidAtCoord(coord)
    }
    
    func checkForAndResolveCollisionsForPlayer(player: Player, layer: TMXLayer) {
        player.onGround = false
        for index in [7, 1, 3, 5, 0, 2, 6, 8] {
            let playerBox = player.collisionBoundingBox()
            let playerCoord = layer.coordForPoint(player.desiredPosition)
            
            let column = index % 3
            let row = index / 3
            let tileCoord = CGPointMake(playerCoord.x + CGFloat(column - 1), playerCoord.y + CGFloat(row - 1))
            let gid = self.tileGIDAtCoordinate(tileCoord, layer: layer)
            if (gid > 0) {
                let tileRect = self.tileRectFromTileCoords(tileCoord)                
                
                if (CGRectIntersectsRect(playerBox, tileRect)) {
                    let intersection = CGRectIntersection(playerBox, tileRect).size
                    switch(index) {
                    case 7:
                        player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y + intersection.height)
                        player.velocity = CGPointMake(player.velocity.x, 0.0)
                        player.onGround = true
                    case 1:
                        player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y - intersection.height)
                    case 3:
                        player.desiredPosition = CGPointMake(player.desiredPosition.x + intersection.width, player.desiredPosition.y)
                    case 5:
                        player.desiredPosition = CGPointMake(player.desiredPosition.x - intersection.width, player.desiredPosition.y)
                    default:
                        if (intersection.width > intersection.height) {
                            player.velocity = CGPointMake(player.velocity.x, 0.0)
                            var height = intersection.height
                            if index > 4 {
                                player.onGround = true
                            } else {
                                height *= -1
                            }
                            player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y + height)
                        } else {
                            let width = index == 6 || index == 0 ? intersection.width : -intersection.width
                            player.desiredPosition = CGPointMake(player.desiredPosition.x  + width, player.desiredPosition.y)
                        }
                    }
                    
                }
            }
        }
        player.position = player.desiredPosition
    }
    
    func setViewpointCenter(center: CGPoint) {
        var x = max(center.x, self.size.width / 2)
        var y = max(center.y, self.size.height / 2)
        
        x = min(x, (self.map.mapSize.width * self.map.tileSize.width) - self.size.width / 2)
        y = min(y, (self.map.mapSize.height * self.map.tileSize.height) - self.size.height / 2)
        
        let position = CGPointMake(x, y)
        let center = CGPointMake(self.size.width / 2, self.size.height / 2)
        let viewPoint = CGPointSubtract(center, position)
        self.map.position = viewPoint
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touchObject in touches {
            let touch = touchObject as! UITouch
            let location = touch.locationInNode(self)
            if location.x < self.size.width / 2 {
                self.player.moving = true
            } else {
                self.player.jumping = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var halfWidth = self.size.width / 2.0
        for touchObject in touches {
            let touch = touchObject as! UITouch
            let location = touch.locationInNode(self)
            
            let previousLocation = touch.previousLocationInNode(self)
            if location.x > halfWidth && previousLocation.x <= halfWidth {
                self.player.moving = false
                self.player.jumping = true
            } else if previousLocation.x > halfWidth && location.x <= halfWidth {
                self.player.moving = true
                self.player.jumping = false
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touchObject in touches {
            let touch = touchObject as! UITouch
            let location = touch.locationInNode(self)
            if location.x < self.size.width / 2.0 {
                self.player.moving = false
            } else {
                self.player.jumping = false
            }
        }
    }
}