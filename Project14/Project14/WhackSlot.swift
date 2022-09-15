//
//  WhackSlot.swift
//  Project14
//
//  Created by Maksat Baiserke on 11.09.2022.
//
import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }                                        // how the objects of this method accessed
    
    func show(hideTime: Double){
        if isVisible {return}
        
        if let mud = SKEmitterNode(fileNamed: "MudBetterOne"){
            mud.position = CGPoint(x: 0, y: -20)
            mud.zPosition = 1
            addChild(mud)
        }
        
        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible {return}
        
        if let mud = SKEmitterNode(fileNamed: "MudBetterOne"){
            mud.position = CGPoint(x: 0, y: -20)
            mud.zPosition = 1
            addChild(mud)
        }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        if let smoke = SKEmitterNode(fileNamed: "Smoke"){
            smoke.position = CGPoint(x: charNode.position.x, y: charNode.position.y + 15) 
            smoke.zPosition = 1
            addChild(smoke)
        }
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run{[weak self] in self?.isVisible = false}
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
}
