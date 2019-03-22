// Colors.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import simd

/// Represents color components in RGB color space.
internal struct RGBColor {

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - r: Red component.
    ///     - g: Green component.
    ///     - b: Blue component.
    internal init(r: Float, g: Float, b: Float) {
        self.r = r
        self.g = g
        self.b = b
    }

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - vector: SIMD vector representation.
    fileprivate init(vector: float3) {
        self.r = vector.x
        self.g = vector.y
        self.b = vector.z
    }

    // MARK: Properties

    /// Red component.
    internal let r: Float

    /// Green component.
    internal let g: Float

    /// Blue component.
    internal let b: Float

    /// SIMD vector representation.
    fileprivate var vector: float3 {
        return float3(r, g, b)
    }

    // MARK: Conversion

    /// LMS color representation.
    internal var lms: LMSColor {

        // Transformation matrix presented in
        // http://biecoll.ub.uni-bielefeld.de/volltexte/2007/52/pdf/ICVS2007-6.pdf

        let matrix = float3x3(rows: [
            float3(17.8824, 43.5161, 4.1193),
            float3(3.4557, 27.1554, 3.8671),
            float3(0.02996, 0.18431, 1.4670)
        ])

        return LMSColor(vector: simd_mul(matrix, vector))

    }

}

// MARK: -

/// Represents color components in LMS color space.
internal struct LMSColor {

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - l: Long wavelength component.
    ///     - m: Medium wavelength component.
    ///     - s: Short wavelength component.
    internal init(l: Float, m: Float, s: Float) {
        self.l = l
        self.m = m
        self.s = s
    }

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - vector: SIMD vector representation.
    fileprivate init(vector: float3) {
        self.l = vector.x
        self.m = vector.y
        self.s = vector.z
    }

    // MARK: Properties

    /// Long wavelength component.
    internal let l: Float

    /// Medium wavelength component.
    internal let m: Float

    /// Short wavelength component.
    internal let s: Float

    /// SIMD vector representation.
    fileprivate var vector: float3 {
        return float3(l, m ,s)
    }

    // MARK: Conversion

    /// RGB color representation.
    internal var rgb: RGBColor {

        // Transformation matrix presented in
        // http://biecoll.ub.uni-bielefeld.de/volltexte/2007/52/pdf/ICVS2007-6.pdf

        let matrix = simd_inverse(float3x3(rows: [
            float3(17.8824, 43.5161, 4.1193),
            float3(3.4557, 27.1554, 3.8671),
            float3(0.02996, 0.18431, 1.4670)
        ]))

        return RGBColor(vector: simd_mul(matrix, vector))

    }

    // MARK: Transformation

    /// Apply deuteranopia color blindness transformation.
    internal func withDeuteranopia() -> LMSColor {

        let matrix = float3x3(rows: [
            float3(1, 0, 0),
            float3(0.494207, 0, 1.24827),
            float3(0, 0, 1)
        ])

        return LMSColor(vector: simd_mul(matrix, vector))

    }

}
