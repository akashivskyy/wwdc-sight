// Sight.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

/// Represents a single sight descriptor.
internal struct SightDescriptor {

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - effect: Effect to apply when visualizing camera.
    ///     - magnetic: Whether to visualize magnetic field.
    internal init(effect: Effect, magnetic: Bool) {
        self.effect = effect
        self.magnetic = magnetic
    }

    /// The default sight preset.
    internal static var `default`: SightDescriptor {
        return .init(effect: .none, magnetic: false)
    }

    // MARK: Properties

    /// Effect to apply when visualizing camera.
    internal let effect: Effect

    /// Whether to visualize magnetic field.
    internal let magnetic: Bool

}

// MARK: -

/// Represents a set of sight descriptors.
internal enum SightDescriptorSet {

    // MARK: Cases

    /// A simple set of just one sight descriptor.
    case simple(SightDescriptor)

    /// A set of day and night sight descriptors.
    case nocturnal(day: SightDescriptor, night: SightDescriptor)

    /// The default set of sight descriptors.
    internal static var `default`: SightDescriptorSet {
        return .simple(.default)
    }

}

// MARK: -

/// Represents sight of an animal.
internal struct Sight {

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - icon: An emoji icon.
    ///     - name: A textual description.
    ///     - sight: A set of sight descriptors.
    private init(icon: String, name: String, sightSet: SightDescriptorSet) {
        self.icon = icon
        self.name = name
        self.sightSet = sightSet
    }

    /// Create a simple sight.
    ///
    /// - Parameters:
    ///     - icon: An emoji icon.
    ///     - name: A textual description.
    ///     - effect: Effect to apply when visualizing camera.
    ///     - magnetic: Whether to visualize magnetic field.
    internal static func simple(icon: String, name: String, effect: Effect, magnetic: Bool) -> Sight {
        return .init(
            icon: icon,
            name: name,
            sightSet: .simple(.init(effect: effect, magnetic: magnetic))
        )
    }

    /// Create a simple sight.
    ///
    /// - Parameters:
    ///     - icon: An emoji icon.
    ///     - name: A textual description.
    ///     - dayEffect: Effect to apply when visualizing camera in day mode.
    ///     - nightEffect: Effect to apply when visualizing camera in night mode.
    ///     - magnetic: Whether to visualize magnetic field.
    internal static func nocturnal(icon: String, name: String, dayEffect: Effect, nightEffect: Effect, magnetic: Bool) -> Sight {
        return .init(
            icon: icon,
            name: name,
            sightSet: .nocturnal(day: .init(effect: dayEffect, magnetic: magnetic), night: .init(effect: nightEffect, magnetic: magnetic))
        )
    }

    /// The default sight preset.
    internal static var `default`: Sight {
        return .simple(icon: "", name: "", effect: .none, magnetic: false)
    }

    // MARK: Properties

    /// An amoji icon.
    internal let icon: String

    /// A textual name.
    internal let name: String

    /// A set of sight descriptors.
    internal let sightSet: SightDescriptorSet

}
