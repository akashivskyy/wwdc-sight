// SelectionView.swift
// Copyright © 2019 Adrian Kashivskyy. All rights reserved.

import UIKit

/// View for selecting a sight preset.
internal final class SelectionView: UIView {

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
            reconfigure()
        }
    }

    /// The currently selected index.
    internal var selectedIndex: Int = 0 {
        didSet {
            reselect()
            onSelectedIndex?(selectedIndex)
        }
    }

    /// Callback on new selected index.
    internal var onSelectedIndex: ((Int) -> Void)?

    // MARK: Hierarchy

    private lazy var buttonsStackView: UIStackView = {
        with(UIStackView()) {
            $0.axis = .vertical
            $0.spacing = 24
        }
    }()

    private lazy var indicatorsStackView: UIStackView = {
        with(UIStackView()) {
            $0.axis = .vertical
            $0.spacing = 24
        }
    }()

    private func makeButton(icon: String) -> UIButton {
        return with(UIButton(type: .system)) {

            $0.titleLabel!.font = .systemFont(ofSize: 32)
            $0.setTitle(icon, for: .normal)
            $0.addTarget(self, action: #selector(buttonDidTouchUpInside), for: .touchUpInside)

            $0.translatesAutoresizingMaskIntoConstraints = false

            $0.addConstraints([
                $0.widthAnchor.constraint(equalToConstant: 44),
                $0.heightAnchor.constraint(equalToConstant: 44),
            ])

        }
    }

    private func makeIndicator() -> UIImageView {
        return with(UIImageView()) {

            $0.image = UIImage(named: "indicator")
            $0.contentMode = .center
            $0.tintColor = .white

            $0.translatesAutoresizingMaskIntoConstraints = false

            $0.addConstraints([
                $0.widthAnchor.constraint(equalToConstant: 6),
                $0.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
    }

    // MARK: Lifecycle

    /// Set up view hierarchy.
    private func setup() {

        backgroundColor = .black

        addSubview(buttonsStackView)
        addSubview(indicatorsStackView)

        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        indicatorsStackView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            buttonsStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            buttonsStackView.rightAnchor.constraint(equalTo: indicatorsStackView.leftAnchor, constant: -4),
            buttonsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])

        addConstraints([
            indicatorsStackView.topAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            indicatorsStackView.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            indicatorsStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

    }

    /// Reconfigure view hierarchy based on available icons.
    private func reconfigure() {

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

        selectedIndex = 0
        reselect()

    }

    // MARK: Selection

    /// Reset the selection.
    private func reselect() {

        guard selectedIndex < icons.count, !icons.isEmpty else { return }
        guard buttonsStackView.arrangedSubviews.count == icons.count else { return }
        guard indicatorsStackView.arrangedSubviews.count == icons.count else { return }

        let selectedButton = buttonsStackView.arrangedSubviews[selectedIndex]
        let selectedIndicator = indicatorsStackView.arrangedSubviews[selectedIndex]
        let unselectedButtons = buttonsStackView.arrangedSubviews.filter { $0 !== selectedButton }
        let unselectedIndicators = indicatorsStackView.arrangedSubviews.filter { $0 !== selectedIndicator }

        UIView.animate(withDuration: 0.15) {
            selectedButton.alpha = 1
            selectedIndicator.alpha = 1
            unselectedButtons.forEach { $0.alpha = 0.4 }
            unselectedIndicators.forEach { $0.alpha = 0 }
        }

    }

    @objc private func buttonDidTouchUpInside(_ button: UIButton) {
        selectedIndex = buttonsStackView.arrangedSubviews.firstIndex(of: button)!
    }

}
