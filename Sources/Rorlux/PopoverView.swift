import SwiftUI

struct PopoverView: View {
    @ObservedObject var appState: AppState

    private var kelvinText: String {
        "\(GammaController.kelvinForWarmth(appState.warmth))K"
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(appState.isEnabled ? Color.orange : Color.secondary)

                Text("Rorlux")
                    .font(.system(size: 13, weight: .bold, design: .rounded))

                Spacer()

                Text(kelvinText)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .opacity(appState.isEnabled ? 1 : 0)

                CompactToggle(isOn: $appState.isEnabled)
            }

            VStack(spacing: 0) {
                WarmthSlider(value: $appState.warmth, isEnabled: appState.isEnabled)

                KelvinMarker(value: $appState.warmth, kelvin: 2700)
                    .padding(.top, 2)

                HStack {
                    Text("MILD")
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.quaternary)
                    Spacer()
                    Text("STRONG")
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.quaternary)
                }
                .padding(.top, 2)
            }
            .opacity(appState.isEnabled ? 1 : 0.3)
            .allowsHitTesting(appState.isEnabled)

            HStack {
                Spacer()
                Button {
                    GammaController.reset()
                    NSApplication.shared.terminate(nil)
                } label: {
                    Image(systemName: "power")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.quaternary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .frame(width: 230)
        .animation(.easeInOut(duration: 0.15), value: appState.isEnabled)
    }
}

// MARK: - Compact pill toggle

struct CompactToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Text(isOn ? "ON" : "OFF")
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .kerning(0.5)
                .foregroundStyle(isOn ? .white : Color.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule().fill(isOn ? Color.orange : Color.secondary.opacity(0.12))
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Kelvin preset marker

struct KelvinMarker: View {
    @Binding var value: Double
    let kelvin: Int

    private let sliderRange: ClosedRange<Double> = 0.05...1.0
    private let thumbDiameter: CGFloat = 16

    private var fraction: Double {
        let warmth = GammaController.warmthForKelvin(kelvin)
        return (warmth - sliderRange.lowerBound) / (sliderRange.upperBound - sliderRange.lowerBound)
    }

    private var isActive: Bool {
        abs(value - GammaController.warmthForKelvin(kelvin)) < 0.02
    }

    var body: some View {
        GeometryReader { geo in
            let pad = thumbDiameter / 2
            let usable = geo.size.width - thumbDiameter
            let xPos = pad + CGFloat(fraction) * usable

            Button {
                value = GammaController.warmthForKelvin(kelvin)
            } label: {
                VStack(spacing: 1) {
                    RoundedRectangle(cornerRadius: 0.5)
                        .fill(isActive ? Color.orange : Color.secondary.opacity(0.35))
                        .frame(width: 1, height: 5)
                    Text("\(kelvin)")
                        .font(.system(size: 8, weight: isActive ? .bold : .medium, design: .monospaced))
                        .foregroundStyle(isActive ? Color.orange : Color.secondary.opacity(0.55))
                }
            }
            .buttonStyle(.plain)
            .position(x: xPos, y: geo.size.height / 2)
        }
        .frame(height: 16)
    }
}

// MARK: - Gradient warmth slider

struct WarmthSlider: View {
    @Binding var value: Double
    let isEnabled: Bool

    private let range: ClosedRange<Double> = 0.05...1.0
    private let trackHeight: CGFloat = 5
    private let thumbDiameter: CGFloat = 16

    private var fraction: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }

    var body: some View {
        GeometryReader { geo in
            let usableWidth = geo.size.width - thumbDiameter
            let thumbOffset = CGFloat(fraction) * usableWidth

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(LinearGradient(
                        colors: [
                            Color(red: 0.55, green: 0.70, blue: 1.00),
                            Color(red: 1.00, green: 0.85, blue: 0.50),
                            Color(red: 1.00, green: 0.55, blue: 0.10)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(height: trackHeight)
                    .padding(.horizontal, thumbDiameter / 2)

                Circle()
                    .fill(.white)
                    .frame(width: thumbDiameter, height: thumbDiameter)
                    .shadow(color: Color.orange.opacity(isEnabled ? 0.5 : 0), radius: 6)
                    .shadow(color: .black.opacity(0.18), radius: 2, y: 1)
                    .offset(x: thumbOffset)
            }
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { drag in
                    let frac = (drag.location.x - thumbDiameter / 2) / usableWidth
                    let clamped = max(0.0, min(1.0, Double(frac)))
                    value = range.lowerBound + clamped * (range.upperBound - range.lowerBound)
                }
            )
        }
        .frame(height: thumbDiameter + 4)
    }
}
