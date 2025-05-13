import SwiftUI

struct ContentView: View {
    
    @State private var marioPosition = CGPoint(x: 200, y: 500)
    @State private var marioVelocity = CGSize(width: 0, height: 0)
    @State private var isJumping = false
    @State private var isOnGround = false
    @State private var moveDirection: CGFloat = 0
    
    
    let platforms: [CGRect] = [
        CGRect(x: 0, y: 600, width: 400, height: 50),
        CGRect(x: 500, y: 500, width: 200, height: 50),
        CGRect(x: 1000, y: 400, width: 200, height: 50)
    ]
    
    
    let obstacles: [CGRect] = [
        CGRect(x: 200, y: 450, width: 100, height: 30),
        CGRect(x: 700, y: 350, width: 100, height: 30)
    ]
    
    let gravity: CGFloat = 0.5
    let jumpForce: CGFloat = -15
    let moveSpeed: CGFloat = 5
    
    var body: some View {
        VStack {
            ZStack {
                
                Color.blue.edgesIgnoringSafeArea(.all)
                
               
                ForEach(0..<platforms.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: platforms[index].width, height: platforms[index].height)
                        .position(x: platforms[index].midX, y: platforms[index].midY)
                        .foregroundColor(.green)
                }
                
                
                ForEach(0..<obstacles.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: obstacles[index].width, height: obstacles[index].height)
                        .position(x: obstacles[index].midX, y: obstacles[index].midY)
                        .foregroundColor(.red)
                }
                
                
                Image("mario")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .position(marioPosition)
                    .scaledToFit()
            }
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    marioPosition.x += value.translation.width
                }
            )
            .onAppear {
                startGameLoop()
            }
            
            HStack {
                Button("Left") {
                    moveDirection = -moveSpeed
                }
                .padding()
                
                Button("Right") {
                    moveDirection = moveSpeed
                }
                .padding()
                
                Button("Jump") {
                    if isOnGround {
                        marioVelocity.height = jumpForce
                        isOnGround = false
                    }
                }
                .padding()
            }
        }
    }
    
    func applyGravity() {
        if !isOnGround {
            marioVelocity.height += gravity
        } else {
            marioVelocity.height = 0
        }
    }
    
    func updatePosition() {
        
        marioPosition.x += moveDirection
        
       
        if moveDirection == 0 {
            marioVelocity.width = 0
        }
        
        marioPosition.x = max(0, min(marioPosition.x, UIScreen.main.bounds.width - 50))
        
        marioPosition.y += marioVelocity.height
        
       
        isOnGround = false
        for platform in platforms {
            if marioPosition.y + 50 >= platform.minY && marioPosition.x + 50 >= platform.minX && marioPosition.x <= platform.maxX {
               
                marioPosition.y = platform.minY - 50
                isOnGround = true
                break
            }
        }
        
       
        if !isOnGround {
            marioVelocity.height += gravity
        }
        
       
        for obstacle in obstacles {
            if marioPosition.y + 50 >= obstacle.minY && marioPosition.x + 50 >= obstacle.minX && marioPosition.x <= obstacle.maxX {
               
                marioVelocity.height = 0
                marioPosition.y = obstacle.minY - 50
                isOnGround = true
            }
        }
    }
    
    func startGameLoop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.016) {
            applyGravity()
            updatePosition()
            startGameLoop()
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

