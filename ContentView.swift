import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var ground: SKSpriteNode!
    
    
    override func didMove(to view:SKView) {
        
        player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        addChild(player)
        
        ground = SKSpriteNode(color: .red, size: CGSize(width: self.frame.width,  height: self.frame.height))
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2 + 25)
        addChild(ground)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
 
    func jumpPlayer() {
        if player.physicsBody?.velocity.dy == 0 {
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
        }
    }
}

