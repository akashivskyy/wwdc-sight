// AppDelegate.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import simd
import CoreImage
import CoreMotion
import CoreLocation
import UIKit


@UIApplicationMain fileprivate class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let cc = CameraCapturer()
    let mc = MagneticCapturer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let cv = ComparisonView()
        let v1 = SightView()
        let v2 = SightView()

        cv.leftView = v1
        cv.rightView = v2

        v1.sight = Sight(icon: "👩‍💻", description: "Human", effect: nil, seesMagnetic: false)
        v2.sight = Sight(icon: "🐶", description: "Dog", effect: .dog(), seesMagnetic: true)

        cc.start {
            v1.cameraPixelBuffer = $0
            v2.cameraPixelBuffer = $0
        }

        mc.start {
            v1.magneticHeading = $0
            v2.magneticHeading = $0
        }

        let vc = UIViewController()

        vc.view.addSubview(cv)

        cv.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addConstraints([
            cv.topAnchor.constraint(equalTo: vc.view.topAnchor),
            cv.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
            cv.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            cv.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
        ])

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = vc
        window!.makeKeyAndVisible()

        return true
    }

}
