// ComparisonView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// View that provides interactive comparison between two other views.
internal final class ComparisonView: UIView, UIGestureRecognizerDelegate {

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

    /// The left view. The view's `layoutMargins` will be changed as user
    /// pans the comparison knob.
    internal var leftView: UIView? {
        didSet {
            replaceLeftView()
        }
    }

    /// The left view. The view's `layoutMargins` will be changed as user
    /// pans the comparison knob.
    internal var rightView: UIView? {
        didSet {
            replaceRightView()
        }
    }

    // MARK: Hierarchy

    private lazy var leftContainerView: UIView = {
        with(UIView()) {
            $0.backgroundColor = .black
        }
    }()

    private lazy var rightContainerView: UIView = {
        with(UIView()) {
            $0.backgroundColor = .black
            $0.mask = rightContainerMask
        }
    }()

    private lazy var rightContainerMask: UIView = {
        with(UIView()) {
            $0.backgroundColor = .black
        }
    }()

    private lazy var knobView: KnobView = {
        KnobView()
    }()

    private lazy var knobViewPositionConstraint: NSLayoutConstraint = {
        knobView.centerXAnchor.constraint(equalTo: self.centerXAnchor).withPriority(.defaultHigh)
    }()

    private var knobViewPosition: CGFloat {
        get { return bounds.midX + knobViewPositionConstraint.constant }
        set { knobViewPositionConstraint.constant = newValue - bounds.midX }
    }

    private let knobViewMargin: CGFloat = 64

    // MARK: Lifecycle

    /// Set up view hierarchy and behavior.
    private func setup() {

        addSubview(leftContainerView)
        addSubview(rightContainerView)
        addSubview(knobView)

        leftContainerView.translatesAutoresizingMaskIntoConstraints = false
        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
        knobView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            leftContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            leftContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            leftContainerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            leftContainerView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        addConstraints([
            rightContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            rightContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rightContainerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            rightContainerView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        addConstraints([
            knobViewPositionConstraint,
            knobView.topAnchor.constraint(equalTo: self.topAnchor),
            knobView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            knobView.centerXAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: knobViewMargin),
            knobView.centerXAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -knobViewMargin),
        ])

        knobView.panGestureRecognizer.delegate = self
        knobView.panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerDidFire))

    }

    /// - SeeAlso: UIView.layoutSubviews()
    internal override func layoutSubviews() {
        super.layoutSubviews()
        knobViewPosition = clamp(knobViewPosition, within: knobViewMargin ... bounds.maxX - knobViewMargin)
        rightContainerMask.frame = bounds.inset(by: .init(top: 0, left: knobViewPosition, bottom: 0, right: 0))
        leftView?.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width - knobViewPosition)
        rightView?.layoutMargins = UIEdgeInsets(top: 0, left: knobViewPosition, bottom: 0, right: 0)
    }

    /// Replace left view in the hierarchy.
    private func replaceLeftView() {

        leftContainerView.subviews.forEach {
            $0.removeFromSuperview()
        }

        guard let leftView = leftView else {
            return
        }

        leftContainerView.addSubview(leftView)

        leftView.preservesSuperviewLayoutMargins = false
        leftView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            leftView.topAnchor.constraint(equalTo: leftContainerView.topAnchor),
            leftView.bottomAnchor.constraint(equalTo: leftContainerView.bottomAnchor),
            leftView.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor),
            leftView.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor),
        ])

    }

    /// Replace right view in the hierarchy.
    private func replaceRightView() {

        rightContainerView.subviews.forEach {
            $0.removeFromSuperview()
        }

        guard let rightView = rightView else {
            return
        }

        rightContainerView.addSubview(rightView)

        rightView.preservesSuperviewLayoutMargins = false
        rightView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            rightView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
            rightView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor),
            rightView.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor),
            rightView.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor),
        ])

    }

    // MARK: Panning

    /// Initial position of knob when user begins panning.
    private var knobViewInitialPanningPosition: CGFloat = 0

    /// - SeeAlso: UIGestureRecognizerDelegate.gestureRecognizerShouldBegin(_:)
    internal override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === knobView.panGestureRecognizer {
            knobViewInitialPanningPosition = knobViewPosition
            return true
        } else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }

    }

    @objc private func panGestureRecognizerDidFire(_ gestureRecognizer: UIPanGestureRecognizer) {
        let newPosition = knobViewInitialPanningPosition + gestureRecognizer.translation(in: knobView).x
        knobViewPosition = clamp(newPosition, within: knobViewMargin ... bounds.maxX - knobViewMargin)
        setNeedsLayout()
    }

}
