// Effect.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreImage
import UIKit

/// Represents an effect (or multiple effects) to be applies to an image. Backed
/// by CoreImage filters.
internal struct Effect {

    // MARK: Types

    internal typealias Filter = (CIImage, CGSize) -> CIFilter

    // MARK: Initializers

    /// Initialize an instance with an array of filters.
    ///
    /// - Parameters:
    ///     - filters: An array of CoreImage filters.
    private init(filters: [Filter]) {
        self.filters = filters
    }


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
    internal static var none: Effect {
        return .init(filters: [])
    }

    /// Create an effect that consists of multiple other effects.
    ///
    /// - Parameters:
    ///     - effects: A list of effects to chain.
    internal static func concat(_ effects: Effect...) -> Effect {
        return .init(filters: effects.flatMap { $0.filters })
    }

    // MARK: Color effects

    /// Create a darken effect.
    ///
    /// - Parametsrs:
    ///     - adjustment: Effect adjustment vector.
    internal static func brightness(adjustment: Float) -> Effect {
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

    internal static func contrast(adjustment: Float) -> Effect {
        return filter(
            name: "CIColorControls",
            parameters: [
                "inputContrast": 1 + clamp(adjustment, within: -1...1)
            ]
        )
    }

    /// Create a deuteranopia color blindness effect.
    internal static func deuteranopia() -> Effect {
        return lut { $0.lms.withDeuteranopia().rgb }
    }

    internal static func heatmap() -> Effect {
        return filter(
            name: "CIColorMap",
            parameters: [
                "inputGradientImage": CIImage(image: UIImage(named: "map1")!)!
            ]
        )
    }

    /// Create a desaturation effect.
    ///
    /// - Parameters:
    ///     - adjustment: Effect adjustment vector, `-1...1`.
    internal static func saturation(adjustment: Float) -> Effect {
        return filter(
            name: "CIColorControls",
            parameters: [
                "inputSaturation": 1 + clamp(adjustment, within: -1...1)
            ]
        )
    }

    /// Create a UV effect by bumping blues.
    internal static func ultraviolet() -> Effect {
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
    internal static func blur(radius: Double) -> Effect {
        return filter(
            name: "CIGaussianBlur",
            parameters: [
                "inputRadius": radius
            ]
        )
    }

    /// Create a sharpen effect.
    ///
    /// - Parameters:
    ///     - intensity: Sharpness intensity.
    internal static func sharpen(intensity: Float) -> Effect {
        return filter(
            name: "CISharpenLuminance",
            parameters: [
                "inputSharpness": intensity * 2
            ]
        )
    }

    // MARK: Prebuilt effects

    static func human(day: Bool) -> Effect {
        if day {
            return none
        } else {
            return concat(
                brightness(adjustment: -1.6),
                saturation(adjustment: -0.9)
            )
        }
    }

    /// Create a dog sight effect.
    static func dog(day: Bool) -> Effect {
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

    static func cat(day: Bool) -> Effect {
        if day {
            return concat(
                deuteranopia(),
                saturation(adjustment: -0.2),
                blur(radius: 2)
            )
        } else {
            return concat(
                contrast(adjustment: 0.2),
                deuteranopia(),
                brightness(adjustment: -0.8),
                saturation(adjustment: -0.5),
                blur(radius: 2)
            )
        }
    }

    static func bull(day: Bool) -> Effect {
        if day {
            return concat(
                brightness(adjustment: -0.2),
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

    static func eagle(day: Bool) -> Effect {
        return concat(
            ultraviolet(),
            saturation(adjustment: 1.0),
            sharpen(intensity: 0.5)
        )
    }

    static func snake(day: Bool) -> Effect {
        return concat(
            blur(radius: 10),
            heatmap()
        )
    }

    static func fly() -> Effect {
        return concat(
//            filter(name: "CIAffineTile", parameters: [
//                "inputTransform": NSValue.init(cgAffineTransform: CGAffineTransform.init(scaleX: 0.1, y: 0.08))
//                ])

            ultraviolet(),
//
            generate { inputImage, size in
                CIFilter(
                    name: "CIOpTile",
                    parameters: [
                        "inputCenter": CIVector.init(x: size.width / 2, y: size.height / 2), //CIVector(cgPoint: CGPoint(x: , y: )),
//                        "inputRadius": max(size.width, size.height) / 2,
                        "inputScale": 2,
                        "inputWidth": max(size.width, size.height) / 10,
                        "inputImage": inputImage
                    ]
                )!
            }

            , generate { inputImage, size in
                CIFilter(
                    name: "CIBumpDistortion",
                    parameters: [
                        "inputCenter": CIVector.init(x: size.width / 2, y: size.height / 2), //CIVector(cgPoint: CGPoint(x: , y: )),
                        "inputRadius": max(size.width, size.height) / 2,
                        "inputScale": -0.5,
                        "inputImage": inputImage
                    ]
                )!
            }



//            filter(name: "CIBumpDistortion", parameters: [:])
        )

    }

}
