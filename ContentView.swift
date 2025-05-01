import SwiftUI

struct ContentView: View {
   
    @State private var marioPosition = CGPoint(x: 200, y: 500)
    @State private var marioVelocity = CGSize(width: 0, height: 0)
    @State private var isJumping = false
    @State private var isOnGround = false
    
   
    let platform = CGRect(x: 0, y: 600, width: 400, height: 50)
    
    let gravity: CGFloat = 0.5
    let jumpForce: CGFloat = -15
    let moveSpeed: CGFloat = 5
    
    var body: some View {
        VStack {
            ZStack {
               
                Color.blue.edgesIgnoringSafeArea(.all)
                
               
                Rectangle()
                    .frame(width: platform.width, height: platform.height)
                    .position(x: platform.midX, y: platform.midY)
                    .foregroundColor(.green)
                
               
                Rectangle()
                    .frame(width: 50, height: 50)
                    .position(marioPosition)
                    .foregroundColor(.red)
            }
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                   
                    if value.translation.width > 0 {
                       
                        marioPosition.x += moveSpeed
                    } else if value.translation.width < 0 {
                      
                        marioPosition.x -= moveSpeed
                    }
                }
            )
            .onAppear {
                startGameLoop()
            }
        }
    }
    
    
    func startGameLoop() {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
          
           
        }
    }
    
    
    func applyGravity() {
       
        if !isOnGround {
            marioVelocity.height += gravity
        } else {
            marioVelocity.height = 0
        }
        
        
    }
}

@main
struct MarioGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
