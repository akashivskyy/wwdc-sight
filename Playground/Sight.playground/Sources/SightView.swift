// SightView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreLocation
import CoreVideo
import UIKit

// View that is used to show sight.
internal final class SightView: UIView {

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

    /// The sight descriptor.
    internal var sightDescriptor: SightDescriptor = .default {
        didSet {
            update()
        }
    }

    /// The icon.
    internal var icon: String = "" {
        didSet {
            update()
        }
    }

    /// Shortcut access to underlying camera view's pixel buffer.
    internal var cameraPixelBuffer: CVPixelBuffer? {
        get { return cameraView.pixelBuffer }
        set { cameraView.pixelBuffer = newValue }
    }

    /// Shortcut access to underlying camera view's device position.
    internal var cameraDevicePosition: CameraCapturer.DevicePosition {
        get { return cameraView.devicePosition }
        set { cameraView.devicePosition = newValue }
    }

    /// Shortcut access to underlying camera view's device position.
    internal var deviceOrientation: UIInterfaceOrientation {
        get { return cameraView.deviceOrientation }
        set { cameraView.deviceOrientation = newValue }
    }

    /// Shortcut access to underlying magnetic view's heading.
    internal var magneticHeading: CLLocationDirection? {
        get { return magneticView.heading }
        set { magneticView.heading = newValue }
    }

    /// Shortcut access to underlying camera view's device position.
    internal var magneticDevicePosition: CameraCapturer.DevicePosition {
        get { return magneticView.devicePosition }
        set { magneticView.devicePosition = newValue }
    }

    // MARK: Hierarchy

    private lazy var cameraView: CameraView = {
        CameraView()
    }()

    private lazy var magneticView: MagneticView = {
        MagneticView()
    }()

    private lazy var iconLabel: UILabel = {
        with(UILabel()) {
            $0.numberOfLines = 1
            $0.font = .systemFont(ofSize: 32, weight: .bold)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
        }
    }()

    // MARK: Lifecycle

    /// Set up view hierarchy.
    private func setup() {

        addSubview(cameraView)
        addSubview(magneticView)
        addSubview(iconLabel)

        cameraView.translatesAutoresizingMaskIntoConstraints = false
        magneticView.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            cameraView.topAnchor.constraint(equalTo: self.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cameraView.leftAnchor.constraint(equalTo: self.leftAnchor),
            cameraView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        addConstraints([
            magneticView.topAnchor.constraint(equalTo: self.topAnchor),
            magneticView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            magneticView.leftAnchor.constraint(equalTo: self.leftAnchor),
            magneticView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        addConstraints([
            iconLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            iconLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor, constant: 8).withPriority(.defaultHigh),
            iconLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor, constant: -8).withPriority(.defaultHigh),
        ])

        update()

    }

    /// Update views based on sight preset.
    private func update() {
        cameraView.filters = sightDescriptor.effect.filters
        magneticView.isHidden = !sightDescriptor.magnetic
        iconLabel.text = icon
    }

}
