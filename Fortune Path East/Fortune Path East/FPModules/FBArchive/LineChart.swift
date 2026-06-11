//
//  LineChart.swift
//  Fortune Path East
//
//

import SwiftUI

// MARK: - Charts

struct LineChart: View {
    let values: [Double]

    var body: some View {
        GeometryReader { geometry in
            let points = chartPoints(in: geometry.size)

            ZStack {
                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first)

                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(AppTheme.jade, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))

                ForEach(points.indices, id: \.self) { index in
                    Circle()
                        .fill(AppTheme.gold)
                        .frame(width: 8, height: 8)
                        .position(points[index])
                }
            }
        }
    }

    private func chartPoints(in size: CGSize) -> [CGPoint] {
        guard !values.isEmpty else { return [] }

        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 1
        let range = max(maxValue - minValue, 1)

        return values.enumerated().map { index, value in
            let xRatio = values.count == 1 ? 0.5 : Double(index) / Double(values.count - 1)
            let yRatio = (value - minValue) / range

            return CGPoint(
                x: size.width * xRatio,
                y: size.height - size.height * yRatio
            )
        }
    }
}

struct YinYangAnalyticsView: View {
    let sessions: [GameSession]

    private var profitableCount: Int {
        sessions.filter { $0.profit >= 0 }.count
    }

    private var lossCount: Int {
        sessions.filter { $0.profit < 0 }.count
    }

    private var profitableRatio: Double {
        guard !sessions.isEmpty else { return 0.5 }
        return Double(profitableCount) / Double(sessions.count)
    }

    var body: some View {
        HStack(spacing: 24) {
            ZStack {
                PieSlice(startAngle: .degrees(-90), endAngle: .degrees(-90 + 360 * profitableRatio))
                    .fill(AppTheme.jade)

                PieSlice(startAngle: .degrees(-90 + 360 * profitableRatio), endAngle: .degrees(270))
                    .fill(AppTheme.red)

                Circle()
                    .stroke(AppTheme.gold, lineWidth: 4)

                Text("\(Int(profitableRatio * 100))%")
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }
            .frame(width: 140, height: 140)

            VStack(alignment: .leading, spacing: 12) {
                MetricRow(title: "Profitable", value: "\(profitableCount)")
                MetricRow(title: "Loss", value: "\(lossCount)")
                MetricRow(title: "Total", value: "\(sessions.count)")
            }
        }
    }
}

struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()

        return path
    }
}
