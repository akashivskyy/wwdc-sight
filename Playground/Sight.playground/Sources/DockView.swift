// DockView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// View for selecting a sight preset.
internal final class DockView: UIView {

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

    /// Icons to choose from.
    internal var icons: [String] = [] {
        didSet {
            updateIcons()
        }
    }

    /// The currently selected index.
    internal var selectedIconIndex: Int = 0 {
        didSet {
            updateSelection()
            onNewSelectedIndex?(selectedIconIndex)
        }
    }


    internal var isDayNightButtonEnabled: Bool = false {
        didSet {
            updateControls()
        }
    }

    /// Callback on new selected index.
    internal var onNewSelectedIndex: ((Int) -> Void)?

    internal var onNightSelected: (() -> Void)?

    internal var onDaySelected: (() -> Void)?

    internal var onSwitchSelected: (() -> Void)?

    // MARK: Hierarchy

    private lazy var buttonsStackView: UIStackView = {
        with(UIStackView()) {
            $0.axis = .vertical
            $0.spacing = 16
        }
    }()

    private func makeButton(icon: String) -> UIButton {
        return with(UIButton(type: .system)) {

            $0.titleLabel!.font = .systemFont(ofSize: 32, weight: .bold)
            $0.setTitleColor(.white, for: .normal)

            $0.setTitle(icon, for: .normal)
            $0.addTarget(self, action: #selector(iconButtonDidTouchUpInside), for: .touchUpInside)

            $0.translatesAutoresizingMaskIntoConstraints = false

            $0.addConstraints([
                $0.widthAnchor.constraint(equalToConstant: 44),
                $0.heightAnchor.constraint(equalToConstant: 44),
            ])

        }
    }

    private lazy var indicatorsStackView: UIStackView = {
        with(UIStackView()) {
            $0.axis = .vertical
            $0.spacing = 16
        }
    }()

    private func makeIndicator() -> UIImageView {
        return with(UIImageView()) {

            $0.image = UIImage(named: "indicator")!.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .center
            $0.tintColor = .white

            $0.translatesAutoresizingMaskIntoConstraints = false

            $0.addConstraints([
                $0.widthAnchor.constraint(equalToConstant: 6),
                $0.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
    }

    private lazy var controlsStackView: UIStackView = {
        with(UIStackView()) {
            $0.axis = .vertical
            $0.spacing = 8
        }
    }()

    private lazy var dayButton: UIButton = {
        with(UIButton(type: .system)) {

            $0.tintColor = .white
            $0.setImage(UIImage(named: "sun")!.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.addTarget(self, action: #selector(dayButtonDidTouchUpInside), for: .touchUpInside)

            $0.translatesAutoresizingMaskIntoConstraints = false

            $0.addConstraints([
                $0.widthAnchor.constraint(equalToConstant: 44),
                $0.heightAnchor.constraint(equalToConstant: 44),
            ])

        }
    }()

    private lazy var nightButton: UIButton = {
        with(UIButton(type: .system)) {

            $0.tintColor = .white
            $0.setImage(UIImage(named: "moon")!.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.addTarget(self, action: #selector(nightButtonDidTouchUpInside), for: .touchUpInside)

            $0.translatesAutoresizingMaskIntoConstraints = false

            $0.addConstraints([
                $0.widthAnchor.constraint(equalToConstant: 44),
                $0.heightAnchor.constraint(equalToConstant: 44),
            ])

        }
    }()

    private lazy var switchButton: UIButton = {
        with(UIButton(type: .system)) {

            $0.tintColor = .white
            $0.setImage(UIImage(named: "switch")!.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.addTarget(self, action: #selector(switchButtonDidTouchUpInside), for: .touchUpInside)

            $0.translatesAutoresizingMaskIntoConstraints = false

            $0.addConstraints([
                $0.widthAnchor.constraint(equalToConstant: 44),
                $0.heightAnchor.constraint(equalToConstant: 44),
            ])

        }
    }()

    // MARK: Lifecycle

    /// Set up view hierarchy.
    private func setup() {

        backgroundColor = .black

        dayButton.isHidden = true

        controlsStackView.addArrangedSubview(dayButton)
        controlsStackView.addArrangedSubview(nightButton)
        controlsStackView.addArrangedSubview(switchButton)

        addSubview(buttonsStackView)
        addSubview(indicatorsStackView)
        addSubview(controlsStackView)

        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        indicatorsStackView.translatesAutoresizingMaskIntoConstraints = false
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: controlsStackView.topAnchor, constant: -16),
            buttonsStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            buttonsStackView.rightAnchor.constraint(equalTo: indicatorsStackView.leftAnchor, constant: -4),
            buttonsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).withPriority(.defaultHigh),
        ])

        addConstraints([
            indicatorsStackView.topAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            indicatorsStackView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            indicatorsStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        addConstraints([
            controlsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            controlsStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            controlsStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        ])

    }

    private func updateIcons() {

        buttonsStackView.arrangedSubviews.forEach {
            buttonsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        indicatorsStackView.arrangedSubviews.forEach {
            indicatorsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        icons.forEach {
            buttonsStackView.addArrangedSubview(makeButton(icon: $0))
            indicatorsStackView.addArrangedSubview(makeIndicator())
        }

        selectedIconIndex = 0

    }

    private func updateControls() {

        dayButton.alpha = isDayNightButtonEnabled ? 1 : 0.5
        nightButton.alpha = isDayNightButtonEnabled ? 1 : 0.5

        dayButton.isEnabled = isDayNightButtonEnabled
        nightButton.isEnabled = isDayNightButtonEnabled

    }

    // MARK: Selection

    /// Reset the selection.
    private func updateSelection() {

        guard selectedIconIndex < icons.count, !icons.isEmpty else { return }
        guard buttonsStackView.arrangedSubviews.count == icons.count else { return }
        guard indicatorsStackView.arrangedSubviews.count == icons.count else { return }

        let selectedButton = buttonsStackView.arrangedSubviews[selectedIconIndex]
        let selectedIndicator = indicatorsStackView.arrangedSubviews[selectedIconIndex]
        let unselectedButtons = buttonsStackView.arrangedSubviews.filter { $0 !== selectedButton }
        let unselectedIndicators = indicatorsStackView.arrangedSubviews.filter { $0 !== selectedIndicator }

        UIView.animate(withDuration: 0.15) {
            selectedButton.alpha = 1
            selectedIndicator.alpha = 1
            unselectedButtons.forEach { $0.alpha = 0.4 }
            unselectedIndicators.forEach { $0.alpha = 0 }
        }

    }

    // MARK: Actions

    @objc private func iconButtonDidTouchUpInside(_ button: UIButton) {
        selectedIconIndex = buttonsStackView.arrangedSubviews.firstIndex(of: button)!
    }

    @objc private func dayButtonDidTouchUpInside(_ button: UIButton) {
        dayButton.isHidden = true
        nightButton.isHidden = false
        onDaySelected?()
    }

    @objc private func nightButtonDidTouchUpInside(_ button: UIButton) {
        dayButton.isHidden = false
        nightButton.isHidden = true
        onNightSelected?()
    }

    @objc private func switchButtonDidTouchUpInside(_ button: UIButton) {
        onSwitchSelected?()
    }

}
