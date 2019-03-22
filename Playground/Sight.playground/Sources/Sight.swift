// Sight.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

/// Represents a single sight descriptor.
public struct SightDescriptor {

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - effect: Effect to apply when visualizing camera.
    ///     - magnetic: Whether to visualize magnetic field.
    public init(effect: Effect, magnetic: Bool) {
        self.effect = effect
        self.magnetic = magnetic
    }

    /// The default sight preset.
    public static var `default`: SightDescriptor {
        return .init(effect: .none, magnetic: false)
    }

    // MARK: Properties

    /// Effect to apply when visualizing camera.
    public let effect: Effect

    /// Whether to visualize magnetic field.
    public let magnetic: Bool

}

// MARK: -

/// Represents a set of sight descriptors.
public enum SightDescriptorSet {

    // MARK: Cases

    /// A simple set of just one sight descriptor.
    case simple(SightDescriptor)

    /// A set of day and night sight descriptors.
    case nocturnal(day: SightDescriptor, night: SightDescriptor)

    /// The default set of sight descriptors.
    public static var `default`: SightDescriptorSet {
        return .simple(.default)
    }

    // MARK: Properties

    /// The day sight descriptor.
    internal var day: SightDescriptor {
        switch self {
            case .simple(let sight): return sight
            case .nocturnal(let sight, _): return sight
        }
    }

    /// The night sight descriptor.
    internal var night: SightDescriptor {
        switch self {
            case .simple(let sight): return sight
            case .nocturnal(_, let sight): return sight
        }
    }

    /// Whether `self` is `nocturnal`.
    internal var isNocturnal: Bool {
        switch self {
            case .simple: return false
            case .nocturnal: return true
        }
    }

}

// MARK: -

/// Represents sight of an animal.
public struct Sight {

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
    public static func simple(icon: String, name: String, effect: Effect, magnetic: Bool) -> Sight {
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
    public static func nocturnal(icon: String, name: String, dayEffect: Effect, nightEffect: Effect, magnetic: Bool) -> Sight {
        return .init(
            icon: icon,
            name: name,
            sightSet: .nocturnal(day: .init(effect: dayEffect, magnetic: magnetic), night: .init(effect: nightEffect, magnetic: magnetic))
        )
    }

    /// The default sight preset.
    public static var `default`: Sight {
        return .simple(icon: "", name: "", effect: .none, magnetic: false)
    }

    // MARK: Properties

    /// An amoji icon.
    public let icon: String

    /// A textual name.
    public let name: String

    /// A set of sight descriptors.
    public let sightSet: SightDescriptorSet

}
