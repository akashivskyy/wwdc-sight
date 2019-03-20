// RenderView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreImage
import CoreVideo
import Metal
import MetalKit
import UIKit

internal final class RenderView: UIView, MTKViewDelegate {

    internal init() {
        super.init(frame: .zero)
        setup()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    internal var pixelBuffer: CVPixelBuffer?

    internal var filters: [CIFilter] = []

    #if !targetEnvironment(simulator)

    private lazy var context: CIContext = {
        CIContext(mtlDevice: metalView.device!)
    }()

    private lazy var metalColorSpace = {
        CGColorSpaceCreateDeviceRGB()
    }()

    private lazy var metalCommandQueue = {
        metalView.device!.makeCommandQueue()!
    }()

    private lazy var metalView: MTKView = {
        with(MTKView()) {
            $0.device = MTLCreateSystemDefaultDevice()
            $0.framebufferOnly = false
            $0.delegate = self
        }
    }()

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

    internal func draw(in view: MTKView) {

        guard let pixelBuffer = pixelBuffer else { return }
        guard let commandBuffer = metalCommandQueue.makeCommandBuffer() else { return }
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
            colorSpace: metalColorSpace
        )

        commandBuffer.present(drawable)
        commandBuffer.commit()

    }

    internal func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // noop
    }

    #else

//    private lazy var imageView: UIImageView = {
//        with(UIImageView()) {
//            $0.contentMode = .scaleAspectFill
//            $0.backgroundColor = .black
//        }
//    }()

    private func setup() {

        backgroundColor = .red

    }

    #endif
    
}
