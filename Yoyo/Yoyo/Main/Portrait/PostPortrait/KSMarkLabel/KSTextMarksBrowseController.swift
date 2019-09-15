//
//  KSTextMarksBrowseController.swift
//  Yoyo
//
//  Created by kinsun on 2019/9/15.
//  Copyright © 2019年 dhlg. All rights reserved.
//

import UIKit

open class KSTextMarksBrowseController: UIViewController {
    
    private let _main = KSMarksBrowseView()
    
    private let _closeButton = {() -> UIButton in
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("close", for: .normal)
        return closeButton
    }()
    
    override open func loadView() {
        let view = UIView()
        view.backgroundColor = .ks_background
        
        view.addSubview(_main)
        view.addSubview(_closeButton)
        _closeButton.addTarget(self, action: #selector(_didClick(closeButton:)), for: .touchUpInside)
        
        self.view = view
    }
    
    @objc private func _didClick(closeButton: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let windowSize = view.bounds.size
        let windowWidth = windowSize.width
        let windowHeight = windowSize.height
        
        var viewX = CGFloat(0.0)
        var viewY = CGFloat(88.0)
        var viewW = windowWidth
        var viewH = windowWidth
        
        _main.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        
        viewW = 120.0
        viewH = 64.0
        viewX = (windowWidth-viewW)*0.5
        viewY = windowHeight-UIEdgeInsets.safeAreaInsets.bottom-100.0
        _closeButton.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        let images = ["http://img4.duitang.com/uploads/item/201312/05/20131205172433_NsYGL.thumb.600_0.jpeg",
                      "http://img5.duitang.com/uploads/item/201312/05/20131205172435_5myuy.thumb.700_0.jpeg",
                      "http://thumbs.dreamstime.com/z/传染媒-抽象正方形背景-32947663.jpg",
                      "http://img5.imgtn.bdimg.com/it/u=2126162217,3741274050&fm=26&gp=0.jpg"]
        let titles = ["测试标签", "English Tag", "很长很长的标签" ,"地理位置"]
        let points = [CGPoint(x: 20.0, y: 300.0),
                      CGPoint(x: 320.0, y: 80.0),
                      CGPoint(x: 40.0, y: 220.0),
                      CGPoint(x: 280.0, y: 480.0)]
        let size = UIScreen.main.bounds.size
        var markModelArray = [KSMarkModel]()
        for (i, string) in titles.enumerated() {
            let model = KSMarkModel(title: string, type: i%2 == 0 ? .normal : .location)
            model.anchorPoint = model.anchorPoint(from: points[i], superSize: size)
            model.isRight = i%2 == 0
            markModelArray.append(model)
        }
        
        _main.dataArray = images.map {KSMarksBrowseModel(imageSrc: $0, tags: markModelArray)}
    }

}
