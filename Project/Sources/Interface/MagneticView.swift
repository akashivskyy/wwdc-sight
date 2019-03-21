// MagneticView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import CoreLocation
import UIKit

/// View that visualizes Earth's magnetic poles.
internal final class MagneticView: UIView {

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

    /// The magnetic heading vector.
    internal var magneticHeading: CLLocationDirection? {
        didSet {
            reposition()
        }
    }

    // MARK: Hierarchy

    private lazy var northImageView: UIImageView = {
        with(UIImageView()) {
            $0.image = UIImage(named: "pole")
            $0.tintColor = .black
        }
    }()

    private lazy var southImageView: UIImageView = {
        with(UIImageView()) {
            $0.image = UIImage(named: "pole")
            $0.tintColor = .white
        }
    }()

    // MARK: Lifecycle

    /// Set up view hierarchy and services.
    private func setup() {

        addSubview(northImageView)
        addSubview(southImageView)

        northImageView.translatesAutoresizingMaskIntoConstraints = false
        southImageView.translatesAutoresizingMaskIntoConstraints = false

        northImageView.sizeToFit()
        southImageView.sizeToFit()

    }

    /// Reposition the pole visualization.
    private func reposition() {

        guard let magneticHeading = magneticHeading else { return }

        let northHeading = CGFloat(magneticHeading < 180 ? magneticHeading : magneticHeading - 360)
        let southHeading = CGFloat(magneticHeading - 180)

        let northPosition = (self.bounds.width / 2) * (1 - (northHeading / 45)) - (self.northImageView.bounds.width / 2)
        let southPosition = (self.bounds.width / 2) * (1 - (southHeading / 45)) - (self.southImageView.bounds.width / 2)

        self.northImageView.isHidden = false
        self.southImageView.isHidden = false

        self.northImageView.frame.origin.x = northPosition
        self.southImageView.frame.origin.x = southPosition

    }

}
