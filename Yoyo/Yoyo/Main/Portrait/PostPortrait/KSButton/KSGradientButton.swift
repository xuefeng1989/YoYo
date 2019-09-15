//
//  KSGradientButton.swift
//  Yoyo
//
//  Created by kinsun on 2019/9/15.
//  Copyright © 2019年 dhlg. All rights reserved.
//

import UIKit

open class KSGradientButton: UIButton {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc public let colors: [UIColor]
    
    private let _gradientLayer = {() -> CAGradientLayer in
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [NSNumber(value: 1), NSNumber(value: 1)]
        return gradientLayer
    }()
    
    @objc public convenience init() {
        self.init(frame: .zero, colors: nil)
    }
    
    @objc public init(frame: CGRect, colors: [UIColor]?) {
        if let colors = colors {
            self.colors = colors
        } else {
            self.colors = [.ks_lightMain, .ks_main]
        }
        super.init(frame: frame)
        _gradientLayer.colors = self.colors.map{$0.cgColor}
        layer.insertSublayer(_gradientLayer, at: 0)
        titleLabel?.font = .systemFont(ofSize: 14.0)
        setTitleColor(.ks_white, for: .normal)
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        _gradientLayer.frame = layer.bounds
    }
    
}
