//
//  GameScene.swift
//  Candy Shooter
//
//  Created by Son Luu on 5/5/15.
//  Copyright (c) 2015 luudemia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var ammoCandy : SKSpriteNode!
    var mainGamePlayer : SKNode!
    let AMMO_CANDY_SPEED : CGFloat = 500.0
    let LINE_CANDY_AMOUNT : Int = 10

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Setup PhysicWorld
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        
        //Setup world
        mainGamePlayer = SKNode()
        self.addChild(mainGamePlayer)
        
        //Setup background
        let background = SKSpriteNode(imageNamed: "colored_land")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(background)
        
        //Setup Edges
        let leftEdge = SKNode()
        leftEdge.position = CGPointZero
        leftEdge.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: CGPointMake(0.0, self.size.height))
        leftEdge.physicsBody?.friction = 0.0
        mainGamePlayer.addChild(leftEdge)
        
        let rightEdge = SKNode()
        rightEdge.position = CGPointMake(self.size.width, 0.0)
        rightEdge.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: CGPointMake(0.0, self.size.height))
        rightEdge.physicsBody?.friction = 0.0
        mainGamePlayer.addChild(rightEdge)
        
        //Create ammoCandy
        self.createAmmoCandy()
        
        //Create lines of target candies
        self.createTargetCandies()
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            let ammoCandyVector = normalizeVector(CGVectorMake(location.x - ammoCandy.position.x, location.y - ammoCandy.position.y))
            ammoCandy.physicsBody?.velocity = CGVectorMake(ammoCandyVector.dx * AMMO_CANDY_SPEED, ammoCandyVector.dy * AMMO_CANDY_SPEED)
        }
    }
    
    func normalizeVector (vector: CGVector) -> CGVector {
        let scalar : CGFloat = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
        let normalizedVector : CGVector = CGVectorMake(vector.dx / scalar, vector.dy / scalar)
        return normalizedVector
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //Remove ammoCandy if it's out of the screen
        if (ammoCandy.position.y > self.size.height + ammoCandy.size.height / 2) {
            ammoCandy.removeFromParent()
            createAmmoCandy()
        }
        
        //Move target candy lines
        self.moveTargetCandies()
    }
    
    func createAmmoCandy () {
        //Setup ammoCandy
        ammoCandy = SKSpriteNode(imageNamed: "swirl_yellow")
        //Adjust size of targetCandy
        ammoCandy.size.width = self.size.width / CGFloat(LINE_CANDY_AMOUNT)
        ammoCandy.size.height = ammoCandy.size.width
        
        //Get random texture
        let randomNumber = arc4random_uniform(4)
        switch randomNumber {
            case 0: ammoCandy.texture = SKTexture(imageNamed: "swirl_blue")
            case 1: ammoCandy.texture = SKTexture(imageNamed: "swirl_green")
            case 2: ammoCandy.texture = SKTexture(imageNamed: "swirl_orange")
            default: ammoCandy.texture = SKTexture(imageNamed: "swirl_yellow")
        }
        
        
        ammoCandy.position = CGPointMake(self.size.width / 2, 30)
        ammoCandy.physicsBody = SKPhysicsBody(circleOfRadius: ammoCandy.size.width / 2)
        ammoCandy.physicsBody?.affectedByGravity = false
        ammoCandy.physicsBody?.friction = 0.0
        ammoCandy.physicsBody?.linearDamping = 0.0
        ammoCandy.physicsBody?.restitution = 1.0
       // ammoCandy.physicsBody?.categoryBitMask =
        mainGamePlayer.addChild(ammoCandy)
    }
    
    func createTargetCandies () {
        for var index = 0; index < LINE_CANDY_AMOUNT; index++ {
            
            //Setup ammoCandy
            let targetCandy = SKSpriteNode(imageNamed: "swirl_yellow")
            //Adjust size of targetCandy
            targetCandy.size.width = self.size.width / CGFloat(LINE_CANDY_AMOUNT)
            targetCandy.size.height = targetCandy.size.width
            
            //Get random texture
            let randomNumber = arc4random_uniform(4)
            switch randomNumber {
            case 0: targetCandy.texture = SKTexture(imageNamed: "swirl_blue")
            case 1: targetCandy.texture = SKTexture(imageNamed: "swirl_green")
            case 2: targetCandy.texture = SKTexture(imageNamed: "swirl_orange")
            default: targetCandy.texture = SKTexture(imageNamed: "swirl_yellow")
            }
            
            targetCandy.name = "TargetCandy"
            targetCandy.position = CGPointMake(CGFloat(index) * targetCandy.size.width + targetCandy.size.width / 2, self.size.height + targetCandy.size.height / 2)
            
            targetCandy.physicsBody = SKPhysicsBody(circleOfRadius: ammoCandy.size.width / 2)
            targetCandy.physicsBody?.friction = 0.0
            targetCandy.physicsBody?.linearDamping = 0.0
            targetCandy.physicsBody?.restitution = 1.0
            targetCandy.physicsBody?.dynamic = false
            mainGamePlayer.addChild(targetCandy)
            
        }
    }
    
    func moveTargetCandies ()
    {
        mainGamePlayer.enumerateChildNodesWithName("TargetCandy", usingBlock: { (node, stop) -> Void in
            let moveDownAction : SKAction = SKAction.moveBy(CGVectorMake(0.0, -1.0), duration: 3.0)
            node.runAction(moveDownAction)
        })
    }
}
