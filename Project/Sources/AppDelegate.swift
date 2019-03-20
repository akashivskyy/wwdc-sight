// AppDelegate.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import simd
import CoreImage
import UIKit

@UIApplicationMain fileprivate class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var c = Capturer(position: .back)

    var v1 = PreviewView()
    var v2 = PreviewView()
    var cv = ComparisonView()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        c.start { buf, _ in
            self.v1.pixelBuffer = buf
            self.v2.pixelBuffer = buf
        }

        let vc = UIViewController()

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = vc
        window!.makeKeyAndVisible()

        cv.leftView = v1
        cv.rightView = v2
        vc.view.addSubview(cv)

        cv.translatesAutoresizingMaskIntoConstraints = false

        v1.preset = Preset.init(icon: "👩‍💻", effect: nil)
        v2.preset = Preset.init(icon: "🐶", effect: .dog())

//        v1.preset = Preset.init(icon: "🌚", effect: .night())
//        v2.preset = Preset.init(icon: "🐱", effect: .cat(night: true))

        vc.view.addConstraints([
            cv.topAnchor.constraint(equalTo: vc.view.topAnchor),
            cv.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
            cv.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            cv.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
        ])

        return true
    }

}
