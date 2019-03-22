// Effect.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreImage
import UIKit

/// Represents an effect (or multiple effects) to be applies to an image.
public struct Effect {

    // MARK: Types

    /// A filter generator.
    internal typealias Filter = (CIImage, CGSize) -> CIFilter

    // MARK: Initializers

    /// Initialize an instance with an array of filter generators.
    ///
    /// - Parameters:
    ///     - filters: An array of CoreImage filter generators.
    private init(filters: [Filter]) {
        self.filters = filters
    }

    /// Create an effect backed by a generator.
    ///
    /// - Parameters:
    ///     - filter: CoreImage filter generator.
    private static func generate(_ filter: @escaping Filter) -> Effect {
        return .init(filters: [filter])
    }

    /// Create a single effect backed by CoreImage filter.
    ///
    /// - Parameters:
    ///     - name: The CoreImage filter name.
    ///     - parameters: The CoreImage filter parameters.
    private static func filter(name: String, parameters: [String: Any]) -> Effect {
        return generate { inputImage, _ in
            with(CIFilter(name: name, parameters: parameters)!) {
                $0.setValue(inputImage, forKey: "inputImage")
            }
        }
    }

    // MARK: Properties

    /// Array of CoreImage filters representing the effect.
    internal var filters: [Filter]

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

    /// Create an empty effect.
    public static var none: Effect {
        return .init(filters: [])
    }

    /// Create an effect that consists of multiple other effects.
    ///
    /// - Parameters:
    ///     - effects: A list of effects to chain.
    public static func concat(_ effects: Effect...) -> Effect {
        return .init(filters: effects.flatMap { $0.filters })
    }

    // MARK: Color effects

    /// Create a darken effect.
    ///
    /// - Parametsrs:
    ///     - adjustment: Effect adjustment vector.
    public static func brightness(adjustment: Float) -> Effect {
        return concat(
            filter(
                name: "CIColorControls",
                parameters: [
                    "inputBrightness": (adjustment + 0.5) * 0.25
                ]
            ),
            filter(
                name: "CIExposureAdjust",
                parameters: [
                    "inputEV": adjustment * 4
                ]
            )
        )
    }


    /// Create a deuteranopia color blindness effect.
    public static func deuteranopia() -> Effect {
        return lut { $0.lms.withDeuteranopia().rgb }
    }

    /// Create a heatmap effect by highlighting whites and yellows.
    public static func heatmap() -> Effect {
        return filter(
            name: "CIColorMap",
            parameters: [
                "inputGradientImage": CIImage(image: UIImage(named: "heatmap")!)!
            ]
        )
    }

    /// Create a desaturation effect.
    ///
    /// - Parameters:
    ///     - adjustment: Effect adjustment vector, `-1...1`.
    public static func saturation(adjustment: Float) -> Effect {
        return filter(
            name: "CIColorControls",
            parameters: [
                "inputSaturation": 1 +  adjustment  //clamp(adjustment, within: -1...1)
            ]
        )
    }

    /// Create a UV effect by bumping blues.
    public static func ultraviolet() -> Effect {
        return filter(
            name: "CIColorPolynomial",
            parameters: [
                "inputBlueCoefficients": CIVector(x: 0, y: 2.5, z: 0, w: 0)
            ]
        )
    }

    // MARK: Distortion effects

    /// Create a gaussian blur effect.
    ///
    /// - Parameters:
    ///     - blur: Blur radius.
    public static func blur(radius: Float) -> Effect {
        return filter(
            name: "CIGaussianBlur",
            parameters: [
                "inputRadius": radius
            ]
        )
    }

    /// Create a bump distortion effect.
    ///
    /// - Parameters:
    ///     - radius: Bump radius, `0...2`.
    ///     - scale: Bump scale.
    public static func bump(radius: Float, scale: Float) -> Effect {
        return generate { inputImage, size in

            let sizeMin = Float(min(size.width, size.height))
            let sizeMax = Float(max(size.width, size.height))

            let center = CIVector(x: size.width / 2, y: size.height / 2)
            let radius = sizeMin + (radius - 1) * (sizeMax - sizeMin)

            return CIFilter(
                name: "CIBumpDistortion",
                parameters: [
                    "inputCenter": center,
                    "inputRadius": radius / 2,
                    "inputScale": scale,
                    "inputImage": inputImage
                ]
            )!

        }
    }

    /// Create a sharpen effect.
    ///
    /// - Parameters:
    ///     - intensity: Sharpness intensity.
    public static func sharpen(intensity: Float) -> Effect {
        return filter(
            name: "CISharpenLuminance",
            parameters: [
                "inputSharpness": intensity * 2
            ]
        )
    }

    // MARK: Sight effects

    /// Create a bee sight effect.
    ///
    /// - Parameters:
    ///     - day: Whether to create a day or nighr effect.
    public static func bee(day: Bool) -> Effect {
        if day {
            return concat(
                ultraviolet(),
                saturation(adjustment: 2.0),
                generate { inputImage, size in
                    CIFilter(
                        name: "CIOpTile",
                        parameters: [
                            "inputCenter": CIVector(x: size.width / 2, y: size.height / 2),
                            "inputScale": 2,
                            "inputWidth": max(size.width, size.height) / 10,
                            "inputImage": inputImage
                        ]
                    )!
                },
                bump(radius: 2, scale: -0.5)
            )
        } else {
            return concat(
                brightness(adjustment: -1.4),
                bee(day: true)
            )
        }
    }

    /// Create a bull sight effect.
    ///
    /// - Parameters:
    ///     - day: Whether to create a day or nighr effect.
    public static func bull(day: Bool) -> Effect {
        if day {
            return concat(
                brightness(adjustment: -0.5),
                saturation(adjustment: -0.9),
                blur(radius: 10)
            )
        } else {
            return concat(
                brightness(adjustment: -1.4),
                saturation(adjustment: -0.9),
                blur(radius: 20)
            )
        }
    }

    /// Create a cat sight effect.
    ///
    /// - Parameters:
    ///     - day: Whether to create a day or nighr effect.
    public static func cat(day: Bool) -> Effect {
        if day {
            return concat(
                deuteranopia(),
                saturation(adjustment: -0.2),
                blur(radius: 2)
            )
        } else {
            return concat(
                deuteranopia(),
                brightness(adjustment: -0.8),
                saturation(adjustment: -0.5),
                blur(radius: 2)
            )
        }
    }

    /// Create a dog sight effect.
    ///
    /// - Parameters:
    ///     - day: Whether to create a day or nighr effect.
    public static func dog(day: Bool) -> Effect {
        if day {
            return concat(
                deuteranopia(),
                saturation(adjustment: -0.2),
                blur(radius: 4)
            )
        } else {
            return concat(
                deuteranopia(),
                brightness(adjustment: -1.2),
                saturation(adjustment: -0.5),
                blur(radius: 4)
            )
        }
    }

    /// Create an eagle sight effect.
    ///
    /// - Parameters:
    ///     - day: Whether to create a day or nighr effect.
    public static func eagle(day: Bool) -> Effect {
        if day {
            return concat(
                ultraviolet(),
                saturation(adjustment: 1.0),
                sharpen(intensity: 0.5)
            )
        } else {
            return concat(
                brightness(adjustment: -1.0),
                eagle(day: true)
            )
        }
    }

    /// Create a human sight effect.
    ///
    /// - Parameters:
    ///     - day: Whether to create a day or nighr effect.
    public static func human(day: Bool) -> Effect {
        if day {
            return none
        } else {
            return concat(
                brightness(adjustment: -1.6),
                saturation(adjustment: -0.9)
            )
        }
    }

    /// Create a snake sight effect.
    ///
    /// - Parameters:
    ///     - day: Whether to create a day or nighr effect.
    public static func snake(day: Bool) -> Effect {
        return concat(
            blur(radius: 10),
            heatmap()
        )
    }

}
