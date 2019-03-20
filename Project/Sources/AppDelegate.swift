// AppDelegate.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import simd
import CoreImage
import UIKit

@UIApplicationMain fileprivate class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var c = Capturer(position: .back)

    var v = RenderView()
    var v2 = RenderView()
    var vv = ComparisonView()

    var a: Float = 0.5 {
        didSet {
            resetf()
        }
    }
    var b: Float = 1.2 {
        didSet {
            resetf()
        }
    }

    var p: float3x3 {

     return float3x3(rows: [
        float3(1, 0, 0),
        //            float3(0.494207, 0, 1.24827),
        float3(a, 0, b),
        float3(0, 0, 1)
    ])
    }

    var cube: CIFilter {

        typealias RGB = (r: Float, g: Float, b: Float)
        typealias LMS = (l: Float, s: Float, m: Float)

        let size = 64

        let m = float3x3(rows: [
            float3(17.8824, 43.5161, 4.1193),
            float3(3.4557, 27.1554, 3.8671),
            float3(0.02996, 0.18431, 1.4670)
        ])

        let mi = simd_inverse(m)

        func RGBINIT(r: Int, g: Int, b: Int) -> RGB {
            return (
                r: (Float(r) / Float(size - 1)),
                g: (Float(g) / Float(size - 1)),
                b: (Float(b) / Float(size - 1))
            )
        }

        func RGB2LMS(_ rgb: RGB) -> LMS {
            let n = simd_float3(rgb.r, rgb.g, rgb.b)
            let o = simd_mul(m, n)
            return (l: o.x, m: o.y, s: o.z)
        }

        func PROTA(_ lms: LMS) -> LMS {
            let n = simd_float3(lms.l, lms.m, lms.s)
            let o = simd_mul(p, n)
            return (l: o.x, m: o.y, s: o.z)
        }

        func LMS2RGB(_ lms: LMS) -> RGB {
            let n = simd_float3(lms.l, lms.m, lms.s)
            let o = simd_mul(mi, n)
            return (r: o.x, g: o.y, b: o.z)
        }

        let data = UnsafeMutableBufferPointer<Float>.allocate(capacity: size * size * size * 4)
        data.initialize(repeating: 0)

        var c = 0;
        for b in 0..<size {
            for g in 0..<size {
                for r in 0..<size {

                    let rgb1 = RGBINIT(r: r, g: g, b: b)
                    let lms = RGB2LMS(rgb1)

                    let pr = PROTA(lms)

                    let rgb2 = LMS2RGB(pr)

                    data[c] = rgb2.r
                    data[c + 1] = rgb2.g
                    data[c + 2] = rgb2.b
                    data[c + 3] = 1
                    c += 4

                }
            }
        }

        let cube = Data.init(buffer: data)

        let f = CIFilter.init(name: "CIColorCube", parameters: [
            "inputCubeData": cube,
            "inputCubeDimension": size,
            ])!

        return f

    }

    func resetf() {

        let blur =  CIFilter.init(name: "CIDiscBlur", parameters: [
            "inputRadius": 6
        ])!

        v2.filters = [cube, blur]

    }

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

        vv.translatesAutoresizingMaskIntoConstraints = false

        let aS = UISlider.init(frame: .init(x: 50, y: 50, width: 300, height: 44))
        let bS = UISlider.init(frame: .init(x: 50, y: 100, width: 300, height: 44))

        aS.minimumValue = 0
        aS.maximumValue = 2

        bS.minimumValue = 0
        bS.maximumValue = 2

        aS.addTarget(self, action: #selector(updateA), for: .valueChanged)
        bS.addTarget(self, action: #selector(updateB), for: .valueChanged)

        vc.view.addSubview(aS)
        vc.view.addSubview(bS)

        resetf()

        vc.view.addConstraints([
            vv.topAnchor.constraint(equalTo: vc.view.topAnchor),
            vv.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
            vv.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            vv.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
        ])

        return true
    }

    @objc func updateA(_ s: UISlider) {
        a = s.value
        print("a", a, "b", b)
    }

    @objc func updateB(_ s: UISlider) {
        b = s.value
        print("a", a, "b", b)
    }

}
