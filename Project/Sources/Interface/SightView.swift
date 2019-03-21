// SightView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreLocation
import CoreVideo
import UIKit

// View that is used to show sight.
internal final class SightView: UIView {

    // MARK: Initializers

    /// Initialize an instance.
    ///
    /// - Parameters:
    ///     - sight: Sight preset.
    internal init(sight: Sight = .default) {
        self.sight = sight
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    /// The sight preset.
    internal var sight: Sight {
        didSet {
            reconfigure()
        }
    }

    /// Shortcut access to underlying camera view's pixel buffer.
    internal var cameraPixelBuffer: CVPixelBuffer? {
        get { return cameraView.pixelBuffer }
        set { cameraView.pixelBuffer = newValue }
    }

    /// Shortcut access to underlying magnetic view's heading.
    internal var magneticHeading: CLLocationDirection? {
        get { return magneticView.magneticHeading }
        set { magneticView.magneticHeading = newValue }
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
            $0.font = .systemFont(ofSize: 48)
            $0.adjustsFontSizeToFitWidth = true
            $0.textAlignment = .center
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
            iconLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            iconLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            iconLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor),
        ])

        reconfigure()

    }

    /// Reconfigure views based on sight preset.
    private func reconfigure() {
        cameraView.filters = sight.effect?.filters ?? []
        magneticView.isHidden = !sight.seesMagnetic
        iconLabel.text = sight.icon
    }

}
