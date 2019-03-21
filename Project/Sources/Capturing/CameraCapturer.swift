// CameraCapturer.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import AVFoundation
import CoreMedia
import CoreVideo
import Foundation

/// Responsible for capturing camera pixel buffers.
internal final class CameraCapturer: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    // MARK: Types

    /// Represents a camera device position.
    internal enum DevicePosition {

        /// A back camera.
        case back

        /// A front camera.
        case front

    }

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - position: Initial camera device position.
    internal init(position: DevicePosition = .back) {
        self.position = position
        super.init()
        reconfigure()
    }

    deinit {
        stop()
    }

    // MARK: Properties

    /// A camera device position.
    internal var position: DevicePosition {
        didSet {
            reconfigure()
        }
    }

    /// The AV capture session.
    private lazy var session: AVCaptureSession = {
        AVCaptureSession()
    }()

    /// A back camera device, if any.
    private lazy var backDevice: AVCaptureDevice? = {
        .default(.builtInWideAngleCamera, for: .video, position: .back)
    }()

    /// A front camera device, if any.
    private lazy var frontDevice: AVCaptureDevice? = {
        .default(.builtInWideAngleCamera, for: .video, position: .front)
    }()

    /// The current camera device according to `position`, if any.
    private var currentDevice: AVCaptureDevice? {
        switch position {
            case .back: return backDevice
            case .front: return frontDevice
        }
    }

    /// Queue used by AV capture session.
    private let queue = DispatchQueue(
        label: "me.akashivskyy.private.wwdc-perception.capturer",
        qos: .userInitiated,
        autoreleaseFrequency: .workItem
    )

    /// Callback on buffer
    private var onBuffer: ((CVPixelBuffer) -> Void)? = nil

    // MARK: Lifecycle

    /// Reconfigure AV calture session.
    private func reconfigure() {

        session.beginConfiguration()
        defer { session.commitConfiguration() }

        session.inputs.forEach(session.removeInput)
        session.outputs.forEach(session.removeOutput)

        let output = with(AVCaptureVideoDataOutput()) {
            $0.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            $0.setSampleBufferDelegate(self, queue: queue)
        }

        guard let device = currentDevice, let input = try? AVCaptureDeviceInput(device: device) else { return }
        guard session.canAddInput(input), session.canAddOutput(output) else { return }

        session.addInput(input)
        session.addOutput(output)

    }

    /// Start capturing.
    ///
    /// - Parameters:
    ///     - callback: Callback on buffer.
    internal func start(with callback: @escaping (CVPixelBuffer) -> Void) {
        onBuffer = callback
        session.startRunning()
    }

    /// Stop capturing.
    internal func stop() {
        session.stopRunning()
        onBuffer = nil
    }

    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate

    /// - SeeAlso: AVCaptureVideoDataOutputSampleBufferDelegate.captureOutput(_:didOutput:from:)
    internal func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        onBuffer?(pixelBuffer)
    }

}
