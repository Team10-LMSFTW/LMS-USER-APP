import SwiftUI

struct DonutView: View {
    let fractionFilled: Double // Fraction of the donut to be filled (e.g., 4/5)
    let fillColor: Color // Color of the filled portion

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 18) // Thickness of the donut
                .foregroundColor(Color.secondary.opacity(0.3)) // Color of the unfilled portion
            
            // Filled portion of the donut
            Path { path in
                let center = CGPoint(x: 30, y: 30) // Center of the donut
                let radius: CGFloat = 30 // Radius of the donut
                let startAngle: Angle = .degrees(0)
                let endAngle: Angle = .degrees(360 * fractionFilled)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .foregroundColor(fillColor) // Color of the filled portion
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: 60, height: 60)
    }
}

struct DonutView_Previews: PreviewProvider {
    static var previews: some View {
        DonutView(fractionFilled: 4/5, fillColor: .green) // Example usage with green color
    }
}
