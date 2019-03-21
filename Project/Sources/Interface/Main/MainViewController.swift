// MainViewController.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// Main view controller of the playground.
internal final class MainViewController: UIViewController {

    // MARK: Initializers

    /// Initialize an instance.
    internal init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    /// A constant left-hand-side sight to compare.
    internal var leftSight: Sight = .default {
        didSet {
            reconfigure()
        }
    }

    /// An array of right-hand-side sights to compare.
    internal var rightRights: [Sight] = [.default] {
        didSet {
            reconfigure()
        }
    }

    /// The camera capturer instance.
    private lazy var cameraCapturer: CameraCapturer = {
        CameraCapturer()
    }()

    /// The magnetic capturer instance.
    private lazy var magneticCapturer: MagneticCapturer = {
        MagneticCapturer()
    }()

    // MARK: Hierarchy

    private lazy var mainView: MainView = {
        MainView()
    }()

    // MARK: Lifecycle

    /// - SeeAlso: UIViewController.preferredStatusBarStyle
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /// - SeeAlso: UIViewController.loadView()
    internal override func loadView() {

        super.loadView()

        view.addSubview(mainView)

        mainView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
        ])

    }

    /// - SeeAlso: UIViewController.viewDidLoad()
    internal override func viewDidLoad() {

        super.viewDidLoad()

//        mainView.dockView.onNewIconIndex = { [unowned self] in
//            self.mainView.leftView.sight = self.sights[$0].left
//            self.mainView.rightView.sight = self.sights[$0].right
//        }

//        mainView.dockView.onSwitchSelected = { [unowned self] in
//            self.mainView.leftView.

//        }

    }

    /// - SeeAlso: UIViewController.viewWillAppear(_:)
    internal override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        cameraCapturer.start { [unowned mainView] in
            mainView.leftView.cameraPixelBuffer = $0
            mainView.rightView.cameraPixelBuffer = $0
        }

        magneticCapturer.start { [unowned mainView] in
            mainView.leftView.magneticHeading = $0
            mainView.rightView.magneticHeading = $0
        }

        reconfigure()

    }

    /// - SeeAlso: UIViewController.viewDidDisappear(_:)
    internal override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)

        cameraCapturer.stop()
        magneticCapturer.stop()

    }

    /// Reconfigure the view controller based on sight preset pairs.
    private func reconfigure() {
//        mainView.leftView.sightDescriptor = leftSight.
//        mainView.dockView.icons = rightRights.map { $0.icon }
    }

}
