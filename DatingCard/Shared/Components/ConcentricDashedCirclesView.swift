//
//  ConcentricDashedCirclesView.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 11/08/26.
//

import SwiftUI

struct ConcentricDashedCirclesView: View {
    var radii: [CGFloat] = [90, 135, 180, 225, 270, 315, 360]
    var yOffset: CGFloat = 40
    var strokeColor: Color = Color.white.opacity(0.18)
    var dashPattern: [CGFloat] = [4, 6]
    var lineWidth: CGFloat = 1.5

    var body: some View {
        GeometryReader { proxy in
            let centerPoint = CGPoint(x: proxy.size.width / 2, y: proxy.size.height + yOffset)

            ZStack {
                ForEach(radii, id: \.self) { radius in
                    Circle()
                        .stroke(
                            strokeColor,
                            style: StrokeStyle(lineWidth: lineWidth, dash: dashPattern)
                        )
                        .frame(width: radius * 2, height: radius * 2)
                        .position(centerPoint)
                }
            }
        }
        .ignoresSafeArea()
    }
}
