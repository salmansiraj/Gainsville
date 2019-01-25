//
//  GameScene.swift
//  Gainsville
//
//  Created by salman siraj on 1/24/19.
//  Copyright © 2019 salman siraj. All rights reserved.

// Salad Icon made by [Roundicons] from www.flaticon.com
// Candy Icon made by [Smashicons] from www.flaticon.com
// Play Icon made by [Smashicons] from www.flaticon.com


import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var meatHead : SKSpriteNode?
    var saladTimer : Timer?
    var ground: SKSpriteNode?
    var ceiling: SKSpriteNode?
    var candyTimer : Timer?
    var yourScoreLabel : SKLabelNode?
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    let meatHeadCategory : UInt32 = 0x1 << 1
    let saladCategory : UInt32 = 0x1 << 2
    let candyCategory: UInt32 = 0x1 << 3
    let boundaryCategory: UInt32 = 0x1 << 4
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
    
        meatHead = childNode(withName: "meatHead") as? SKSpriteNode
        meatHead?.physicsBody?.categoryBitMask = meatHeadCategory
        meatHead?.physicsBody?.contactTestBitMask = saladCategory | candyCategory
        meatHead?.physicsBody?.collisionBitMask = boundaryCategory
        var meatHeadRun : [SKTexture] = []
        for number in 1...6 {
            meatHeadRun.append(SKTexture(imageNamed: "frame-\(number)"))
        }
        meatHead?.run(SKAction.repeatForever(SKAction.animate(with: meatHeadRun, timePerFrame: 0.1)))
        
        ceiling = childNode(withName: "ceiling") as? SKSpriteNode
        ceiling?.physicsBody?.categoryBitMask = boundaryCategory
        ceiling?.physicsBody?.collisionBitMask = meatHeadCategory
        
        scoreLabel = (childNode(withName: "scoreLabel") as? SKLabelNode)!
        
        startTimer()
        createGrass()
    }
    
    func createGrass() {
        let SizingGrass = SKSpriteNode.init(imageNamed: "grass")
        let numberOfGrass = Int(size.width / SizingGrass.size.width) + 1
        for number in 0...numberOfGrass {
            let grass =  SKSpriteNode(imageNamed: "grass")
            grass.physicsBody = SKPhysicsBody(rectangleOf: grass.size)
            grass.physicsBody?.categoryBitMask = boundaryCategory
            grass.physicsBody?.collisionBitMask = meatHeadCategory
            grass.physicsBody?.affectedByGravity = false
            grass.physicsBody?.isDynamic = false
            addChild(grass)
            
            let grassX = -size.width / 2 + grass.size.width / 2 + (grass.size.width * CGFloat(number))
            grass.position = CGPoint(x: grassX, y: -size.height / 2 + grass.size.height / 2 - 20)
            
            let speed : CGFloat = 100.0
            // For the grass moving effect
            let firstMoveLeft = SKAction.moveBy(x: -grass.size.width - (grass.size.width * CGFloat(number)), y: 0,
                                           duration: TimeInterval(grass.size.width + grass.size.width * CGFloat(number)) / Double(speed))
            
            let resetGrass = SKAction.moveBy(x: size.width + grass.size.width, y: 0, duration: 0)
            let fullMove = SKAction.moveBy(x: -size.width - grass.size.width, y: 0, duration: TimeInterval(size.width + grass.size.width) / Double(speed))
            let grassForever = SKAction.repeatForever(SKAction.sequence([fullMove, resetGrass]))
            
            grass.run(SKAction.sequence([firstMoveLeft, resetGrass, grassForever]))
            
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        meatHead?.physicsBody?.applyForce(CGVector(dx: 0, dy: 100000))
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let theNodes = nodes(at: location)
            
            for node in theNodes {
                if node.name == "play" {
                    // Game restarts
                    score = 0
                    node.removeFromParent()
                    yourScoreLabel?.removeFromParent()
                    scene?.isPaused = false
                    scoreLabel.text = "Score: \(score)"
                    startTimer()
                }
            }
            
            
        }
        
    }
    
    func createSalad() {
        let salad = SKSpriteNode(imageNamed: "salad")
        salad.physicsBody = SKPhysicsBody(rectangleOf: salad.size)
        salad.physicsBody?.affectedByGravity = false
        salad.physicsBody?.categoryBitMask = saladCategory
        salad.physicsBody?.contactTestBitMask = meatHeadCategory
        salad.physicsBody?.collisionBitMask = 0
        
        addChild(salad)
        
        
        
        /// Randomizes y position
        let maxY = size.height / 2 - salad.size.height / 2
        let minY = -size.height / 2 + salad.size.height / 2
        let range = maxY - minY
        let saladY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        /// Randomizes y position
        
        salad.position = CGPoint(x: (size.width / 2) + (salad.size.width / 2), y: saladY) // Starts from right side of screen
        
        let moveLeft = SKAction.moveBy(x: -size.width - salad.size.width, y: 0, duration: 4)
        
        salad.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()])) // runs an action that has a squence
            
    }
    
    func createCandy() {
        let candy = SKSpriteNode(imageNamed: "candy")
        candy.physicsBody = SKPhysicsBody(rectangleOf: candy.size)
        candy.physicsBody?.affectedByGravity = false
        candy.physicsBody?.categoryBitMask = candyCategory
        candy.physicsBody?.contactTestBitMask = meatHeadCategory
        candy.physicsBody?.collisionBitMask = 0
        addChild(candy)
        
        /// Randomizes y position
        let maxY = size.height / 2 - candy.size.height / 2
        let minY = -size.height / 2 + candy.size.height / 2
        let range = maxY - minY
        let candyY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        /// Randomizes y position
        
        candy.position = CGPoint(x: (size.width / 2) + (candy.size.width / 2), y: candyY) // Starts from right side of screen
        
        let moveLeft = SKAction.moveBy(x: -size.width - candy.size.width, y: 0, duration: 4)
        
        candy.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()])) // runs an action that has a squence
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        score += 1
        scoreLabel.text = "Score: \(score)"
        
        if contact.bodyA.categoryBitMask == saladCategory {
            contact.bodyA.node?.removeFromParent()
        }
        
        if contact.bodyB.categoryBitMask == saladCategory {
            contact.bodyB.node?.removeFromParent()
        }
        
        if contact.bodyA.categoryBitMask == candyCategory {
            dudeDied()
            contact.bodyA.node?.removeFromParent()
            gameOver()
        }
        
        if contact.bodyB.categoryBitMask == candyCategory {
            dudeDied()
            contact.bodyB.node?.removeFromParent()
            gameOver()
        }

    }
    
    func dudeDied() {
        var meatHeadDied : [SKTexture] = []
        for number in 1...2 {
            meatHeadDied.append(SKTexture(imageNamed: "die\(number)"))
        }
        meatHead?.run(SKAction.animate(with: meatHeadDied, timePerFrame: 0.4))
    }
    
    func startTimer() {
        saladTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block:
            { (timer) in
                self.createSalad()
            }
        )
        
        candyTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block:
            { (timer) in
                self.createCandy()
            }
        )
    }
    
    
    func gameOver() {
        scene?.isPaused = true
        
        yourScoreLabel = SKLabelNode(text: "Your Score: \(score)")
        yourScoreLabel?.position = CGPoint(x: 0, y: 200)
        yourScoreLabel?.fontSize = 100
        yourScoreLabel?.zPosition = 1
        addChild(yourScoreLabel!)

        
        saladTimer?.invalidate()
        candyTimer?.invalidate()
        
        let playButton = SKSpriteNode(imageNamed: "play")
        playButton.atPoint(CGPoint(x: 0, y: -200))
        playButton.name = "play"
        playButton.zPosition = 1 // To layer to the top
        addChild(playButton)
        
        
    }

}
