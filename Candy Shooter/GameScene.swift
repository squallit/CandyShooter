//
//  GameScene.swift
//  Candy Shooter
//
//  Created by Son Luu on 5/5/15.
//  Copyright (c) 2015 luudemia. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ammoCandy : SKSpriteNode!

    let AMMO_CANDY_SPEED : CGFloat = 500.0
    let LINE_CANDY_AMOUNT : Int = 8
    let COLOR = "Color"
    
    //CategoryBitMask
    let AMMO_CANDY_CATEGORY : UInt32   = 0x1 << 0
    let EDGE_CATEGORY : UInt32         = 0x1 << 1
    let TARGET_CANDY_CATEGORY : UInt32 = 0x1 << 2
    
    //Explosion Action
    var blueExplosionAction : SKAction!
    var greenExplosionAction : SKAction!
    var redExplosionAction : SKAction!
    var pinkExplosionAction : SKAction!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //Setup PhysicWorld
        self.physicsWorld.gravity = CGVectorMake(0.0, -0.5)
        self.physicsWorld.contactDelegate = self
        
   
        //Setup background
        let background = SKSpriteNode(imageNamed: "colored_desert")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(background)
        
        //Setup Edges
        let leftEdge = SKNode()
        leftEdge.position = CGPointZero
        leftEdge.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: CGPointMake(0.0, self.size.height))
        leftEdge.physicsBody?.friction = 0.0
        leftEdge.physicsBody?.restitution = 1.0
        leftEdge.physicsBody?.categoryBitMask = EDGE_CATEGORY
        self.addChild(leftEdge)
        
        let rightEdge = SKNode()
        rightEdge.position = CGPointMake(self.size.width, 0.0)
        rightEdge.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: CGPointMake(0.0, self.size.height))
        rightEdge.physicsBody?.friction = 0.0
        rightEdge.physicsBody?.restitution = 1.0
        rightEdge.physicsBody?.categoryBitMask = EDGE_CATEGORY
        self.addChild(rightEdge)
        
        //Create ammoCandy
        self.createAmmoCandy()
        
        //Create lines of target candies
        let targetCandyAction = SKAction.sequence([SKAction.waitForDuration(2.0, withRange: 1.0), SKAction.runBlock({ self.createTargetCandy() })])
        self.runAction(SKAction.repeatActionForever(targetCandyAction))
        
        //Setup Explosion Texture
        let blueExplosionTexture : [SKTexture] = [SKTexture(imageNamed: "explosionblue01"), SKTexture(imageNamed: "explosionblue02"), SKTexture(imageNamed: "explosionblue03"), SKTexture(imageNamed: "explosionblue04"), SKTexture(imageNamed: "explosionblue05")]
        blueExplosionAction = SKAction.animateWithTextures(blueExplosionTexture, timePerFrame: 0.1, resize: true, restore: false)
        
        let greenExplosionTexture : [SKTexture] = [SKTexture(imageNamed: "explosiongreen01"), SKTexture(imageNamed: "explosiongreen02"), SKTexture(imageNamed: "explosiongreen03"), SKTexture(imageNamed: "explosiongreen04"), SKTexture(imageNamed: "explosiongreen05")]
        greenExplosionAction = SKAction.animateWithTextures(greenExplosionTexture, timePerFrame: 0.1, resize: true, restore: false)
        
        let redExplosionTexture : [SKTexture] = [SKTexture(imageNamed: "explosionred01"), SKTexture(imageNamed: "explosionred02"), SKTexture(imageNamed: "explosionred03"), SKTexture(imageNamed: "explosionred04"), SKTexture(imageNamed: "explosionred05")]
        redExplosionAction = SKAction.animateWithTextures(redExplosionTexture, timePerFrame: 0.1, resize: true, restore: false)
        
        let pinkExplosionTexture : [SKTexture] = [SKTexture(imageNamed: "explosionpink01"), SKTexture(imageNamed: "explosionpink02"), SKTexture(imageNamed: "explosionpink03"), SKTexture(imageNamed: "explosionpink04"), SKTexture(imageNamed: "explosionpink05")]
        pinkExplosionAction = SKAction.animateWithTextures(pinkExplosionTexture, timePerFrame: 0.1, resize: true, restore: false)
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

    }
    
    func createAmmoCandy () {
        //Setup ammoCandy
        ammoCandy = SKSpriteNode(imageNamed: "mm_blue")
        ammoCandy.position = CGPointMake(self.size.width / 2, 30)
        ammoCandy.physicsBody = SKPhysicsBody(circleOfRadius: ammoCandy.size.width / 2)
        ammoCandy.physicsBody?.friction = 0.0
        ammoCandy.physicsBody?.linearDamping = 0.0
        ammoCandy.physicsBody?.affectedByGravity = false
        ammoCandy.physicsBody?.categoryBitMask = AMMO_CANDY_CATEGORY
        ammoCandy.physicsBody?.contactTestBitMask = TARGET_CANDY_CATEGORY
        self.addChild(ammoCandy)
    }
    
    func createTargetCandy () {
        let targetCandy = SKSpriteNode(imageNamed: "swirl_blue")
        targetCandy.userData = [:]
        //Random a candy texture
        let randomNumber = arc4random_uniform(12)
        switch randomNumber {
            case 0: targetCandy.texture = SKTexture(imageNamed: "swirl_blue")
                    targetCandy.userData?.setValue("Blue", forKey: COLOR)
            case 1: targetCandy.texture = SKTexture(imageNamed: "swirl_green")
                    targetCandy.userData?.setValue("Green", forKey: COLOR)
            case 2: targetCandy.texture = SKTexture(imageNamed: "swirl_red")
                    targetCandy.userData?.setValue("Red", forKey: COLOR)
            case 3: targetCandy.texture = SKTexture(imageNamed: "swirl_pink")
                    targetCandy.userData?.setValue("Pink", forKey: COLOR)
            case 4: targetCandy.texture = SKTexture(imageNamed: "bean_blue")
                    targetCandy.userData?.setValue("Blue", forKey: COLOR)
            case 5: targetCandy.texture = SKTexture(imageNamed: "bean_green")
                    targetCandy.userData?.setValue("Green", forKey: COLOR)
            case 6: targetCandy.texture = SKTexture(imageNamed: "bean_red")
                    targetCandy.userData?.setValue("Red", forKey: COLOR)
            case 7: targetCandy.texture = SKTexture(imageNamed: "bean_pink")
                    targetCandy.userData?.setValue("Pink", forKey: COLOR)
            case 8: targetCandy.texture = SKTexture(imageNamed: "jelly_blue")
                    targetCandy.userData?.setValue("Blue", forKey: COLOR)
            case 9: targetCandy.texture = SKTexture(imageNamed: "jelly_green")
                    targetCandy.userData?.setValue("Green", forKey: COLOR)
            case 10: targetCandy.texture = SKTexture(imageNamed: "jelly_red")
                    targetCandy.userData?.setValue("Red", forKey: COLOR)
            default: targetCandy.texture = SKTexture(imageNamed: "jelly_pink")
                    targetCandy.userData?.setValue("Pink", forKey: COLOR)
        }
        
        //Get random X position
        targetCandy.position = CGPointMake(self.randomWithRange(targetCandy.size.width / 2, upper: self.size.width - targetCandy.size.width / 2), self.size.height + targetCandy.size.height / 2)
        targetCandy.physicsBody = SKPhysicsBody(circleOfRadius: targetCandy.size.width / 2)
        targetCandy.physicsBody?.linearDamping = 0.0
        targetCandy.physicsBody?.affectedByGravity = true
        targetCandy.physicsBody?.categoryBitMask = TARGET_CANDY_CATEGORY
        targetCandy.physicsBody?.collisionBitMask = TARGET_CANDY_CATEGORY | EDGE_CATEGORY
        self.addChild(targetCandy)
        println(targetCandy.userData?.valueForKey(COLOR))


    }
    
    func randomWithRange (lower : CGFloat, upper : CGFloat) -> CGFloat {
        //UINT32_MAX = 2,147,483,647
        return lower + (upper - lower) * (CGFloat(arc4random_uniform(UINT32_MAX)) / CGFloat(UINT32_MAX))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody!
        var secondBody : SKPhysicsBody!
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.categoryBitMask == AMMO_CANDY_CATEGORY && secondBody.categoryBitMask == TARGET_CANDY_CATEGORY) {
            self.explodeCandy(secondBody.node as! SKSpriteNode)
            firstBody.node?.removeFromParent()
            self.createAmmoCandy()
        }
    }
    
    func explodeCandy (candy : SKSpriteNode) {
        let candyExplosion : SKAction!
        switch candy.userData?.valueForKey(COLOR) as! String {
            case "Blue" :   candyExplosion = blueExplosionAction
            case "Green" :  candyExplosion = greenExplosionAction
            case "Red" :    candyExplosion = redExplosionAction
            default :       candyExplosion = pinkExplosionAction
        }
        
        candy.physicsBody?.dynamic = false
        candy.runAction(SKAction.sequence([candyExplosion, SKAction.runBlock({ () -> Void in
            candy.removeFromParent()
        })]))
    }
}
