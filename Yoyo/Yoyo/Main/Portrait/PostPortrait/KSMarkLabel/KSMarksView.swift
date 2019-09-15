//
//  KSMarksView.swift
//  KSMediaPickerDemo
//
//  Created by kinsun on 2019/9/12.
//  Copyright © 2019年 kinsun. All rights reserved.
//

import UIKit

open class KSMarksView: UIView, UIGestureRecognizerDelegate {
    
    private class _deleteContentView: UIImageView {
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            image = UIImage(named: "icon_mark_delete")
            contentMode = .center
            layer.masksToBounds = true
            isHidden = true
            backgroundColor = .ks_red
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = bounds.size.width*0.5
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let _deleteView = {() -> (UIView, UIImageView) in
        let view = UIView()
        let deleteLabel = _deleteContentView(frame: .zero)
        view.addSubview(deleteLabel)
        return (view, deleteLabel)
    }()
    
    private var _pan: UIPanGestureRecognizer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(_deleteView.0)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(_did(pan:)))
        pan.delegate = self
        _pan = pan
        addGestureRecognizer(pan)
    }
    
    private let _labelArray = NSMutableArray() ///contents is KSMarkLabel
    private let _markModelArray = NSMutableArray() ///contents is KSMarkModel
    
    open var markModelArray: [KSMarkModel]? {
        set {
            _markModelArray.removeAllObjects()
            if _labelArray.count > 0 {
                for label in _labelArray {
                    (label as! KSMarkLabel).removeFromSuperview()
                }
                _labelArray.removeAllObjects()
            }
            if let newValue = newValue, newValue.count > 0 {
                for labelModel in newValue {
                    _ = add(model: labelModel)
                }
            }
        }
        get {
            return _markModelArray as? [KSMarkModel]
        }
    }
    
    open func add(model: KSMarkModel) -> KSMarkLabel {
        let label = KSMarkLabel(markModel: model)
        label.addTarget(self, action: #selector(_didClick(label:)), for: .touchUpInside)
        addSubview(label)
        _labelArray.add(label)
        _markModelArray.add(model)
        setNeedsLayout()
        return label
    }
    
    @objc private func _didClick(label: KSMarkLabel) {
        label.needUpdate(direction: label.direction == .right ? .left : .right)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let windowSize = bounds.size
        for label in _labelArray {
            let label = label as! KSMarkLabel
            let size = label.sizeThatFits(windowSize)
            let anchorPoint = label.markModel.origin(from: windowSize)
            label.frame = CGRect(origin: anchorPoint, size: size)
        }
        let viewSide = CGFloat(54.0)
        let safeBottom = UIEdgeInsets.safeAreaInsets.bottom
        _deleteView.0.frame = CGRect(x: (windowSize.width-viewSide)*0.5, y: windowSize.height-viewSide-safeBottom-15.0, width: viewSide, height: viewSide)
        _deleteView.1.frame = _deleteView.0.bounds
    }
    
    @objc open var isUnfoldedAllLabel = false {
        didSet {
            if isUnfoldedAllLabel != oldValue {
                for label in _labelArray {
                    (label as! KSMarkLabel).isUnfolded = isUnfoldedAllLabel
                }
            }
        }
    }
    
    open var didClickViewCallback: ((CGPoint) -> Void)?
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let callback = didClickViewCallback, let point = touches.first?.location(in: self) {
            callback(point)
        }
    }
    
    private weak var _selectedLabel: KSMarkLabel?
    
    @objc private func _did(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            if _selectedLabel != nil {
                _deleteView.1.isHidden = false
            }
            break
        case .changed:
            if let selectedLabel = _selectedLabel {
                let location = pan.location(in: self)
                if _deleteView.0.frame.contains(location) {
                    _deleteView.1.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                } else {
                    _deleteView.1.transform = CGAffineTransform.identity
                }
                let translation = pan.translation(in: self)
                selectedLabel.center = CGPoint(x: selectedLabel.center.x + translation.x, y:  selectedLabel.center.y + translation.y)
                pan.setTranslation(.zero, in: self)
            }
        default:
            if let selectedLabel = _selectedLabel {
                if _deleteView.1.transform != .identity {
                    selectedLabel.removeFromSuperview()
                    let index = _labelArray.index(of: selectedLabel)
                    _labelArray.removeObject(at: index)
                    _markModelArray.removeObject(at: index)
                }
                let model = selectedLabel.markModel
                model.anchorPoint = model.anchorPoint(from: selectedLabel.frame.origin, superSize: bounds.size)
                _selectedLabel = nil
            }
            _deleteView.1.isHidden = true
        }
    }
    
    private var _lastLocation: CGPoint?
    private var _lastResult = true
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == _pan {
            let location = gestureRecognizer.location(in: self)
            if _lastLocation != location {
                _lastLocation = location
                var selectedLabel: KSMarkLabel? = nil
                for label in _labelArray {
                    let label = label as! KSMarkLabel
                    let isHas = label.frame.contains(location)
                    print("isHas = ", isHas)
                    if isHas {
                        selectedLabel = label
                        break
                    }
                }
                _selectedLabel = selectedLabel
                _lastResult = selectedLabel == nil
            }
            return _lastResult
        }
        return true
    }
}

@objc public enum KSMarkType: UInt {
    case none = 0
    case normal = 1
    case location = 2
    
    private static let _locationImageName = "icon_mark_location"
    private static let _normalImageName = "icon_marksLabel_Tag"
    
    public var imageName: String {
        get {
            switch self {
            case .none:
                return ""
            case .normal:
                return KSMarkType._normalImageName
            case .location:
                return KSMarkType._locationImageName
            }
        }
    }
}

@objc open class KSMarkModel: NSObject {
    
    @objc public let title: String
    @objc public let type: KSMarkType
    @objc open var isRight = true
    @objc open var anchorPoint = CGPoint.zero
    @objc public let size: CGSize
    
    @objc public init(title: String, type: KSMarkType) {
        self.title = title
        self.type = type
        size = KSMarkLabel.size(from: title, isHasIcon: type != .none)
        super.init()
    }
    
    @objc public convenience init?(JSON: String) {
        if let utf8 = JSON.data(using: .utf8),
            let data = try? JSONSerialization.jsonObject(with: utf8, options: .mutableContainers) {
            self.init(data: data as! [AnyHashable : Any])
        } else {
            return nil
        }
    }
    
    @objc public init(data: [AnyHashable: Any]) {
        title = (data["title"] as? String) ?? "未定义标签"
        if let number = data["type"] as? NSNumber, let type = KSMarkType(rawValue: number.uintValue) {
            self.type = type
        } else {
            type = .none
        }
        if let number = data["isRight"] as? NSNumber {
            isRight = number.boolValue
        }
        if let x = data["x"] as? NSNumber, let y = data["y"] as? NSNumber {
            anchorPoint = CGPoint(x: x.doubleValue, y: y.doubleValue)
        }
        size = KSMarkLabel.size(from: title, isHasIcon: type != .none)
        super.init()
    }
    
    @objc open var toDictionary: [AnyHashable: Any] {
        var data = [AnyHashable: Any]()
        data["title"] = title
        data["type"] = NSNumber(value: type.rawValue)
        data["isRight"] = NSNumber(value: isRight)
        if anchorPoint != .zero {
            data["x"] = NSNumber(value: Double(anchorPoint.x))
            data["y"] = NSNumber(value: Double(anchorPoint.y))
        }
        return data
    }
    
    @objc open var toJSON: String? {
        if let data = try? JSONSerialization.data(withJSONObject: toDictionary, options: .prettyPrinted) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }        
    }
    
    open func scale(point: CGPoint, superSize: CGSize) -> CGPoint {
        var origin = point
        origin.x /= superSize.width
        origin.y /= superSize.height
        return origin
    }
    
    open func anchorPoint(from origin: CGPoint, superSize: CGSize) -> CGPoint {
        var origin = origin
        if isRight {
            origin.x += KSMarkLabel.pointCenterX
        } else {
            origin.x += size.width-KSMarkLabel.pointCenterX
        }
        origin.y += size.height*0.5
        
        origin.x /= superSize.width
        origin.y /= superSize.height
        
        return origin
    }
    
    open func origin(from superSize: CGSize) -> CGPoint {
        var anchorPoint = self.anchorPoint
        
        anchorPoint.x *= superSize.width
        anchorPoint.y *= superSize.height
        
        if isRight {
            anchorPoint.x -= KSMarkLabel.pointCenterX
        } else {
            anchorPoint.x -= size.width-KSMarkLabel.pointCenterX
        }
        anchorPoint.y -= size.height*0.5
        
        return anchorPoint
    }
    
}
