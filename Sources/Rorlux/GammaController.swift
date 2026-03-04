import CoreGraphics
import Foundation

enum GammaController {

    /// Apply a warm color filter based on warmth level (0.0–1.0)
    static func setWarmth(_ warmth: Double) {
        let kelvin = warmthToKelvin(warmth)
        let (r, g, b) = kelvinToMultipliers(kelvin)

        var displayIDs = [CGDirectDisplayID](repeating: 0, count: 8)
        var displayCount: UInt32 = 0
        CGGetOnlineDisplayList(8, &displayIDs, &displayCount)

        for i in 0..<Int(displayCount) {
            CGSetDisplayTransferByFormula(
                displayIDs[i],
                0, Float(r), 1.0,
                0, Float(g), 1.0,
                0, Float(b), 1.0
            )
        }
    }

    /// Restore displays to their default color profile
    static func reset() {
        CGDisplayRestoreColorSyncSettings()
    }

    // MARK: - Color Temperature Conversion

    /// Maps warmth (0.0–1.0) to Kelvin (6500K–100K)
    private static func warmthToKelvin(_ warmth: Double) -> Int {
        let clamped = max(0, min(1, warmth))
        return Int(6500.0 - clamped * 6400.0)
    }

    static func kelvinForWarmth(_ warmth: Double) -> Int {
        return warmthToKelvin(warmth)
    }

    static func warmthForKelvin(_ kelvin: Int) -> Double {
        return (6500.0 - Double(kelvin)) / 6400.0
    }

    /// Converts color temperature in Kelvin to RGB channel multipliers (0.0–1.0).
    /// Based on Tanner Helland's algorithm derived from CIE 1964 blackbody data.
    private static func kelvinToMultipliers(_ kelvin: Int) -> (r: Double, g: Double, b: Double) {
        let temp = Double(kelvin) / 100.0

        let r: Double
        let g: Double
        let b: Double

        if temp <= 66 {
            r = 255
        } else {
            r = 329.698727446 * pow(temp - 60, -0.1332047592)
        }

        if temp <= 66 {
            g = 99.4708025861 * log(temp) - 161.1195681661
        } else {
            g = 288.1221695283 * pow(temp - 60, -0.0755148492)
        }

        if temp >= 66 {
            b = 255
        } else if temp <= 19 {
            b = 0
        } else {
            b = 138.5177312231 * log(temp - 10) - 305.0447927307
        }

        return (
            max(0, min(255, r)) / 255.0,
            max(0, min(255, g)) / 255.0,
            max(0, min(255, b)) / 255.0
        )
    }
}
