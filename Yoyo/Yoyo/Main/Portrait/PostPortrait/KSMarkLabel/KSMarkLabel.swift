//
//  KSMarkLabel.swift
//  KSMediaPickerDemo
//
//  Created by kinsun on 2019/9/12.
//  Copyright © 2019年 kinsun. All rights reserved.
//

import UIKit

open class KSMarkLabel: UIControl {
    
    private class _contentView: CALayer {
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        fileprivate static let _font = UIFont.systemFont(ofSize: 11.0)
        fileprivate static let _margin = CGFloat(4.0)
        
        private let _iconLayer = {() -> CALayer in
            let iconLayer = CALayer()
            iconLayer.contentsGravity = .resizeAspect
            return iconLayer
        }()
        
        private let _textLayer = {() -> CATextLayer in
            let textLayer = CATextLayer()
            textLayer.alignmentMode = .left
            textLayer.foregroundColor = UIColor.ks_white.cgColor
            textLayer.isWrapped = true
            textLayer.contentsScale = UIScreen.main.scale
            let fontRef = CGFont(_font.fontName as CFString)
            textLayer.font = fontRef
            textLayer.fontSize = _font.pointSize
            return textLayer
        }()
        
        public override init(layer: Any) {
            super.init(layer: layer)
        }
        
        public override init() {
            super.init()
            masksToBounds = true
            borderColor = UIColor.ks_white.cgColor
            borderWidth = 1.0
            backgroundColor = UIColor.ks_lightGray.withAlphaComponent(0.5).cgColor
            
            addSublayer(_iconLayer)
            addSublayer(_textLayer)
        }
        
        public var text: String? {
            set {
                _textLayer.string = newValue
            }
            get {
                return _textLayer.string as? String
            }
        }
        
        public var icon: UIImage? {
            didSet {
                if let icon = icon?.cgImage {
                    _iconLayer.contents = icon
                    _iconLayer.isHidden = false
                } else {
                    _iconLayer.isHidden = true
                }
                setNeedsLayout()
            }
        }
        
        public var isTextHidden: Bool {
            set {
                _textLayer.isHidden = newValue
            }
            get {
                return _textLayer.isHidden
            }
        }
        
        override func layoutSublayers() {
            super.layoutSublayers()
            let windowSize = bounds.size
            let windowWidth = windowSize.width
            let windowHeight = windowSize.height
            let margin = _contentView._margin
            
            cornerRadius = windowHeight*0.5
            
            var viewX = margin
            let viewY = margin
            let viewH = windowHeight-viewY*2.0
            var viewW = viewX
            
            if _iconLayer.isHidden {
                viewW = windowWidth-margin*2.0
            } else {
                viewW = viewH
                
                let iconFrame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
                _iconLayer.frame = iconFrame
                
                viewX = iconFrame.maxX+margin
                viewW = windowWidth-viewX-margin
            }
            
            _textLayer.frame = CGRect(x: viewX, y: viewY-1.0, width: viewW, height: viewH)
        }
        
        public func sizeThatFits(_ size: CGSize) -> CGSize {
            let attributes = [NSAttributedString.Key.font: _contentView._font]
            let optins: NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading]
            var k_size = NSString(string: text ?? "").boundingRect(with: size, options: optins, attributes: attributes, context: nil).size
            let margin = _contentView._margin
            if !_iconLayer.isHidden {
                k_size.width += k_size.height+margin
            }
            k_size.width += margin*2.0
            k_size.height += margin*2.0
            return k_size
        }
    }
    
    @objc public enum KSMarkLabelDirection: Int {
        case left
        case right
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let _lineWidth = CGFloat(15.0)
    private static let _backPointRadius = CGFloat(15.0)
    private static let _whitePointRadius = CGFloat(6.0)
    public static let pointCenterX = _backPointRadius*0.5
    
    private let _backPointLayer = {() -> CALayer in
        let backPointLayer = CALayer()
        let radius = _backPointRadius
        backPointLayer.opacity = 0
        backPointLayer.frame = CGRect(origin: .zero, size: CGSize(width: radius, height: radius))
        backPointLayer.cornerRadius = radius*0.5
        backPointLayer.backgroundColor = UIColor.ks_lightGray.withAlphaComponent(0.5).cgColor
        return backPointLayer
    }()
    
    private let _scaleAnimation = {() -> CABasicAnimation in
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.8
        scaleAnimation.repeatCount = Float.greatestFiniteMagnitude
        scaleAnimation.autoreverses = true
        //removedOnCompletion为NO保证app切换到后台动画再切回来时动画依然执行
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.fromValue = NSNumber(value: 1.0)
        scaleAnimation.toValue = NSNumber(value: 0.2)
        return scaleAnimation
    }()

    private let _whitePointLayer = {() -> CALayer in
        let whitePointLayer = CALayer()
        whitePointLayer.backgroundColor = UIColor.ks_white.cgColor
        whitePointLayer.opacity = 0
        let radius = _whitePointRadius
        whitePointLayer.frame = CGRect(origin: .zero, size: CGSize(width: radius, height: radius))
        whitePointLayer.cornerRadius = radius*0.5
        whitePointLayer.masksToBounds = true
        return whitePointLayer
    }()
    
    private let _lineLayer = {() -> CALayer in
        let lineLayer = CALayer()
        lineLayer.opacity = 0
        lineLayer.backgroundColor = UIColor.ks_white.cgColor
        return lineLayer
    }()
    
    private let _contentLayer = _contentView()
    
    open var direction: KSMarkLabelDirection
    
    open func needUpdate(direction: KSMarkLabelDirection) {
        if direction != self.direction {
            CATransaction.begin()
            _realIsUnfolded = false
            _backPointLayer.opacity = 0
            _lineLayer.opacity = 0
            _contentLayer.opacity = 0
            setNeedsLayout()
            CATransaction.setCompletionBlock {[weak self] in
                if let `self` = self {
                    self.direction = direction
                    self.markModel.isRight = direction == .right
                    self.superview?.setNeedsLayout()
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    self.layoutSublayers(of: self.layer)
                    CATransaction.commit()
                    CATransaction.begin()
                    CATransaction.setCompletionBlock {[weak self] in
                        if let `self` = self {
                            self._backPointLayer.opacity = 1
                            self._lineLayer.opacity = 1
                            self._contentLayer.opacity = 1
                            self._realIsUnfolded = true
                            self.setNeedsLayout()
                        }
                    }
                    CATransaction.commit()
                }
            }
            CATransaction.commit()
        }
    }
    
    public let markModel: KSMarkModel
    
    public init(frame: CGRect = .zero, markModel: KSMarkModel) {
        self.markModel = markModel
        _contentLayer.opacity = 0
        direction = markModel.isRight ? .right : .left
        super.init(frame: frame)
        _contentLayer.text = markModel.title
        _contentLayer.icon = UIImage(named: markModel.type.imageName)
        layer.addSublayer(_backPointLayer)
        layer.addSublayer(_whitePointLayer)
        layer.addSublayer(_lineLayer)
        layer.addSublayer(_contentLayer)
    }
    
    private var _realIsUnfolded = false {
        didSet {
            if _realIsUnfolded {
                _backPointLayer.add(_scaleAnimation, forKey: nil)
            } else {
                _backPointLayer.removeAllAnimations()
            }
        }
    }
    
    open var isUnfolded: Bool {
        set {
            if _realIsUnfolded != newValue {
                CATransaction.begin()
                if newValue {
                    _whitePointLayer.opacity = 1
                    CATransaction.setCompletionBlock {[weak self] in
                        if let `self` = self {
                            self._backPointLayer.opacity = 1
                            self._lineLayer.opacity = 1
                            self._contentLayer.opacity = 1
                            self._realIsUnfolded = true
                            self.setNeedsLayout()
                        }
                    }
                } else {
                    _realIsUnfolded = false
                    _backPointLayer.opacity = 0
                    _lineLayer.opacity = 0
                    _contentLayer.opacity = 0
                    setNeedsLayout()
                    CATransaction.setCompletionBlock {[weak self] in
                        if let `self` = self {
                            self._whitePointLayer.opacity = 0
                        }
                    }
                }
                CATransaction.commit()
            }
        }
        get {
            return _realIsUnfolded
        }
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        let windowSize = layer.bounds.size
        let windowWidth = windowSize.width
        let windowHeight = windowSize.height
        
        let backLayerSize = _backPointLayer.bounds.size
        let whitePointSize = _whitePointLayer.bounds.size
        
        var viewX = CGFloat(0.0)
        var viewW = backLayerSize.width
        var viewH = backLayerSize.height
        
        var viewY = (windowHeight-viewH)*0.5
        
        switch direction {
        case .left:
            viewX = windowWidth-viewW
            _backPointLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
            
            viewW = whitePointSize.width
            viewH = whitePointSize.height
            viewY = (windowHeight-viewH)*0.5
            viewX = windowWidth-(backLayerSize.width-viewW)*0.5-viewW
            _whitePointLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
            
            viewH = 1.0
            viewY = (windowHeight-viewH)*0.5
            
            if isUnfolded {
                viewW = KSMarkLabel._lineWidth
                viewX = _whitePointLayer.frame.origin.x-viewW
                _lineLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
                
                viewX = 0.0
                viewW = _lineLayer.frame.origin.x
            } else {
                viewW = 0.0
                viewX = _whitePointLayer.frame.origin.x
                _lineLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
                
                viewW = windowHeight
                viewX = _lineLayer.frame.origin.x-viewW
            }
            viewH = windowHeight
            viewY = 0.0
            _contentLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        case .right:
            viewX = 0.0
            _backPointLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
            
            viewW = whitePointSize.width
            viewH = whitePointSize.height
            viewY = (windowHeight-viewH)*0.5
            viewX = (backLayerSize.width-viewW)*0.5
            _whitePointLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
            
            viewH = 1.0
            viewX = _whitePointLayer.frame.maxX
            viewY = (windowHeight-viewH)*0.5
            
            if isUnfolded {
                viewW = KSMarkLabel._lineWidth
                _lineLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
                
                viewX = _lineLayer.frame.maxX
                viewW = windowWidth-viewX
            } else {
                viewW = 0.0
                _lineLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
                
                viewW = windowHeight
            }
            viewH = windowHeight
            viewY = 0.0
            _contentLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var returnSize = _contentLayer.sizeThatFits(size)
        let classObj = KSMarkLabel.self
        let whitePointRadius = classObj._whitePointRadius
        let begin = (classObj._backPointRadius-whitePointRadius)*0.5+whitePointRadius
        returnSize.width += classObj._lineWidth+begin
        return returnSize
    }
    
    open class func size(from title: String, isHasIcon: Bool) -> CGSize {
        let attributes = [NSAttributedString.Key.font: _contentView._font]
        let optins: NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading]
        var k_size = NSString(string: title).boundingRect(with: UIScreen.main.bounds.size, options: optins, attributes: attributes, context: nil).size
        let margin = _contentView._margin
        if isHasIcon {
            k_size.width += k_size.height+margin
        }
        k_size.width += margin*2.0
        k_size.height += margin*2.0
        
        let whitePointRadius = _whitePointRadius
        let begin = (_backPointRadius-whitePointRadius)*0.5+whitePointRadius
        k_size.width += _lineWidth+begin
        
        return k_size
    }
}
