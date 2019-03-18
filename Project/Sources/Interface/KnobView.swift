// KnobView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

internal final class KnobView: UIView {

    // MARK: Initializers

    internal init() {
        super.init(frame: .zero)
        setup()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Hierarchy

    private lazy var line: UIView = {
        with(UIView()) {
            $0.backgroundColor = .black
        }
    }()

    private lazy var knob: UIImageView = {
        with(UIImageView()) {
            $0.image = UIImage(named: "knob")!
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(panGestureRecognizer)
        }
    }()

    internal private(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        with(UIPanGestureRecognizer()) {
            $0.minimumNumberOfTouches = 1
            $0.maximumNumberOfTouches = 1
        }
    }()

    private func setup() {

        addSubview(line)
        addSubview(knob)

        line.translatesAutoresizingMaskIntoConstraints = false
        knob.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            line.widthAnchor.constraint(equalToConstant: 4),
            line.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            line.topAnchor.constraint(equalTo: self.topAnchor),
            line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        addConstraints([
            knob.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            knob.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            knob.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            knob.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            knob.leftAnchor.constraint(equalTo: self.leftAnchor),
            knob.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

    }

}
