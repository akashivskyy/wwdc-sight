// CameraView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreImage
import CoreVideo
import Metal
import MetalKit
import UIKit

/// View that renders camera pixel buffer and applies filter beforehand.
internal final class CameraView: UIView, MTKViewDelegate {

    // MARK: Initializers

    /// Initialize an instance.
    internal init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    /// The pixel buffer captured by camera.
    internal var pixelBuffer: CVPixelBuffer?

    /// The CoreImage filters to be applied.
    internal var filters: [CIFilter] = []

    #if !targetEnvironment(simulator)

    /// The Metal device.
    private lazy var device: MTLDevice = {
        MTLCreateSystemDefaultDevice()!
    }()

    /// The CoreImage context based on Metal.
    private lazy var context: CIContext = {
        CIContext(mtlDevice: device)
    }()

    /// The color space used for color calculation.
    private lazy var colorSpace = {
        CGColorSpaceCreateDeviceRGB()
    }()

    /// The Metal command queue used for rendering.
    private lazy var commandQueue = {
        device.makeCommandQueue()!
    }()

    #endif

    // MARK: Hierarchy

    #if !targetEnvironment(simulator)

    private lazy var metalView: MTKView = {
        with(MTKView()) {
            $0.device = device
            $0.framebufferOnly = false
            $0.delegate = self
        }
    }()

    #endif

    // MARK: Lifecycle

    #if !targetEnvironment(simulator)

    /// Set up view hierarchy.
    private func setup() {

        addSubview(metalView)

        metalView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            metalView.topAnchor.constraint(equalTo: self.topAnchor),
            metalView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            metalView.leftAnchor.constraint(equalTo: self.leftAnchor),
            metalView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

    }

    #else

    /// Just a placeholder so that compiler is happy.
    private func setup() {
        backgroundColor = [.red, .green, .blue, .orange, .magenta, .cyan, .brown, .purple, .yellow].randomElement()!
    }

    #endif

    // MARK: MTKViewDelegate

    #if !targetEnvironment(simulator)

    /// - SeeAlso: MTKViewDelegate.draw(in:)
    internal func draw(in view: MTKView) {

        guard let pixelBuffer = pixelBuffer else { return }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let drawable = view.currentDrawable else { return }

        let input = CIImage(cvPixelBuffer: pixelBuffer).oriented(.right)

        let drawableSize = CGSize(width: drawable.texture.width, height: drawable.texture.height)
        let inputSize = input.extent

        let scale = max(drawableSize.width / inputSize.width, drawableSize.height / inputSize.height)
        let scaledSize = CGSize(width: inputSize.width * scale, height: inputSize.height * scale)

        let scaleFilter = CIFilter(name: "CILanczosScaleTransform", parameters: [
            "inputScale": scale,
        ])!

        let cropRect = CGRect(
            x: max(0, drawableSize.width - scaledSize.width),
            y: max(0, drawableSize.height - scaledSize.height),
            width: drawableSize.width,
            height: drawableSize.height
        )

        let cropFilter = CIFilter(name: "CICrop", parameters: [
            "inputRectangle": CIVector(cgRect: cropRect)
        ])!

        let pipeline = filters + [scaleFilter, cropFilter]

        pipeline.first!.setValue(input, forKey: "inputImage")
        zip(pipeline.dropFirst(), pipeline).forEach { $0.setValue($1.outputImage!, forKey: "inputImage") }

        let output = pipeline.last!.outputImage!

        context.render(
            output,
            to: drawable.texture,
            commandBuffer: commandBuffer,
            bounds: output.extent,
            colorSpace: colorSpace
        )

        commandBuffer.present(drawable)
        commandBuffer.commit()

    }

    /// - SeeAlso: MTKViewDelegate.draw(_:drawableSizeWillChange:)
    internal func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // noop
    }

    #else

    /// - SeeAlso: MTKViewDelegate.draw(_:drawableSizeWillChange:)
    internal func draw(in view: MTKView) {
        // noop
    }

    /// - SeeAlso: MTKViewDelegate.draw(in:)
    internal func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // noop
    }

    #endif
    
}
