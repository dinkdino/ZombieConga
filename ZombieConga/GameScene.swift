
import SpriteKit

class GameScene: SKScene {
    
    var zombie: SKSpriteNode!
    
    var zombieMovePointsPerSec: CGFloat = 480.0
    
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    
    var velocity = CGPointZero
    
    var lastTapPosition = CGPointZero
    
    let playableRect: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        view.backgroundColor = SKColor.whiteColor()
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.anchorPoint = CGPointZero
        background.position = CGPointZero
        background.zPosition = -1
        addChild(background)
        
        // Add Zombie
        zombie = SKSpriteNode(imageNamed: "zombie1")
        zombie.position = CGPoint(x: 400, y: 400)
        addChild(zombie)
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        // Move Zombie
        moveSprite(zombie, velocity: velocity)
        rotateSprite(zombie, direction: velocity)
        
        boundsCheck()
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    func moveTowardsPoint(location: CGPoint) {
        
        var offset = location - zombie.position
        offset = offset.normalized()
        
        velocity = offset * zombieMovePointsPerSec
    }
    
    
    func sceneTouched(location: CGPoint) {
        moveTowardsPoint(location)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    func boundsCheck() {
        let bottomLeft = CGPoint(x: 0, y: CGRectGetMinY(playableRect))
        let topRight = CGPoint(x: self.size.width, y: CGRectGetMaxY(playableRect))
        
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = direction.angle
    }
    
}