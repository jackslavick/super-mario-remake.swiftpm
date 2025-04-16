import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var ground: SKSpriteNode!
    
    
    override func didMove(to view:SKView) {
        
        player = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        addChild(player)
    }
}
