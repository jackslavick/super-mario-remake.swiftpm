import SwiftUI

struct ContentView: View {
    
    @State private var marioPosition = CGPoint(x: 250, y: 425)
    @State private var marioVelocity = CGSize(width: 0, height: 0)
    @State private var isOnGround = false
    @State private var moveDirection: CGFloat = 0
    @State private var screenOffset: CGFloat = 0 // Track the screen's offset for scrolling
    
    let gravity: CGFloat = 0.5
    let jumpForce: CGFloat = -15
    let moveSpeed: CGFloat = 2
    let restartPosition = CGPoint(x: 250, y: 425) // Initial Mario position
    
    let platforms: [CGRect] = [
        CGRect(x: 0, y: 600, width: 400, height: 50),
        CGRect(x: 500, y: 500, width: 200, height: 50),
        CGRect(x: 1000, y: 400, width: 200, height: 50)
    ]
    
    let obstacles: [CGRect] = [
        CGRect(x: 200, y: 450, width: 100, height: 30),
        CGRect(x: 700, y: 350, width: 100, height: 30)
    ]
    
    let finishLine: CGRect = CGRect(x: 1200, y: 300, width: 30, height: 50) // Define finish line location
    
    var body: some View {
        VStack {
            ZStack {
                Image("mario")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Green platforms (move left based on screenOffset)
                ForEach(0..<platforms.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: platforms[index].width, height: platforms[index].height)
                        .position(x: platforms[index].midX - screenOffset, y: platforms[index].midY)
                        .foregroundColor(.green)
                }
                
                // Red obstacles (move left based on screenOffset)
                ForEach(0..<obstacles.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: obstacles[index].width, height: obstacles[index].height)
                        .position(x: obstacles[index].midX - screenOffset, y: obstacles[index].midY)
                        .foregroundColor(.red)
                }

                // Finish Line (Flag) (move left based on screenOffset)
                Rectangle()
                    .frame(width: finishLine.width, height: finishLine.height)
                    .position(x: finishLine.midX - screenOffset, y: finishLine.midY)
                    .foregroundColor(.yellow) // Flag as a yellow rectangle for simplicity

                Image("mario")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .position(marioPosition)
                    .scaledToFit()
            }
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
                
                // Restart Button
                Button("Restart") {
                    restartGame()
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
        
        // Update the screen's offset when Mario moves right
        screenOffset += moveDirection
        
        // Clamp Mario's horizontal position to the screen bounds
        marioPosition.x = max(0, min(marioPosition.x, UIScreen.main.bounds.width - 50))
        
        // Apply vertical velocity
        marioPosition.y += marioVelocity.height
        
        isOnGround = false
        
        // Check collision with all surfaces (green platforms + red obstacles)
        let allSurfaces = platforms + obstacles
        
        for surface in allSurfaces {
            let marioBottom = marioPosition.y + 25
            let marioTop = marioPosition.y - 25
            let surfaceTop = surface.minY
            let surfaceBottom = surface.maxY

            let marioRight = marioPosition.x + 25
            let marioLeft = marioPosition.x - 25

            let surfaceLeft = surface.minX
            let surfaceRight = surface.maxX

            // Check if Mario is landing on top of the surface (both platforms and obstacles)
            if marioBottom >= surfaceTop &&
                marioTop < surfaceTop &&
                marioRight > surfaceLeft &&
                marioLeft < surfaceRight &&
                marioVelocity.height >= 0 {
                
                marioPosition.y = surfaceTop - 25  // Snap to top of surface
                isOnGround = true
                marioVelocity.height = 0
                break
            }
        }

        // Check if Mario touches the finish line (flag)
        if marioPosition.x + 25 > finishLine.minX && marioPosition.x - 25 < finishLine.maxX &&
            marioPosition.y + 25 > finishLine.minY && marioPosition.y - 25 < finishLine.maxY {
            restartGame() // Restart the game when Mario touches the flag
        }
        
        // If Mario falls past the bottom of the screen, restart
        if marioPosition.y > UIScreen.main.bounds.height {
            restartGame()
        }
    }
    
    func startGameLoop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.016) {
            applyGravity()
            updatePosition()
            startGameLoop()
        }
    }
    
    func restartGame() {
        // Reset Mario's position and velocity
        marioPosition = restartPosition
        marioVelocity = CGSize(width: 0, height: 0)
        isOnGround = false
        moveDirection = 0
        screenOffset = 0 // Reset the screen offset as well
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

