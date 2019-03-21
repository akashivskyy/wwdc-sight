// AppDelegate.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import simd
import CoreImage
import CoreMotion
import CoreLocation
import UIKit


@UIApplicationMain fileprivate class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var c = Capturer(position: .back)
    let m = CMMotionManager()
    let l = CLLocationManager()

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

//        let n = UILabel(frame: .zero)
//        n.text = "N"
//        n.font = .systemFont(ofSize: 38)
//        n.textColor = .blue
//        n.frame.origin.y = 30
//        n.sizeToFit()

        let n = UIImageView()
        n.image = UIImage(named: "pole")
        n.tintColor = .blue
//        n.alpha = 0.5
        n.sizeToFit()

        let s = UIImageView()
        s.image = UIImage(named: "pole")
        s.tintColor = .red
//        s.alpha = 0.5
        s.sizeToFit()

//        let s = UILabel(frame: .zero)
//        s.text = "S"
//        s.font = .systemFont(ofSize: 38)
//        s.textColor = .red
//        s.frame.origin.y = 30
//        s.sizeToFit()

        cv.addSubview(n)
        cv.addSubview(s)

        let q = OperationQueue()

        let w = UIScreen.main.bounds.width
//        let d: CGFloat = 10
//
//        let a = w / (2 * d - 360)
//        let b = w / 2
//        let a = UIScreen.main.bounds.width / 360
//        let b = -350 * a

        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true, block: { _ in
            if let heading = self.l.heading {
                let h = CGFloat(heading.magneticHeading < 180 ? heading.magneticHeading : heading.magneticHeading - 360)
                n.frame.origin.x = ((w / 2) - (h / 45) * (w / 2)) - (n.bounds.midX)

                let h2 = CGFloat(heading.magneticHeading) - 180
//                let h2 = CGFloat(heading.magneticHeading < 180 ? heading.magneticHeading - 180 : heading.magneticHeading - 360) + 180
                s.frame.origin.x = (w / 2) - (h2 / 45) * (w / 2) - (s.bounds.midX)
//                n.frame.origin.x = CGFloat(h.magneticHeading) * a + b
            }
        })

        l.headingOrientation = .portrait
        l.startUpdatingHeading()

//        mm.addObserver(<#T##observer: NSObject##NSObject#>, forKeyPath: <#T##String#>, options: <#T##NSKeyValueObservingOptions#>, context: <#T##UnsafeMutableRawPointer?#>)
//        m.startMagnetometerUpdates(to: q) { (data, error) in
//            if let data = data {
//                print("x", data.magneticField.x, "y", data.magneticField.y, "z", data.magneticField.z)
//            }
//        }

//        m.startDeviceMotionUpdates(to: q) { motion, _ in
//
//            if let motion = motion {
//                print(motion.magneticField)
//            }
//
//        }

        vc.view.addConstraints([
            cv.topAnchor.constraint(equalTo: vc.view.topAnchor),
            cv.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
            cv.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            cv.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
        ])

        return true
    }

}
