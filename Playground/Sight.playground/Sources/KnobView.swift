// KnobView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// Knob used by `ComparisonView` to enable interactive comparison.
internal final class KnobView: UIView {

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

    /// A pan gesture recognizer attached to the knob. Should be used by the
    /// owning object to respond to panning.
    internal private(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        with(UIPanGestureRecognizer()) {
            $0.minimumNumberOfTouches = 1
            $0.maximumNumberOfTouches = 1
        }
    }()

    // MARK: Hierarchy

    private lazy var lineView: UIView = {
        with(UIView()) {
            $0.backgroundColor = .black
        }
    }()

    private lazy var knobImageView: UIImageView = {
        with(UIImageView()) {
            $0.image = UIImage(named: "knob")!
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(panGestureRecognizer)
        }
    }()

    // MARK: Lifecycle

    /// Set up view hierarchy and behavior.
    private func setup() {

        addSubview(lineView)
        addSubview(knobImageView)

        lineView.translatesAutoresizingMaskIntoConstraints = false
        knobImageView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            lineView.widthAnchor.constraint(equalToConstant: 4),
            lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            lineView.topAnchor.constraint(equalTo: self.topAnchor),
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        addConstraints([
            knobImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            knobImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            knobImageView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            knobImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            knobImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            knobImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

    }

}
