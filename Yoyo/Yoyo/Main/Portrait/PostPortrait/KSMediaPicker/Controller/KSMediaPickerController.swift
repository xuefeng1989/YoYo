//
//  KSMediaPickerController.swift
// 
//
//  Created by kinsun on 2019/3/1.
//

import UIKit

open class KSNavigationController: UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(navigationBar)
        navigationBar.isHidden = true
    }

}

import Photos

open class KSMediaPickerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @objc public let maxItemCount: UInt
    
    @objc public init(maxItemCount: UInt = 9) {
        self.maxItemCount = maxItemCount
        super.init(nibName: nil, bundle: nil)
    }
    
    @nonobjc required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let k_image_item_class = KSMediaPickerViewImageCell.self
    private static let k_image_item_iden = NSStringFromClass(k_image_item_class)
    
    override open func loadView() {
        let view = KSMediaPickerView()
        
        let nav = view.albumNavigationView
        nav.closeButton.addTarget(self, action: #selector(_didClick(closeButton:)), for: .touchUpInside)
        nav.nextButton.addTarget(self, action: #selector(_didClick(nextButton:)), for: .touchUpInside)
        nav.centerButton.addTarget(self, action: #selector(_chengedAlbumListStatus(_:)), for: .touchUpInside)
        
        let classObj = KSMediaPickerController.self
        let collectionView = view.collectionView
        collectionView.register(classObj.k_image_item_class, forCellWithReuseIdentifier: classObj.k_image_item_iden)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let tableView = view.albumTableView
        tableView.delegate = self
        tableView.dataSource = self
        
        let cameraView = view.cameraView
        cameraView.didTakePhotoCallback = {[weak self] (cameraView, image) in
            self?._didTakePhotoFinish(cameraView: cameraView, image: image)
        }
        let toolBar = cameraView.toolBar
        toolBar.closeButton.addTarget(self, action: #selector(_didClick(closeButton:)), for: .touchUpInside)
        toolBar.didChangedStyleCallback = { (style) in
            UIApplication.shared.setStatusBarStyle(style == .lightContent ? .lightContent : .default, animated: true)
        }
        self.view = view
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        let cancelHandler: ((UIAlertAction) -> Void) = {[weak self] (action) in
            self?._didClick(closeButton: nil)
        }
        KSMediaPickerController.authorityCheckUp(controller: self, completionHandler: {[unowned self] in
            DispatchQueue.global().async {
                let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
                let regularAssetCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
                let array = [assetCollections, regularAssetCollections]
                self._set(assetData: array)
            }
        }, cancelHandler: cancelHandler)
    }
    
    private var _albumList: [KSMediaPickerAlbumModel]?
    
    private func _set(assetData: [PHFetchResult<PHAssetCollection>]) {
        _albumList = KSMediaPickerAlbumModel.albumModel(from: assetData)
        DispatchQueue.main.async(execute: _loadAssetDataFinish)
    }
    
    private var _selectedAlbum: KSMediaPickerAlbumModel? {
        didSet {
            let view = self.view as! KSMediaPickerView
            view.albumNavigationView.title = _selectedAlbum?.albumTitle
            _updateHighlightedItemStatus()
            if let itemModel = _selectedAlbum?.assetList.first {
                let isStandard = _selectedAssetArray.count == 0 || itemModel == (_selectedAssetArray.firstObject as! KSMediaPickerItemModel)
                view.previewView.set(itemModel: itemModel, isStandard: isStandard)
                itemModel.isHighlight = true
            }
            _highlightedItemIndexPath = IndexPath(item: 0, section: 0)
            view.collectionView.reloadData()
        }
    }
    
    private func _loadAssetDataFinish() {
        (view as! KSMediaPickerView).albumTableView.reloadData()
        _selectedAlbum = _albumList?.first
    }
    
    @objc private func _chengedAlbumListStatus(_ button: KSTriangleIndicatorButton) {
        let isShow = (view as! KSMediaPickerView).chengedAlbumListStatus()
        button.rotationDirection = isShow ? .down : .up
    }
    
    @objc private func _didClick(closeButton: UIButton?) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func _didClick(nextButton: UIButton) {
        (view as! KSMediaPickerView).previewView.saveCurrentState()
        let ctl = KSMediaPickerHandlerController(itemModelArray: _selectedAssetArray as! [KSMediaPickerItemModel])
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    private func _didClickCell(collectionViewCell: KSMediaPickerViewImageCell) -> UInt {
        guard let itemModel = collectionViewCell.itemModel, !itemModel.isLoseFocus else {
            return 0
        }
        let indexPath = (view as! KSMediaPickerView).collectionView.indexPath(for: collectionViewCell)
        if indexPath != nil {
            _updateHighlightItem(at: indexPath!)
        }
        
        if itemModel.index > 0 {
            return _remove(itemModel: itemModel)
        } else {
            return _add(itemModel: itemModel)
        }
    }
    
    private func _didTakePhotoFinish(cameraView: KSMediaPickerCameraView, image: UIImage) {
        var createdAssetID: String? = nil
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            createdAssetID = request.placeholderForCreatedAsset?.localIdentifier
        }
        guard let k_id = createdAssetID,
            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [k_id], options: nil).firstObject else {
                return
        }
        _update(asset: asset)
    }
    
    private func _didTakeVideoFinish(cameraView: KSMediaPickerCameraView, fileURL: URL) {
        var createdAssetID: String? = nil
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            createdAssetID = request?.placeholderForCreatedAsset?.localIdentifier
        }
        guard let k_id = createdAssetID,
            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [k_id], options: nil).firstObject else {
                return
        }
        _update(asset: asset)
    }
    
    private func _update(asset: PHAsset) {
        _updateHighlightedItemStatus()
        let itemModel = KSMediaPickerItemModel(asset)
        itemModel.isHighlight = true
        _selectedAlbum?.assetList.insert(itemModel, at: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        _highlightedItemIndexPath = indexPath
        let isStandard = _selectedAssetArray.count == 0 || itemModel == (_selectedAssetArray.firstObject as! KSMediaPickerItemModel)
        let view = self.view as! KSMediaPickerView
        view.previewView.set(itemModel: itemModel, isStandard: isStandard)
        let collectionView = view.collectionView
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
        }) {[weak self] (finished) in
            let index = self?._add(itemModel: itemModel) ?? 0
            if index > 0 {
                itemModel.index = index
            } else {
                itemModel.isLoseFocus = true
            }
            collectionView.reloadItems(at: [indexPath])
            view.collectionViewScrollToTop()
            view.didClick(segmentedControl: view.segmentedControl, index: 0)
        }
    }
    
    private lazy var _selectedAssetArray = NSMutableArray(capacity: Int(maxItemCount))
    
    private func _add(itemModel: KSMediaPickerItemModel) -> UInt {
        let selectedAssetArray = _selectedAssetArray
        let count = UInt(selectedAssetArray.count)
        let k_maxItemCount = maxItemCount
        guard count < k_maxItemCount else {
            return 0
        }
        selectedAssetArray.add(itemModel)
        let lastCount = count+1
        let isLastItem = lastCount == k_maxItemCount
        let view = self.view as! KSMediaPickerView
        if isLastItem {
            let assetList = _selectedAlbum!.assetList
            var indexPaths = Array<IndexPath>()
            for (i, k_itemModel) in assetList.enumerated() {
                let isOk = (isLastItem && !selectedAssetArray.contains(k_itemModel))
                if isOk && !k_itemModel.isLoseFocus {
                    k_itemModel.isLoseFocus = true
                    let indexPath = IndexPath(item: i, section: 0)
                    indexPaths.append(indexPath)
                }
            }
            
            let collectionView = view.collectionView
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: indexPaths)
            }, completion: nil)
            view.albumNavigationView.centerButton.isEnabled = !isLastItem
        }
        view.albumNavigationView.nextButton.isEnabled = lastCount > 0
        return lastCount
    }
    
    private func _remove(itemModel: KSMediaPickerItemModel) -> UInt {
        let selectedAssetArray = _selectedAssetArray
        let index = selectedAssetArray.index(of: itemModel)
        let count = selectedAssetArray.count
        guard index >= 0, index < count else {
            return 0
        }
        itemModel.index = 0
        selectedAssetArray.removeObject(at: index)
        
        let view = self.view as! KSMediaPickerView
        let k_maxItemCount = maxItemCount
        let needUpdateIndexNumber = index != count-1
        let needUpdateFocus = count == k_maxItemCount
        if needUpdateIndexNumber && needUpdateFocus {
            let assetList = _selectedAlbum!.assetList
            var j = Int(1)
            for k_itemModel in assetList {
                if selectedAssetArray.contains(k_itemModel) {
                    k_itemModel.index = UInt(j)
                    j += 1
                } else {
                    if (k_itemModel.isLoseFocus) {
                        k_itemModel.isLoseFocus = false
                    }
                }
            }
            let collectionView = view.collectionView
            collectionView.reloadData()
        } else if needUpdateIndexNumber {
            let assetList = _selectedAlbum!.assetList as NSArray
            let assetListCount = assetList.count
            var indexPaths = Array<IndexPath>()
            for (i, k_itemModel) in selectedAssetArray.enumerated() {
                let l_itemModel = k_itemModel as! KSMediaPickerItemModel
                l_itemModel.index = UInt(i+1)
                let k_index = assetList.index(of: l_itemModel)
                if k_index >= 0 && k_index < assetListCount {
                    let indexPath = IndexPath(item: k_index, section: 0)
                    indexPaths.append(indexPath)
                }
            }
            let collectionView = view.collectionView
            collectionView.performBatchUpdates({
                collectionView.reloadItems(at: indexPaths)
            }, completion: nil)
        } else {
            let collectionView = view.collectionView
            let assetList = _selectedAlbum!.assetList
            if needUpdateFocus {
                var indexPaths = Array<IndexPath>()
                for (i, k_itemModel) in assetList.enumerated() {
                    if (k_itemModel.isLoseFocus) {
                        k_itemModel.isLoseFocus = false
                        let indexPath = IndexPath(item: i, section: 0)
                        indexPaths.append(indexPath)
                    }
                }
                collectionView.performBatchUpdates({
                    collectionView.reloadItems(at: indexPaths)
                }, completion: nil)
            }
        }
        let albumNavigationView = view.albumNavigationView
        albumNavigationView.centerButton.isEnabled = true
        albumNavigationView.nextButton.isEnabled = selectedAssetArray.count > 0
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _selectedAlbum?.assetList.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemModel = _selectedAlbum?.assetList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KSMediaPickerController.k_image_item_iden, for: indexPath) as! KSMediaPickerViewImageCell
        if cell.didSelectedItem == nil {
            cell.didSelectedItem = {[weak self] (collectionViewCell) -> UInt in
                return self?._didClickCell(collectionViewCell: collectionViewCell) ?? 0
            }
            cell.isMultipleSelected = maxItemCount > 1
        }
        cell.itemModel = itemModel
        return cell
    }
    
    private var _highlightedItemIndexPath: IndexPath?
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        _updateHighlightItem(at: indexPath)
    }
    
    private func _updateHighlightItem(at indexPath: IndexPath) {
        let view = self.view as! KSMediaPickerView
        guard indexPath != _highlightedItemIndexPath,
            let cell = view.collectionView.cellForItem(at: indexPath) as? KSMediaPickerViewImageCell,
            let itemModel = cell.itemModel,
            !itemModel.isLoseFocus else {
                return
        }
        let isStandard = _selectedAssetArray.count == 0 || itemModel == (_selectedAssetArray.firstObject as! KSMediaPickerItemModel)
        let previewView = view.previewView
        previewView.set(itemModel: itemModel, isStandard: isStandard)
        ///滚动至选择item区域
        let collectionView = view.collectionView
        let top = collectionView.contentInset.top
        var frame = collectionView.frame
        frame.origin.y = top
        frame.size.height -= top
        let cellFrame = cell.frame
        let frameInSuper = collectionView.convert(cellFrame, to: view)
        if !frame.contains(frameInSuper) {
            var point = CGPoint(x: 0.0, y: cellFrame.origin.y-top)
            let contentSizeHeight = collectionView.contentSize.height
            if cellFrame.maxY >= contentSizeHeight {
                point.y = contentSizeHeight-collectionView.bounds.size.height
            }
            collectionView.setContentOffset(point, animated: true)
        }
        ///滚动至选择item区域end
        view.showPreview(true)
        
        _updateHighlightedItemStatus()
        
        itemModel.isHighlight = true
        cell.itemIsHighlight = true
        _highlightedItemIndexPath = indexPath
    }
    
    private func _updateHighlightedItemStatus() {
        guard let indexPath = _highlightedItemIndexPath else {
            return
        }
        let highlightedItemModel: KSMediaPickerItemModel
        let highlightedCell = (view as! KSMediaPickerView).collectionView.cellForItem(at: indexPath) as? KSMediaPickerViewImageCell
        if highlightedCell == nil {
            highlightedItemModel = _selectedAlbum!.assetList[indexPath.item]
        } else {
            highlightedItemModel = highlightedCell!.itemModel
            highlightedCell?.itemIsHighlight = false
        }
        highlightedItemModel.isHighlight = false
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _albumList?.count ?? 0
    }
    
    private static let k_iden = "KSMediaPickerViewAlbumCell"
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iden = KSMediaPickerController.k_iden
        var cell = tableView.dequeueReusableCell(withIdentifier: iden) as? KSMediaPickerViewAlbumCell
        if cell == nil {
            cell = KSMediaPickerViewAlbumCell(style: .subtitle, reuseIdentifier: iden)
        }
        cell?.albumModel = _albumList?[indexPath.row]
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? KSMediaPickerViewAlbumCell
        tableView.deselectRow(at: indexPath, animated: true)
        guard cell != nil, let albumModel = cell?.albumModel else {
            return
        }
        _selectedAlbum = albumModel
        _chengedAlbumListStatus((view as! KSMediaPickerView).albumNavigationView.centerButton)
    }
}

extension KSMediaPickerController {
    
    open class func authorityCheckUp(controller: UIViewController, completionHandler: @escaping (() -> Void), cancelHandler: ((UIAlertAction) -> Void)?) {
        let authorization = {(status: PHAuthorizationStatus) in
            switch status {
            case .authorized:
                completionHandler()
                break
            case .denied:
                authorityAlert(controller: controller, name: "照片", cancelHandler: cancelHandler)
                break
            default:
                break
            }
        }
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(authorization)
        } else {
            authorization(status)
        }
    }
    
    open class func authorityAlert(controller: UIViewController, name: String, cancelHandler: ((UIAlertAction) -> Void)?) {
        let bundle = Bundle.main
        let appName = NSLocalizedString("CFBundleDisplayName", tableName: "InfoPlist", bundle: bundle, comment: "")
        let title = String(format: "没有打开“%@”访问权限", name)
        let message = String(format: "请进入“设置”-“%@”打开%@开关", appName, name)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let go = UIAlertAction(title: "去设置", style: .default) { (action) in
            let application = UIApplication.shared
            let url = URL(string: UIApplication.openSettingsURLString)!
            if application.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    application.open(url, options: [.universalLinksOnly: false], completionHandler: nil)
                } else {
                    application.openURL(url)
                }
                if cancelHandler != nil {
                    cancelHandler!(action)
                }
            }
        }
        alert.addAction(go)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: cancelHandler)
        alert.addAction(cancel)
        controller.present(alert, animated: true, completion: nil)
    }
}
