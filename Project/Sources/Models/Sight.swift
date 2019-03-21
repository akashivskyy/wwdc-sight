// Sight.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

/// Represents a sight preset.
internal struct Sight {

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - icon: An emoji icon.
    ///     - description: A textual description.
    ///     - effect: Effect to apply to the camera view.
    ///     - seesMagnetic: Whether to visualize magnetic field.
    internal init(icon: String, description: String, effect: Effect?, seesMagnetic: Bool) {
        self.icon = icon
        self.description = description
        self.effect = effect
        self.seesMagnetic = seesMagnetic
    }

    /// The default sight preset.
    internal static var `default`: Sight {
        return .init(icon: "", description: "", effect: nil, seesMagnetic: false)
    }

    // MARK: Properties

    /// An amoji icon.
    internal let icon: String

    /// A textual description.
    internal let description: String

    /// Effect to apply to the camera view.
    internal let effect: Effect?

    /// Whether to visualize magnetic field.
    internal let seesMagnetic: Bool

}
