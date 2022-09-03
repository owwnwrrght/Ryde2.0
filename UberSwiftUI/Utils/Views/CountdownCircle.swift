//
//  CountdownCircle.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/2/22.
//

import SwiftUI

struct CountdownCircle: View {
    
    @State var progress = 0.0
    let timeLimitInSeconds: Double
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            CircularProgressView(progress: progress)
                .frame(width: 64, height: 64)
        }
        .onReceive(timer) { time in
            if self.progress < self.timeLimitInSeconds {
                self.progress += 0.1
            }
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            // background circle
            Circle()
                .stroke( Color.black, lineWidth: 4)
            
            // progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke( Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90)) // start rotation from top
                .animation(.easeInOut(duration: 0.2))
            Text("10")
        }
    }
}

struct CountdownCircle_Previews: PreviewProvider {
    static var previews: some View {
        CountdownCircle(timeLimitInSeconds: 10.0)
    }
}
