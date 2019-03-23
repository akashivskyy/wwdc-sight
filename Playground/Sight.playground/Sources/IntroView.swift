// IntroViewController.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// Intro view of the playground.
internal final class IntroView: UIView {

    // MARK: Initializers

    /// Initialize an instance.
    internal init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    private lazy var eyesImages: [UIImage] = {
        (1...5).flatMap { index in
            ["dog", "cat", "bull", "eagle", "snake", "bee"].map {
                UIImage.init(contentsOfFile: Bundle.main.path(forResource: "\($0)-\(index)", ofType: "jpg")!)!
//                UIImage.init(contentsOfFile: Bundle.main.url(forResource: , withExtension: "jpg")!)!
//                UIImage(named: "\($0)-\(index)")!
            }
        }
    }()

    private lazy var eyesImageView: UIImageView = {
        with(UIImageView()) {
            $0.animationImages = eyesImages
            $0.contentMode = .scaleAspectFit
        }
    }()

    // MARK: Lifecycle

    /// Set up view hierarchy.
    private func setup() {

        addSubview(eyesImageView)

        eyesImageView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            eyesImageView.topAnchor.constraint(equalTo: self.topAnchor),
            eyesImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            eyesImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            eyesImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

    }

    internal func start() {

        let phaseOneDelay: Double = 0
        let phaseOneDuration = 0.1 * Double(eyesImages.count)

        let phaseTwoDelay = phaseOneDelay + phaseOneDuration
        let phaseTwoDuration = 0.2 * Double(self.eyesImages.count)

        let phaseThreeDelay = phaseTwoDelay + phaseTwoDuration
        let phaseThreeDuration = 0.4 * Double(self.eyesImages.count)

        let phaseFourDelay = phaseThreeDelay + phaseThreeDuration
        let phaseFourDuration = 0.8 * Double(self.eyesImages.count)

        Timer.scheduledTimer(withTimeInterval: phaseOneDelay, repeats: false) { [unowned self] _ in
            self.eyesImageView.animationDuration = phaseOneDuration
            self.eyesImageView.startAnimating()
        }

        Timer.scheduledTimer(withTimeInterval: phaseTwoDelay, repeats: false) { [unowned self] _ in
            self.eyesImageView.animationDuration = phaseTwoDuration
            self.eyesImageView.startAnimating()
        }

        Timer.scheduledTimer(withTimeInterval: phaseThreeDelay, repeats: false) { [unowned self] _ in
            self.eyesImageView.animationDuration = phaseThreeDuration
            self.eyesImageView.startAnimating()
        }

        Timer.scheduledTimer(withTimeInterval: phaseFourDelay, repeats: false) { [unowned self] _ in
            self.eyesImageView.animationDuration = phaseFourDuration
            self.eyesImageView.startAnimating()
        }

    }

}
