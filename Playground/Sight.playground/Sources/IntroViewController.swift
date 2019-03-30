// IntroViewController.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// Intro view controller of the playground.
public final class IntroViewController: UIViewController {

    // MARK: Types

    /// The mode of intro view controller.
    public enum Mode {

        /// A playground mode.
        case playground

        /// An app mode.
        case app

    }

    // MARK: Initializers

    /// Initialize an instance.
    public init(mode: Mode = .playground) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    /// Callback on instruction button selected.
    internal var onInstructionSelected: (() -> Void)? {
        get { return introView.onInstructionSelected }
        set { introView.onInstructionSelected = newValue }
    }

    /// A mode of `self`.
    private let mode: Mode

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

    /// - SeeAlso: UIViewController.viewDidLoad()
    public override func viewDidLoad() {

        super.viewDidLoad()

        introView.instructionLabel.text = {
            switch mode {
                case .playground: return "TAP NEXT PAGE TO BEGIN"
                case .app: return "TAP HERE TO BEGIN"
            }
        }()

    }

    /// - SeeAlso: UIViewController.viewDidAppear(_:)
    public override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        introView.start()

    }

}
