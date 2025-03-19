import SwiftUI

struct LoaderView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Image("defaultBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .offset(x: isAnimating ? 20 : -20, y: isAnimating ? -5 : 5)
                    .rotationEffect(.degrees(isAnimating ? 10 : -10))
                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Searching flights...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

