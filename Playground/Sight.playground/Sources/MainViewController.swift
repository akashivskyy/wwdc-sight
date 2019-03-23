// MainViewController.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// Main view controller of the playground.
public final class MainViewController: UIViewController {

    // MARK: Types

    /// Represents the mode of preview.
    fileprivate enum Mode {

        /// Dat mode.
        case day

        /// Night mode.
        case night

    }

    // MARK: Initializers

    /// Initialize an instance.
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    /// A constant left-hand-side sight to compare.
    public var leftSight: Sight = .default {
        didSet {
            updateCurrentSights()
        }
    }

    /// An array of right-hand-side sights to compare.
    public var rightSights: [Sight] = [] {
        didSet {
            updateDockIcons()
            updateCurrentSights()
        }
    }

    /// The current mode of preview.
    private var currentMode: Mode = .day

    /// The current right-hand-side sight index.
    private var currentIndex: Int = 0

    /// The current right-hand-side sight.
    private var currentRightSight: Sight {
        if currentIndex < rightSights.count {
            return rightSights[currentIndex]
        } else {
            return .default
        }
    }

    /// The current left-hand-side sight descripor.
    private var currentLeftSightDescriptor: SightDescriptor {
        if currentMode == .night && currentSightsAreNocturnal {
            return leftSight.sightSet.night
        } else {
            return leftSight.sightSet.day
        }
    }

    /// The current right-hand-side sight descripor.
    private var currentRightSightDescriptor: SightDescriptor {
        if currentMode == .night && currentSightsAreNocturnal {
            return currentRightSight.sightSet.night
        } else {
            return currentRightSight.sightSet.day
        }
    }

    /// Whether the current sights are both nocturnal.
    private var currentSightsAreNocturnal: Bool {
        return leftSight.sightSet.isNocturnal && currentRightSight.sightSet.isNocturnal
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
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /// - SeeAlso: UIViewController.loadView()
    public override func loadView() {

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
    public override func viewDidLoad() {

        super.viewDidLoad()

        mainView.dockView.onNewSelectedIndex = { [unowned self] index in
            self.currentIndex = index
            self.updateCurrentSights()
        }

        mainView.dockView.onDaySelected = { [unowned self] in
            self.currentMode = .day
            self.updateCurrentSights()
        }

        mainView.dockView.onNightSelected = { [unowned self] in
            self.currentMode = .night
            self.updateCurrentSights()
        }

        mainView.dockView.onSwitchSelected = { [unowned self] in
            self.cameraCapturer.position.toggle()
            self.updateCurrentSights()
        }

    }

    /// - SeeAlso: UIViewController.viewWillAppear(_:)
    public override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        cameraCapturer.start { [unowned mainView] in
            mainView.leftView.cameraPixelBuffer = $0
            mainView.rightView.cameraPixelBuffer = $0
        }

        magneticCapturer.start { [unowned mainView] in
            mainView.leftView.magneticHeading = $0
            mainView.rightView.magneticHeading = $0
        }

        updateDockIcons()
        updateCurrentSights()

    }

    /// - SeeAlso: UIViewController.viewDidDisappear(_:)
    public override func viewDidDisappear(_ animated: Bool) {

        super.viewDidDisappear(animated)

        cameraCapturer.stop()
        magneticCapturer.stop()

    }

    private func updateDockIcons() {

        mainView.dockView.icons = rightSights.map { $0.icon }

    }

    /// Reconfigure the view controller based on current sight.
    private func updateCurrentSights() {

        mainView.dockView.isDayNightButtonEnabled = currentSightsAreNocturnal

        mainView.leftView.sightDescriptor = currentLeftSightDescriptor
        mainView.rightView.sightDescriptor = currentRightSightDescriptor

        mainView.leftView.icon = leftSight.icon
        mainView.rightView.icon = currentRightSight.icon

        mainView.leftView.cameraDevicePosition = cameraCapturer.position
        mainView.rightView.cameraDevicePosition = cameraCapturer.position

        mainView.leftView.magneticDevicePosition = cameraCapturer.position
        mainView.rightView.magneticDevicePosition = cameraCapturer.position

    }

    /// - SeeAlso: UIViewController.viewWillTransition(to:with:)
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
            self.mainView.leftView.cameraOrientation = self.interfaceOrientation
            self.mainView.rightView.cameraOrientation = self.interfaceOrientation
            self.magneticCapturer.orientation = self.interfaceOrientation
        }
    }

}
