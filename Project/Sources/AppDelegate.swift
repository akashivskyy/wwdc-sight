// AppDelegate.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

@UIApplicationMain fileprivate class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var c = Capturer(position: .back)

    var v = RenderView()
    var v2 = RenderView()
    var vv = ComparisonView()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        c.start { buf, _ in
            self.v.pixelBuffer = buf
            self.v2.pixelBuffer = buf
        }

        let vc = UIViewController()

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = vc
        window!.makeKeyAndVisible()

        vv.leftView = v
        vv.rightView = v2
        vc.view.addSubview(vv)

//        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vv.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addConstraints([
            vv.topAnchor.constraint(equalTo: vc.view.topAnchor),
            vv.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
            vv.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            vv.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
        ])

        return true
    }

}
