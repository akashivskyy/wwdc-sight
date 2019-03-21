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

    /// Create a darken effect.
    ///
    /// - Parametsrs:
    ///     - Intensity: Effect intensity, `0...1`.
    internal static func darken(intensity: Float) -> Effect {
        return concat(
            filter(
                name: "CIColorControls",
                parameters: [
                    "inputBrightness": (intensity - 0.5) * -0.25
                ]
            ),
            filter(
                name: "CIExposureAdjust",
                parameters: [
                    "inputEV": intensity * -4
                ]
            )
        )
    }

    /// Create a desaturation effect.
    ///
    /// - Parameters:
    ///     - intensity: Effect intensity, `0...1`.
    static func desaturate(intensity: Float) -> Effect {
        return filter(
            name: "CIColorControls",
            parameters: [
                "inputSaturation": clamp(1 - intensity, within: 0...1)
            ]
        )
    }

    /// Create a deuteranopia color blindness effect.
    static func deuteranopize() -> Effect {
        return lut { $0.lms.withDeuteranopia().rgb }
    }

    static func vibrate(intensity: Float) -> Effect {
        return filter(
            name: "CIVibrance",
            parameters: [
                "inputAmount": intensity
            ]
        )
    }

    // MARK: Feature effects

    /// Create a gaussian blur effect.
    ///
    /// - Parameters:
    ///     - blur: Blur radius.
    static func blur(radius: Double) -> Effect {
        return filter(
            name: "CIGaussianBlur",
            parameters: [
                "inputRadius": radius
            ]
        )
    }

    /// Create a black vignette effect.
    ///
    /// - Parameters:
    ///     - radius: Vignette radius.
    static func vignette(radius: Float) -> Effect {
        return filter(
            name: "CIVignette",
            parameters: [
                "inputRadius": radius
            ]
        )
    }

    static func sharpen(intensity: Float) -> Effect {
        return filter(
            name: "CISharpenLuminance",
            parameters: [
                "inputSharpness": intensity
            ]
        )
    }

    // MARK: Prebuilt effects

    /// Create a dog sight effect.
    static func dog() -> Effect {
        return concat(
            deuteranopize(),
            desaturate(intensity: 0.2),
            blur(radius: 4)
        )
    }

    static func cat(night: Bool = false) -> Effect {
        return concat(
            deuteranopize(),
            darken(intensity: night ? 0.5 : 0),
            desaturate(intensity: 0.2),
            blur(radius: 2)
        )
    }

    static func night(intensity: Float = 1) -> Effect {
        return concat(
            darken(intensity: intensity),
            desaturate(intensity: intensity * 0.9),
            vignette(radius: intensity * 2)
        )
    }

    static func eagle() -> Effect {
        return concat(
            vibrate(intensity: 1),
            sharpen(intensity: 0.5)
        )
    }

}
