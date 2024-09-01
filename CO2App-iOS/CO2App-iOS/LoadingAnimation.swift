//
//  LoadingAnimation.swift
//

import Combine
import SwiftUI

struct LoadingAnimation: View {
    @State private var counter = 0
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let timing: Double
    let maxCounter: Int = 3
    let frame: CGSize
    let primaryColor: Color

    init(color: Color = .black, size: CGFloat = 30, speed: Double = 0.5) {
        timing = speed / 2
        timer = Timer.publish(every: timing, on: .main, in: .common).autoconnect()
        frame = CGSize(width: size, height: size)
        primaryColor = color
    }

    var body: some View {
        HStack(spacing: frame.width / 10) {
            ForEach(0 ..< maxCounter, id: \.self) { index in
                Capsule()
                    .fill(primaryColor)
                    .frame(maxHeight:
                            (index == 2) && (counter == 0) ? .infinity :
                            (index == 1 || index == 3) && (counter == 1) ? .infinity :
                            (index == 0 || index == 4) && (counter == 2) ? .infinity :
                            frame.height / 2
                    )
            }
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .onReceive(timer) { _ in
            withAnimation(.easeOut(duration: timing)) {
                counter = counter == 3 ? 0 : counter + 1
            }
        }
    }
}

#Preview {
    LoadingAnimation()
}
