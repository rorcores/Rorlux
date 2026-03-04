import Foundation

class AppState: ObservableObject {
    @Published var isEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isEnabled, forKey: "rorlux_isEnabled")
            applyCurrentState()
            onStateChange?()
        }
    }

    @Published var warmth: Double {
        didSet {
            UserDefaults.standard.set(warmth, forKey: "rorlux_warmth")
            applyCurrentState()
        }
    }

    var onStateChange: (() -> Void)?

    init() {
        let defaults = UserDefaults.standard
        self.isEnabled = defaults.object(forKey: "rorlux_isEnabled") as? Bool ?? false
        self.warmth = defaults.object(forKey: "rorlux_warmth") as? Double ?? 0.5
    }

    func applyCurrentState() {
        if isEnabled {
            GammaController.setWarmth(warmth)
        } else {
            GammaController.reset()
        }
    }
}
