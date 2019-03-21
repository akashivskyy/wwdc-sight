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
        let sv = SelectionView()

        let v1 = SightView()
        let v2 = SightView()

        cv.leftView = v1
        cv.rightView = v2

        sv.icons = ["🐶", "🐱", "🐮", "🦅", "🐍", "🐟", "🦐"]

        v1.sight = Sight(icon: "👩‍💻", description: "Human", effect: nil, seesMagnetic: false)
//        v2.sight = Sight(icon: "🐶", description: "Dog", effect: .dog(), seesMagnetic: false)
        v2.sight = Sight(icon: "🦅", description: "Eagle", effect: .eagle(), seesMagnetic: true)

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
        vc.view.addSubview(sv)

        cv.translatesAutoresizingMaskIntoConstraints = false
        sv.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addConstraints([
            cv.topAnchor.constraint(equalTo: vc.view.topAnchor),
            cv.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            cv.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
            cv.rightAnchor.constraint(equalTo: sv.leftAnchor),
        ])

        vc.view.addConstraints([
            sv.topAnchor.constraint(equalTo: vc.view.topAnchor),
            sv.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            sv.leftAnchor.constraint(equalTo: cv.rightAnchor),
            sv.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
        ])

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = vc
        window!.makeKeyAndVisible()

        return true
    }

}
