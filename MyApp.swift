import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var gameScene: GameScene
    
   
    init() {
        _gameScene = State(initialValue: GameScene(size: CGSize(width: 400, height: 600)))
    }

    var body: some View {
        VStack {
            SpriteView(scene: gameScene)
                .frame(width: 300, height: 400)
            
            HStack {
                Button("Move Left") {
                    gameScene.movePlayer(to: "left")
                }
                
                Button("Move Right") {
                    gameScene.movePlayer(to: "right")
                }
            }
            .padding()
        }
        .onAppear {
            let scene = GameScene(size: CGSize(width: 300, height: 400))
            scene.scaleMode = .aspectFill
            self.gameScene = scene
        }
    }
}

