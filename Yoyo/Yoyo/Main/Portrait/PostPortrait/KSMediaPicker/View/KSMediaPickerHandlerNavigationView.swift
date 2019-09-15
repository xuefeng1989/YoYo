//
//  KSMediaPickerHandlerNavigationView.swift
//  Yoyo
//
//  Created by kinsun on 2019/9/15.
//  Copyright © 2019年 dhlg. All rights reserved.
//

import UIKit

open class KSMediaPickerHandlerNavigationView: UIView {

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let _titleLabel = {() -> UILabel in
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 18.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .ks_wordMain
        return titleLabel
    }()
    
    @objc public let nextButton = {() -> UIButton in
        let nextButton = UIButton(type: .custom)
        nextButton.titleLabel?.font = .systemFont(ofSize: 14.0)
        nextButton.setTitle("下一步", for: .normal)
        nextButton.setTitleColor(.ks_wordMain, for: .normal)
        nextButton.setTitleColor(.ks_wordMain_2, for: .disabled)
        return nextButton
    }()
    
    @objc public let closeButton = {() -> UIButton in
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "icon_back_black"), for: .normal)
        return closeButton
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .ks_white
        addSubview(nextButton)
        addSubview(closeButton)
        addSubview(_titleLabel)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let windowSize = bounds.size
        let windowWidth = windowSize.width
        
        var viewX = CGFloat(0.0)
        let viewY = UIView.statusBarSize.height
        let viewH = windowSize.height-viewY
        var viewW = viewH+30.0
        closeButton.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        
        viewW = nextButton.sizeThatFits(windowSize).width+30.0
        viewX = windowWidth-viewW
        nextButton.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        
        let maxWidth = max(closeButton.bounds.size.width, nextButton.bounds.size.width)
        viewX = maxWidth
        viewW = windowWidth-viewX*2.0
        _titleLabel.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
    }
    
    @objc open var title: String? {
        set {
            _titleLabel.text = newValue
        }
        get {
            return _titleLabel.text
        }
    }

}
