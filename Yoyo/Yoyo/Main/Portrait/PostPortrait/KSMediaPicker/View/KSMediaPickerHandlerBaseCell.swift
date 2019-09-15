//
//  KSMediaPickerHandlerBaseCell.swift
// 
//
//  Created by kinsun on 2019/3/21.
//

import UIKit
import Photos

open class KSMediaPickerHandlerBaseCell: UICollectionViewCell {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let _imageView = UIImageView()
    
    private let _marksView = KSMarksView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .ks_background
        contentView.addSubview(_imageView)
        contentView.addSubview(_marksView)
        _marksView.didClickViewCallback = {[weak self] (point) in
            self?._didClick(point: point)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        _marksView.frame = contentView.bounds
        guard let contentSize = itemModel?.contentSize, var imageFrame = itemModel?.imageFrame else {
            return
        }
        let windowWidth = contentView.bounds.size.width
        let imageWidth = contentSize.width
        if windowWidth != imageWidth {
            let scale = windowWidth/imageWidth
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x *= scale
            imageFrame.origin.y *= scale
        }
        _imageView.frame = imageFrame
    }
    
    open var itemModel: KSMediaPickerItemModel? {
        didSet {
            guard let k_itemModel = itemModel else {
                return
            }
            _imageView.image = k_itemModel.thumb
            let mainSize = UIScreen.main.bounds.size
            PHImageManager.default().requestImage(for: k_itemModel.asset, targetSize: mainSize, contentMode: .aspectFit, options: KSMediaPickerItemModel.pictureOptions) {[weak self] (image, info) in
                self?._imageView.image = image
            }
            _marksView.markModelArray = k_itemModel.markLabelModelArray
            setNeedsLayout()
        }
    }
    
    open var generatedImage: UIImage? {
        return contentView.renderingImage
    }
    
    open var didClickMarksView: ((KSMediaPickerHandlerBaseCell, CGPoint) -> Void)?
    
    open var isUnfoldedAllLabel: Bool {
        set {
            _marksView.isUnfoldedAllLabel = newValue
        }
        get {
            return _marksView.isUnfoldedAllLabel
        }
    }
    
    open func add(model: KSMarkModel) -> KSMarkLabel {
        if let itemModel = itemModel {
            if itemModel.markLabelModelArray == nil {
                itemModel.markLabelModelArray = [KSMarkModel]()
            }
            itemModel.markLabelModelArray!.append(model)
        }
        let label = _marksView.add(model: model)
        return label
    }
    
    private func _didClick(point: CGPoint) {
        if let callBack = didClickMarksView {
            callBack(self, point)
        }
    }
}
