//
//  KSMarksBrowseModel.swift
//  Yoyo
//
//  Created by kinsun on 2019/9/15.
//  Copyright © 2019年 dhlg. All rights reserved.
//

import UIKit

open class KSMarksBrowseModel: NSObject {
    
    @objc public let imageSrc: String
    @objc public let tags: [KSMarkModel]
    
    @objc public init(imageSrc: String, tagsJsonArray: [String]) {
        self.imageSrc = imageSrc
        tags = tagsJsonArray.compactMap{KSMarkModel(JSON: $0)}
        super.init()
    }
    
    @objc public init(imageSrc: String, tags: [KSMarkModel]) {
        self.imageSrc = imageSrc
        self.tags = tags
        super.init()
    }
}
