// IntroViewController.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import QuartzCore
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

    // MARK: Hierarchy

    private lazy var eyesImages: [UIImage] = {
        (1...5).flatMap { index in
            ["dog", "cat", "bull", "eagle", "snake", "bee"].map {
                UIImage(contentsOfFile: Bundle.main.path(forResource: "\($0)-\(index)", ofType: "jpg")!)!
            }
        }
    }()

    private lazy var eyesImageView: UIImageView = {
        with(UIImageView()) {
            $0.animationImages = eyesImages
            $0.contentMode = .scaleAspectFill
        }
    }()

    private lazy var dimView: UIView = {
        with(UIView()) {
            $0.backgroundColor = UIColor(red: 18.0 / 255, green: 26.0 / 255, blue: 46.0 / 255, alpha: 1)
        }
    }()

    private lazy var logoImageView: UIView = {
        with(UIImageView()) {
            $0.image = UIImage(named: "logo")
            $0.contentMode = .scaleAspectFit
        }
    }()

    private lazy var taglineLabel: UILabel = {
        with(UILabel()) {
            $0.font = .systemFont(ofSize: 32, weight: .bold)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.text = "WWDC19 Scholarship Submission"
        }
    }()

    private lazy var byLabel: UILabel = {
        with(UILabel()) {
            $0.font = .systemFont(ofSize: 24, weight: .regular)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.text = "by"
        }
    }()

    private lazy var photoImageView: UIView = {
        with(UIImageView()) {
            $0.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "akashivskyy", ofType: "jpg")!)!
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 3
            $0.layer.masksToBounds = true
        }
    }()

    private lazy var nameLabel: UILabel = {
        with(UILabel()) {
            $0.font = .systemFont(ofSize: 32, weight: .light)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.text = "Adrian Kashivskyy"
        }
    }()

    private lazy var instructionLabel: UILabel = {
        with(UILabel()) {
            $0.font = .systemFont(ofSize: 14, weight: .bold)
            $0.textColor = UIColor(red: 22.0 / 255, green: 220.0 / 255, blue: 234.0 / 255, alpha: 1)
            $0.textAlignment = .center
            $0.text = "TAP NEXT PAGE TO BEGIN"
        }
    }()

    private lazy var instructionArrowLabel: UILabel = {
        with(UILabel()) {
            $0.font = .systemFont(ofSize: 14, weight: .bold)
            $0.textColor = UIColor(red: 22.0 / 255, green: 220.0 / 255, blue: 234.0 / 255, alpha: 1)
            $0.textAlignment = .left
            $0.text = "→"
        }
    }()

    private lazy var instructionArrowConstraint: NSLayoutConstraint = {
        instructionArrowLabel.leftAnchor.constraint(equalTo: instructionLabel.rightAnchor, constant: 8)
    }()

    private lazy var stackView: UIStackView = {
        with(UIStackView()) {
            $0.axis = .vertical
            $0.alignment = .center
        }
    }()

    // MARK: Lifecycle

    /// Set up view hierarchy.
    private func setup() {

        let logoHeight: CGFloat = 120
        let photoSize: CGFloat = 120

        photoImageView.layer.cornerRadius = photoSize / 2

        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(taglineLabel)
        stackView.addArrangedSubview(byLabel)
        stackView.addArrangedSubview(photoImageView)
        stackView.addArrangedSubview(nameLabel)

        stackView.setCustomSpacing(16, after: logoImageView)
        stackView.setCustomSpacing(32, after: taglineLabel)
        stackView.setCustomSpacing(32, after: byLabel)
        stackView.setCustomSpacing(8, after: photoImageView)

        addSubview(eyesImageView)
        addSubview(dimView)
        addSubview(stackView)
        addSubview(instructionLabel)
        addSubview(instructionArrowLabel)

        eyesImageView.translatesAutoresizingMaskIntoConstraints = false
        dimView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionArrowLabel.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            eyesImageView.topAnchor.constraint(equalTo: self.topAnchor),
            eyesImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            eyesImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            eyesImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        addConstraints([
            dimView.topAnchor.constraint(equalTo: self.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dimView.leftAnchor.constraint(equalTo: self.leftAnchor),
            dimView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        addConstraints([
            stackView.topAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stackView.leftAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.rightAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).withPriority(.defaultHigh),
            stackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor).withPriority(.defaultHigh),
        ])

        addConstraints([
            logoImageView.heightAnchor.constraint(equalToConstant: logoHeight),
        ])

        addConstraints([
            photoImageView.widthAnchor.constraint(equalToConstant: photoSize),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
        ])

        addConstraints([
            instructionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            instructionLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])

        addConstraints([
            instructionArrowConstraint,
            instructionArrowLabel.firstBaselineAnchor.constraint(equalTo: instructionLabel.firstBaselineAnchor),
        ])

    }

    /// Start animations.
    internal func start() {

        let phaseOneDelay: Double = 0
        let phaseOneDuration = 0.1 * Double(eyesImages.count)

        let phaseTwoDelay = phaseOneDelay + phaseOneDuration
        let phaseTwoDuration = 0.2 * Double(self.eyesImages.count)

        let phaseThreeDelay = phaseTwoDelay + phaseTwoDuration
        let phaseThreeDuration = 0.4 * Double(self.eyesImages.count)

        let phaseFourDelay = phaseThreeDelay + phaseThreeDuration
        let phaseFourDuration = 0.8 * Double(self.eyesImages.count)

        let dimDelay = phaseTwoDelay / 3
        let dimDuration = 3.0

        let logoDelay = dimDelay + dimDuration / 3
        let logoDuration = 1.0

        let contentDelay = logoDelay + logoDuration
        let contentDuration = 1.0

        let instructionDelay = contentDelay + contentDuration + 1.0
        let instructionDuration = 3.0

        dimView.alpha = 0.0
        logoImageView.alpha = 0.0
        taglineLabel.alpha = 0.0
        byLabel.alpha = 0.0
        photoImageView.alpha = 0.0
        nameLabel.alpha = 0.0
        instructionLabel.alpha = 0.0
        instructionArrowLabel.alpha = 0.0

        Timer.scheduledTimer(
            withTimeInterval: phaseOneDelay,
            repeats: false,
            block: { [unowned self] _ in
                self.eyesImageView.animationDuration = phaseOneDuration
                self.eyesImageView.startAnimating()
            }
        )

        Timer.scheduledTimer(
            withTimeInterval: phaseTwoDelay,
            repeats: false,
            block: { [unowned self] _ in
                self.eyesImageView.animationDuration = phaseTwoDuration
                self.eyesImageView.startAnimating()
            }
        )

        Timer.scheduledTimer(
            withTimeInterval: phaseThreeDelay,
            repeats: false,
            block: { [unowned self] _ in
                self.eyesImageView.animationDuration = phaseThreeDuration
                self.eyesImageView.startAnimating()
            }
        )

        Timer.scheduledTimer(
            withTimeInterval: phaseFourDelay,
            repeats: false,
            block: { [unowned self] _ in
                self.eyesImageView.animationDuration = phaseFourDuration
                self.eyesImageView.startAnimating()
            }
        )

        UIView.animate(
            withDuration: dimDuration,
            delay: dimDelay,
            animations: { [unowned self] in
                self.dimView.alpha = 0.9
            }
        )

        UIView.animate(
            withDuration: logoDuration,
            delay: logoDelay,
            animations: { [unowned self] in
                self.logoImageView.alpha = 1.0
            }
        )

        UIView.animate(
            withDuration: contentDuration,
            delay: contentDelay,
            animations: { [unowned self] in
                self.taglineLabel.alpha = 1.0
                self.byLabel.alpha = 1.0
                self.photoImageView.alpha = 1.0
                self.nameLabel.alpha = 1.0
            }
        )

        UIView.animate(
            withDuration: instructionDuration,
            delay: instructionDelay,
            animations: { [unowned self] in
                self.instructionLabel.alpha = 1.0
                self.instructionArrowLabel.alpha = 1.0
            }
        )

        restartInstructionArrowAnimation()

    }

    /// Restart animation of instruction arrow.
    private func restartInstructionArrowAnimation() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: { [unowned self] in
                self.instructionArrowConstraint.constant = 16
                self.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.instructionArrowConstraint.constant = 8
                    self?.layoutIfNeeded()
                    self?.restartInstructionArrowAnimation()
                }
            }
        )
    }

}
