// AppDelegate.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// The app delegate.
@UIApplicationMain fileprivate class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Hierarchy

    private lazy var introViewController: IntroViewController = {
        IntroViewController(mode: .app)
    }()

    private lazy var mainViewController: MainViewController = {
        MainViewController()
    }()

    // MARK: UIApplicationDelegate

    /// - SeeAlso: UIApplicationDelegate.window
    @objc fileprivate var window: UIWindow?

    /// - SeeAlso: UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)
    fileprivate func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let humanIcons = ["🧔", "👩", "👩‍💻", "👨‍🎨", "👩‍🔬", "👨‍🍳", "🕵️‍♂️", "👩‍✈️", "👨‍⚖️", "👨‍🔧"]
        let human = Sight.nocturnal(icons: humanIcons, name: "Human", dayEffect: .human(day: true), nightEffect: .human(day: false), magnetic: false)

        let dog = Sight.nocturnal(icons: ["🐶"], name: "Dog", dayEffect: .dog(day: true), nightEffect: .dog(day: false), magnetic: false)
        let cat = Sight.nocturnal(icons: ["🐈"], name: "Cat", dayEffect: .cat(day: true), nightEffect: .cat(day: false), magnetic: false)
        let eagle = Sight.nocturnal(icons: ["🦅"], name: "Eagle", dayEffect: .eagle(day: true), nightEffect: .eagle(day: false), magnetic: true)
        let bull = Sight.nocturnal(icons: ["🐂"], name: "Bull", dayEffect: .bull(day: true), nightEffect: .bull(day: false), magnetic: false)
        let snake = Sight.nocturnal(icons: ["🐍"], name: "Snake", dayEffect: .snake(day: true), nightEffect: .snake(day: false), magnetic: false)
        let bee = Sight.nocturnal(icons: ["🐝"], name: "Bee", dayEffect: .bee(day: true), nightEffect: .bee(day: false), magnetic: false)

        introViewController.onInstructionSelected = { [unowned self] in
            self.window!.rootViewController = self.mainViewController
        }

        mainViewController.leftSight = human
        mainViewController.rightSights = [dog, cat, eagle, bull, snake, bee]

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = introViewController
        window!.makeKeyAndVisible()

        return true

    }

}
