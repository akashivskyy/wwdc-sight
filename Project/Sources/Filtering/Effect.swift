// Effect.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreImage

/// Represents an effect (or multiple effects) to be applies to an image. Backed
/// by CoreImage filters.
internal struct Effect {

    // MARK: Initializers

    /// Initialize an instance with an array of filters.
    ///
    /// - Parameters:
    ///     - filters: An array of CoreImage filters.
    private init(filters: [CIFilter]) {
        self.filters = filters
    }

    /// Create a single effect backed by CoreImage filter.
    ///
    /// - Parameters:
    ///     - name: The CoreImage filter name.
    ///     - parameters: The CoreImage filter parameters.
    private static func filter(name: String, parameters: [String: Any]) -> Effect {
        return .init(filters: [CIFilter(name: name, parameters: parameters)!])
    }

    // MARK: Properties

    /// Array of CoreImage filters representing the effect.
    internal var filters: [CIFilter]

    // MARK: Private effects

    /// Create a effect that transforms individual colors using a Color Lookup
    /// Table (LUT), a.k.a. Color Cube.
    ///
    /// - Parameters:
    ///     - transform: A function that transforms colors.
    private static func lut(_ transform: (RGBColor) -> RGBColor) -> Effect {

        let dimension = 64

        var values = with(ContiguousArray<Float>()) {
            $0.reserveCapacity(dimension * dimension * dimension * 4)
        }

        for b in 0 ..< dimension {
            for g in 0 ..< dimension {
                for r in 0 ..< dimension {

                    let input = RGBColor(
                        r: Float(r) / Float(dimension - 1),
                        g: Float(g) / Float(dimension - 1),
                        b: Float(b) / Float(dimension - 1)
                    )

                    let output = transform(input)

                    values.append(output.r)
                    values.append(output.g)
                    values.append(output.b)
                    values.append(1) // a

                }
            }
        }

        return .filter(
            name: "CIColorCube",
            parameters: [
                "inputCubeData": values.withUnsafeBufferPointer(Data.init),
                "inputCubeDimension": dimension
            ]
        )

    }

    // MARK: Basic effects

    /// Create an effect that consists of multiple other effects.
    ///
    /// - Parameters:
    ///     - effects: A list of effects to chain.
    static func concat(_ effects: Effect...) -> Effect {
        return .init(filters: effects.flatMap { $0.filters })
    }

    // MARK: Color effects

    /// Create a deuteranopia color blindness effect.
    static func deuteranopia() -> Effect {
        return .lut { $0.lms.deuteranopia().rgb }
    }

    /// Create a desaturation effect.
    ///
    /// - Parameters:
    ///     - intensity: Desaturation intensity, `0...1`.
    static func desaturation(intensity: Double) -> Effect {
        return .filter(
            name: "CIColorControls",
            parameters: [
                "inputSaturation": clamp(-intensity, within: 0...1)
            ]
        )
    }

    // MARK: Distortion effects

    /// Create a gaussian blur effect.
    ///
    /// - Parameters:
    ///     - blur: Blur radius.
    static func blur(radius: Double) -> Effect {
        return .filter(
            name: "CIGaussianBlur",
            parameters: [
                "inputRadius": radius
            ]
        )
    }

    // MARK: Prebuilt effects

    /// Create a dog sight effect.
    static func dog() -> Effect {
        return .concat(
            deuteranopia(),
            blur(radius: 6)
        )
    }

}
