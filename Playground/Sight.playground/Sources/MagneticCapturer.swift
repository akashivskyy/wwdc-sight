// MagneticCapturer.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreLocation
import CoreMotion
import Foundation
import UIKit

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

    /// The current device orientation.
    internal var deviceOrientation: UIInterfaceOrientation = .unknown {
        didSet {
            recalibrate()
        }
    }

    /// The CoreLocation manager that delivers heading data.
    private lazy var locationManager: CLLocationManager = {
        CLLocationManager()
    }()

    /// The timer for polling heading data.
    private var locationTimer: Timer?

    /// Callback on heading.
    private var onHeading: ((CLLocationDirection?) -> Void)? = nil

    // MARK: Lifecycle

    /// Start capturing.
    ///
    /// - Parameters:
    ///     - callback: Callback on heading.
    internal func start(_ onHeading: @escaping (CLLocationDirection?) -> Void) {

        locationManager.requestWhenInUseAuthorization()

        guard CLLocationManager.headingAvailable() else {
            onHeading(nil)
            return
        }

        locationManager.headingOrientation = .portrait
        locationManager.startUpdatingHeading()

        locationTimer = Timer.scheduledTimer(withTimeInterval: Double(1) / 60, repeats: true) { [unowned self] _ in
            guard let heading = self.locationManager.heading else { return }
            onHeading(heading.magneticHeading)
        }

        self.onHeading = onHeading

        recalibrate()

    }

    /// Stop capturing.
    internal func stop() {

        onHeading?(nil)

        locationTimer?.invalidate()
        locationTimer = nil

        locationManager.stopUpdatingHeading()

    }

    /// Recalibrate CoreLocation manager heading readings.
    private func recalibrate() {
        locationManager.headingOrientation = {
            switch deviceOrientation {
                case .unknown, .portrait: return .portrait
                case .portraitUpsideDown: return .portraitUpsideDown
                case .landscapeLeft: return .landscapeRight
                case .landscapeRight: return .landscapeLeft
            }
        }()
    }

}
