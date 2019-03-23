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
            introView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            introView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            introView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            introView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
        ])

    }

    /// - SeeAlso: UIViewController.viewDidAppear(_:)
    public override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        introView.start()

    }

}
