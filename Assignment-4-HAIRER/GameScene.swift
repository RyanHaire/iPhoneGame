//
//  GameScene.swift
//  W8P2SpriteKit
//
//  Created by Jawaad Sheikh on 2021-10-12.
//

import SpriteKit
import GameplayKit

// step 7 - add Physics categories struct
struct PhysicsCategory{
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Baddy : UInt32 = 0b1 // 1
    static let Hero : UInt32 = 0b10 // 2
    // future expansion - dunno if we'll make it here
    static let Projectile : UInt32 = 0b11 // 3
}

// step 6 - add collision detection delegate
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    //private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // step 1 define our background & hero
    var background = SKSpriteNode(imageNamed: "background.jpeg")
    private var sportNode : SKSpriteNode?
    
    // step 11 - add score
    private var score : Int?
    let scoreIncrement = 10
    private var lblScore = SKLabelNode()
    private var lblTitle = SKLabelNode()
    private var lblTime = SKLabelNode()
    private var time = 2000
    
    func initLabels()
    {
        lblScore.name = "lblScore"
        lblScore.text = "Score: "
        lblScore.fontSize = 64
        lblScore.fontColor = UIColor.white
        lblScore.position = CGPoint(x: 200, y: 200)
        lblScore.zPosition = 11
        self.addChild(lblScore)
        
        lblTitle.name = "lblTitle"
        lblTitle.text = "Food Collector"
        lblTitle.fontSize = 64
        lblTitle.fontColor = UIColor.white
        lblTitle.position = CGPoint(x: 500, y: 500)
        lblTitle.zPosition = 11
        self.addChild(lblTitle)
        
        lblTime.name = "lblTime"
        lblTime.text = "2000"
        lblTime.fontSize = 64
        lblTime.fontColor = UIColor.white
        lblTime.position = CGPoint(x: 900, y: 500)
        lblTime.zPosition = 11
        self.addChild(lblTime)
    }
    
    override func didMove(to view: SKView) {
        
        initLabels()
        
        // step 2a - add background first and fade it
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.alpha = 0.3
        addChild(background)
        // end step 2aImages
        
        // Get label node from scene and store it for use later
     //   self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
       
            lblTitle.alpha = 0.0
            lblTitle.run(SKAction.fadeIn(withDuration: 2.0))
        
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        // step 2b - initialize our hero node - the jays
        sportNode = SKSpriteNode(imageNamed: "basket-sprite.jpg")
        sportNode?.size.width = 50
        sportNode?.size.height = 50
        sportNode?.position = CGPoint(x: 100, y: 100)
        addChild(sportNode!)
        // end step 2b
        
        // step 8 - add physics to our hero
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        physicsWorld.contactDelegate = self
        // end step 8
        
        // step 9b - add collision detection to our hero
        sportNode?.physicsBody = SKPhysicsBody(circleOfRadius: (sportNode?.size.width)!/2)
        sportNode?.physicsBody?.isDynamic = true
        sportNode?.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        sportNode?.physicsBody?.contactTestBitMask = PhysicsCategory.Baddy
        sportNode?.physicsBody?.collisionBitMask = PhysicsCategory.None
        sportNode?.physicsBody?.usesPreciseCollisionDetection = true
        
        // end step 9b
        
        // step 4 - bringing in the baddies
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBaddy), SKAction.wait(forDuration: 0.5)])))
        
        // step 11b - init score
        score = 0
        self.lblScore.text = "Score: \(score!)"
       
            lblScore.alpha = 0.0
            lblScore.run(SKAction.fadeIn(withDuration: 2.0))
        
        
    }
    
    // step 3 - adding bad guy leafs
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min:CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
    
    func addBaddy(){
        
        let baddy = SKSpriteNode(imageNamed: "hotdog-sprite.png")
        baddy.name = "baddy"
        baddy.size.width = 50
        baddy.size.height = 50
        baddy.xScale = baddy.xScale * -1
        
        let actualY = random(min: baddy.size.height/2, max: size.height-baddy.size.height/2)
        
        baddy.position = CGPoint(x: size.width + baddy.size.width/2, y:actualY)
        
        addChild(baddy)
        
        // step 9 - add physics to our baddy
        baddy.physicsBody = SKPhysicsBody(rectangleOf: baddy.size)
        baddy.physicsBody?.isDynamic = true
        baddy.physicsBody?.categoryBitMask = PhysicsCategory.Baddy
        baddy.physicsBody?.contactTestBitMask = PhysicsCategory.Hero
        baddy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // end step 9
        
        let actualDuration = random(min: CGFloat(4.0), max:CGFloat(6.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -baddy.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        baddy.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // step 10 delegete methods for physics
    // heroDidCollideWithBaddy()
    // didBegin()
    
    func heroDidCollideWithBaddy(hero: SKSpriteNode, baddy: SKSpriteNode){
        print("hit")
        
        // step 11c - update score
        score = score! + scoreIncrement
        self.lblScore.text = "Score: \(score!)"
        
        lblScore.alpha = 0.0
        lblScore.run(SKAction.fadeIn(withDuration: 2.0))
        
        baddy.removeFromParent()
        // need to come up with something
        // maybe have baddy grow?
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.Baddy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Hero != 0)){
            heroDidCollideWithBaddy(hero: firstBody.node as! SKSpriteNode, baddy: secondBody.node as! SKSpriteNode)
        }
    }
    // end step 10
    
    // step 5 - now lets move our hero
    func moveGoodGuy(toPoint pos : CGPoint){
        let actionMove = SKAction.move(to: pos, duration: TimeInterval(2.0))
        let actionMoveDone = SKAction.rotate(byAngle: CGFloat(360.0), duration: TimeInterval(1.0))
        sportNode?.run(SKAction.sequence([actionMove,actionMoveDone]))
    }
    
    
 /*   func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        // step 5b - now lets move our hero
        moveGoodGuy(toPoint: pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
            
            
            // step 5c - now lets move our hero
            moveGoodGuy(toPoint: pos)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }*/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        // step 5c - now lets move our hero
        let pos : CGPoint = (touches.first?.location(in: self))!
        moveGoodGuy(toPoint: pos)
      
    }
    
 /*   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    */
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        enumerateChildNodes(withName: "baddy") { node, stop in
            if (node is SKSpriteNode) {
                
                if node.position.x <= 0 {
                    node.removeFromParent()
                }
            }
        }
        lblTime.text = String(time - 1)
        time -= 1
        if time == 0 {
            
        }
    }
}

