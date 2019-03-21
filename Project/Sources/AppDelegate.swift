// AppDelegate.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

@UIApplicationMain fileprivate class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Hierarchy

    private lazy var mainViewController: MainViewController = {
        MainViewController()
    }()

    // MARK: UIApplicationDelegate

    /// - SeeAlso: UIApplicationDelegate.window
    @objc fileprivate var window: UIWindow?

    fileprivate func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // ["🐶", "🐱", "🐮", "🦅", "🐍", "🐟", "🦐"]
        let human = Sight(icon: "👩‍💻", description: "Human", effect: nil, seesMagnetic: false)
        let dog = Sight(icon: "🐶", description: "Dog", effect: .dog(), seesMagnetic: false)
        let eagle = Sight(icon: "🦅", description: "Eagle", effect: .eagle(), seesMagnetic: true)

        mainViewController.sights = [
            (left: human, right: dog),
            (left: human, right: eagle)
        ]

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = mainViewController
        window!.makeKeyAndVisible()

        return true
    }

}
