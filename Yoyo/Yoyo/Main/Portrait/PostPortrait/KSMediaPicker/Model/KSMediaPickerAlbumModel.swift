//
//  KSMediaPickerAlbumModel.swift
// 
//
//  Created by kinsun on 2019/3/1.
//

import UIKit
import Photos

open class KSMediaPickerAlbumModel {
    
    public let assetCollection: PHAssetCollection
    public let albumTitle: String
    public var assetList: [KSMediaPickerItemModel]
    
    public init(_ assetCollection: PHAssetCollection) {
        self.assetCollection = assetCollection
        albumTitle = assetCollection.localizedTitle ?? ""
        let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        var assetList = Array<KSMediaPickerItemModel>()
        for i in (0..<assets.count).reversed() {
            let asset = assets.object(at: i)
            if asset.mediaType == .image {
                let itemModel = KSMediaPickerItemModel(asset)
                assetList.append(itemModel)
            }
        }
        self.assetList = assetList
    }
    
    public class func albumModel(from assetCollections: [PHFetchResult<PHAssetCollection>]) -> [KSMediaPickerAlbumModel] {
        var array = Array<KSMediaPickerAlbumModel>()
        for result in assetCollections {
            for i in 0..<result.count {
                let assetCollection = result.object(at: i)
                let isCameraRoll = assetCollection.assetCollectionSubtype  == .smartAlbumUserLibrary
                let albumModel = KSMediaPickerAlbumModel(assetCollection)
                if albumModel.assetList.count > 0 {
                    if isCameraRoll {
                        array.insert(albumModel, at: 0)
                    } else {
                        array.append(albumModel)
                    }
                }
            }
        }
        return array
    }
}
