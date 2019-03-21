// MagneticCapturer.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreLocation
import Foundation

/// Responsible for capturing magnetic heading.
internal final class MagneticCapturer {

    // MARK: Initializers

    /// Initialize an instance.
    internal init() {
        // noop
    }

    deinit {
        stop()
    }

    // MARK: Properties

    /// The CoreLocation manager that delivers heading data.
    private lazy var locationManager: CLLocationManager = {
        CLLocationManager()
    }()

    /// The timer for polling heading data.
    private var locationTimer: Timer?

    /// Callback on heading.
    private var onHeading: ((CLLocationDirection) -> Void)? = nil

    // MARK: Lifecycle

    /// Start capturing.
    ///
    /// - Parameters:
    ///     - callback: Callback on heading.
    internal func start(with onHeading: @escaping (CLLocationDirection) -> Void) {

        guard CLLocationManager.headingAvailable() else { return }

        locationManager.headingOrientation = .portrait
        locationManager.startUpdatingHeading()

        locationTimer = Timer.scheduledTimer(withTimeInterval: Double(1) / 60, repeats: true) { [unowned self] _ in
            guard let heading = self.locationManager.heading else { return }
            onHeading(heading.magneticHeading)
        }

    }

    /// Stop capturing.
    internal func stop() {

        locationTimer?.invalidate()
        locationTimer = nil

        locationManager.stopUpdatingHeading()

    }

}
