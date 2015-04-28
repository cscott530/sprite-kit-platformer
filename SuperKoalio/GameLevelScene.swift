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
    }

    func tileRectFromTileCoords(coords: CGPoint) -> CGRect {
        let levelHeight = self.map.frame.size.height * self.map.tileSize.height
        let origin = CGPointMake(coords.x * self.map.tileSize.width, levelHeight - ((coords.y + 1) * (self.map.tileSize.height)))
        return CGRectMake(origin.x, origin.y, self.map.tileSize.width, self.map.tileSize.height)
    }
    
    func tileGIDAtCoordinate(coord: CGPoint, layer: TMXLayer) -> Int {
        let info = layer.layerInfo
        return info.tileGidAtCoord(coord)
    }
    
    func checkForAndResolveCollisionsForPlayer(player: Player, layer: TMXLayer) {
        let indices = [7, 1, 3, 5, 0, 2, 6, 8]
        for index in indices {
            let playerBox = player.collisionBoundingBox()
            let playerCoord = layer.coordForPoint(player.desiredPosition)
            
            let column = index % 3
            let row = index / 3
            let tileCoord = CGPointMake(playerCoord.x + CGFloat(column - 1), playerCoord.y + CGFloat(row - 1))
            let gid = self.tileGIDAtCoordinate(tileCoord, layer: layer)
            if (gid > 0) {
                println("GID \(gid), Coord \(tileCoord), Rect: \(playerBox)")
            }
        }
    }
    
    /*
    - (void)checkForAndResolveCollisionsForPlayer:(Player *)player forLayer:(TMXLayer *)layer {
    //1
    NSInteger indices[8] = {7, 1, 3, 5, 0, 2, 6, 8};
    for (NSUInteger i = 0; i < 8; i++) {
    NSInteger tileIndex = indices[i];
    
    //2
    CGRect playerRect = [player collisionBoundingBox];
    //3
    CGPoint playerCoord = [layer coordForPoint:player.position];
    //4
    NSInteger tileColumn = tileIndex % 3;
    NSInteger tileRow = tileIndex / 3;
    CGPoint tileCoord = CGPointMake(playerCoord.x + (tileColumn - 1), playerCoord.y + (tileRow - 1));
    //5
    NSInteger gid = [self tileGIDAtTileCoord:tileCoord forLayer:layer];
    //6
    if (gid) {
    //7
    CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
    //8
    NSLog(@"GID %ld, Tile Coord %@, Tile Rect %@, player rect %@", (long)gid, NSStringFromCGPoint(tileCoord), NSStringFromCGRect(tileRect), NSStringFromCGRect(playerRect));
    //collision resolution goes here
    }
    
    }
    }
*/
}