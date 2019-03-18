// Capturer.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import AVFoundation
import CoreMedia
import CoreVideo

internal final class Capturer: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    // MARK: Types

    internal enum DevicePosition {
        case back
        case front
    }

    // MARK: Initializers

    internal init(position: DevicePosition) {
        self.position = position
        super.init()
        reconfigureSession()
    }

    // MARK: Properties

    internal var position: DevicePosition {
        didSet {
            reconfigureSession()
        }
    }

    private lazy var session: AVCaptureSession = {
        AVCaptureSession()
    }()

    private lazy var backDevice: AVCaptureDevice? = {
        .default(.builtInWideAngleCamera, for: .video, position: .back)
    }()

    private lazy var frontDevice: AVCaptureDevice? = {
        .default(.builtInWideAngleCamera, for: .video, position: .front)
    }()

    private var activeDevice: AVCaptureDevice? {
        switch position {
            case .back: return backDevice
            case .front: return frontDevice
        }
    }

    private let queue = DispatchQueue(
        label: "me.akashivskyy.private.wwdc-perception.capturer",
        qos: .userInitiated,
        autoreleaseFrequency: .workItem
    )

    private var onSampleBuffer: ((CVPixelBuffer, CMFormatDescription) -> Void)? = nil

    // MARK: Lifecycle

    private func reconfigureSession() {

        session.beginConfiguration()
        defer { session.commitConfiguration() }

        session.inputs.forEach(session.removeInput)
        session.outputs.forEach(session.removeOutput)

        let output = with(AVCaptureVideoDataOutput()) {
            $0.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            $0.setSampleBufferDelegate(self, queue: queue)
        }

        guard let device = activeDevice, let input = try? AVCaptureDeviceInput(device: device) else { return }
        guard session.canAddInput(input), session.canAddOutput(output) else { return }

        session.addInput(input)
        session.addOutput(output)

    }

    internal func start(with callback: @escaping (CVPixelBuffer, CMFormatDescription) -> Void) {
        onSampleBuffer = callback
        session.startRunning()
    }

    internal func stop() {
        session.stopRunning()
        onSampleBuffer = nil
    }

    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate

    internal func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer) else { return }
        onSampleBuffer?(pixelBuffer, formatDescription)
    }

}
