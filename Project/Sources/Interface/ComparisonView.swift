// ComparisonView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

internal final class ComparisonView: UIView, UIGestureRecognizerDelegate {

    // MARK: Initializers

    internal init() {
        super.init(frame: .zero)
        setup()
    }

    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    internal var leftView: UIView? {
        didSet {
            replaceLeftView()
        }
    }

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
        knobView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    }()

    private var knobViewPosition: CGFloat {
        get { return bounds.midX + knobViewPositionConstraint.constant }
        set { knobViewPositionConstraint.constant = newValue - bounds.midX }
    }

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
        ])

        knobView.panGestureRecognizer.delegate = self
        knobView.panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerDidFire))

    }

    internal override func layoutSubviews() {
        super.layoutSubviews()
        leftContainerView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width - knobViewPosition + 8)
        rightContainerView.layoutMargins = UIEdgeInsets(top: 0, left: knobViewPosition + 8, bottom: 0, right: 0)
        rightContainerMask.frame = bounds.inset(by: .init(top: 0, left: knobViewPosition, bottom: 0, right: 0))
    }

    private func replaceLeftView() {

        leftContainerView.subviews.forEach {
            $0.removeFromSuperview()
        }

        guard let leftView = leftView else {
            return
        }

        leftContainerView.addSubview(leftView)

        leftView.preservesSuperviewLayoutMargins = true
        leftView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            leftView.topAnchor.constraint(equalTo: leftContainerView.topAnchor),
            leftView.bottomAnchor.constraint(equalTo: leftContainerView.bottomAnchor),
            leftView.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor),
            leftView.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor),
        ])

    }

    private func replaceRightView() {

        rightContainerView.subviews.forEach {
            $0.removeFromSuperview()
        }

        guard let rightView = rightView else {
            return
        }

        rightContainerView.addSubview(rightView)

        rightView.preservesSuperviewLayoutMargins = true
        rightView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            rightView.topAnchor.constraint(equalTo: rightContainerView.topAnchor),
            rightView.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor),
            rightView.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor),
            rightView.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor),
        ])

    }

    // MARK: Panning

    private var knobViewInitialPanningPosition: CGFloat = 0

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
        knobViewPosition = clamp(newPosition, within: 60 ... bounds.maxX - 60)
        setNeedsLayout()
    }

}
