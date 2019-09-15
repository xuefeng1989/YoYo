//
//  KSAddMarkLabelSearchView.swift
//  KSMediaPickerDemo
//
//  Created by kinsun on 2019/9/13.
//  Copyright © 2019年 kinsun. All rights reserved.
//

import UIKit

class KSAddMarkLabelSearchView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public let textField = {() -> UITextField in
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 13.0);
        textField.tintColor = .ks_white
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.placeholder = "搜索"
        textField.textColor = .ks_white
        let placeholder = textField.value(forKey: "_placeholderLabel") as? UILabel
        placeholder?.textColor = UIColor.ks_white.withAlphaComponent(0.7)
        return textField
    }()

    private let _searchIcon = {() -> UIImageView in
        let searchIcon = UIImageView(image: UIImage(named: "icon_add_mark_search")?.withRenderingMode(.alwaysTemplate))
        searchIcon.contentMode = .center
        searchIcon.tintColor = .ks_white
        return searchIcon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        backgroundColor = UIColor.ks_white.withAlphaComponent(0.3)
        addSubview(_searchIcon)
        addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let windowSize = bounds.size
        let windowWidth = windowSize.width
        let windowHeight = windowSize.height
        
        layer.cornerRadius = windowHeight*0.5
        
        var viewX = CGFloat(0.0)
        let viewY = viewX
        var viewW = windowHeight
        let viewH = viewW
        _searchIcon.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        
        viewX = _searchIcon.frame.maxX
        viewW = windowWidth-viewX
        textField.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
    }
}
