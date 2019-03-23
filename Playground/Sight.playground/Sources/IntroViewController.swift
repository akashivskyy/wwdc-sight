// IntroViewController.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// Intro view controller of the playground.
public final class IntroViewController: UIViewController {

    // MARK: Initializers

    /// Initialize an instance.
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Hierarchy

    private lazy var introView: IntroView = {
        IntroView()
    }()

    // MARK: Lifecycle

    /// - SeeAlso: UIViewController.preferredStatusBarStyle
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /// - SeeAlso: UIViewController.loadView()
    public override func loadView() {

        super.loadView()

        view.addSubview(introView)

        introView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            introView.topAnchor.constraint(equalTo: view.topAnchor),
            introView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            introView.leftAnchor.constraint(equalTo: view.leftAnchor),
            introView.rightAnchor.constraint(equalTo:view.rightAnchor),
        ])

    }

    /// - SeeAlso: UIViewController.viewDidAppear(_:)
    public override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        introView.start()

    }

    /// - SeeAlso: UIViewController.viewWillTransition(to:with:)
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        switch UIDevice.current.orientation {
            case .unknown: Orientation.current = .unknown
            case .portrait: Orientation.current = .portrait
            case .portraitUpsideDown: Orientation.current = .portraitUpsideDown
            case .landscapeLeft: Orientation.current = .landscapeRight
            case .landscapeRight: Orientation.current = .landscapeLeft
            case .faceUp, .faceDown: break
        }
    }

}
