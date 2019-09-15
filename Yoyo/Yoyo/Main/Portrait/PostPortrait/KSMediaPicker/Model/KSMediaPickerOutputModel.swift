//
//  KSMediaPickerOutputModel.swift
// 
//
//  Created by kinsun on 2019/3/24.
//

import UIKit
import Photos

open class KSMediaPickerOutputModel: NSObject {
    
    @objc public let sourceAsset: PHAsset
    @objc public let thumb: UIImage?
    @objc public let image: UIImage
    @objc public let tags: [String]?
    
    public init(asset: PHAsset, image: UIImage, thumb: UIImage?, tags: [String]?) {
        sourceAsset = asset
        self.thumb = thumb
        self.image = image
        self.tags = tags
        super.init()
    }
    
}
