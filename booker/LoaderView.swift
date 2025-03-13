import SwiftUI

struct LoaderView: View {
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

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Searching flights...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

