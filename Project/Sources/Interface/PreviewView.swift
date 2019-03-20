//
//  PreviewView.swift
//  Perception
//
//  Created by Adrian Kashivskyy on 20/03/2019.
//  Copyright © 2019 Adrian Kashivskyy. All rights reserved.
//

import CoreVideo
import UIKit

internal final class PreviewView: UIView {

    internal init(preset: Preset? = nil) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal var preset: Preset? {
        didSet {
            reapplyPreset()
        }
    }

    internal var pixelBuffer: CVPixelBuffer? {
        get { return renderView.pixelBuffer }
        set { renderView.pixelBuffer = newValue }
    }

    private lazy var renderView: RenderView = {
        RenderView()
    }()

    private lazy var iconLabel: UILabel = {
        with(UILabel()) {
            $0.numberOfLines = 1
            $0.font = .systemFont(ofSize: 48)
            $0.adjustsFontSizeToFitWidth = true
            $0.textAlignment = .center
        }
    }()

    private func setup() {

        addSubview(renderView)
        addSubview(iconLabel)

        renderView.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            renderView.topAnchor.constraint(equalTo: self.topAnchor),
            renderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            renderView.leftAnchor.constraint(equalTo: self.leftAnchor),
            renderView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])

        addConstraints([
            iconLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            iconLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            iconLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor),
        ])

        reapplyPreset()

    }

    private func reapplyPreset() {
        renderView.filters = preset?.effect?.filters ?? []
        iconLabel.text = preset?.icon
    }

}
