//
//  KSMediaPickerHandlerController.swift
// 
//
//  Created by kinsun on 2019/3/21.
//

import UIKit
import Photos

open class KSMediaPickerHandlerController: UIViewController, UICollectionViewDataSource, KSMediaPickerHandlerCollectionViewDelegate {
    
    private class _button: UIButton {
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            tintColor = .ks_main
            imageView?.contentMode = .scaleAspectFit
            setImage(UIImage(named: "icon_marksLabel_Tag_button")?.withRenderingMode(.alwaysTemplate), for: .normal)
            titleLabel?.font = .systemFont(ofSize: 11.0)
            setTitle("标签", for: .normal)
            setTitleColor(.ks_main, for: .normal)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            if let titleLabel = titleLabel, let imageView = imageView {
                let windowSize = bounds.size
                let windowWidth = windowSize.width
                let windowHeight = windowSize.height
                let titleSize = titleLabel.sizeThatFits(windowSize)
                let size = imageView.bounds.size
                let margin = CGFloat(7.0)
                
                var viewW = min(size.width, windowWidth)
                var viewH = min(size.height, windowHeight)
                var viewX = (windowWidth-viewW)*0.5
                var viewY = (windowHeight-(viewH+titleSize.height+margin))*0.5
                imageView.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
                
                viewW = titleSize.width
                viewH = titleSize.height
                viewX = (windowWidth-viewW)*0.5
                viewY = imageView.frame.maxY+margin
                titleLabel.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let _layout = {() -> UICollectionViewFlowLayout in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = .zero
        return layout
    }()
    
    private let _collectionView: KSMediaPickerHandlerCollectionView
    
    private let _navigationView = KSMediaPickerHandlerNavigationView()
    
    private let _addTagButton = _button()
    
    public let itemModelArray: [KSMediaPickerItemModel]
    
    public required init(itemModelArray: [KSMediaPickerItemModel]) {
        self.itemModelArray = itemModelArray
        let collectionView = KSMediaPickerHandlerCollectionView(frame: .zero, collectionViewLayout: _layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        _collectionView = collectionView
        super.init(nibName: nil, bundle: nil)
    }
    
    private static let k_class_picture = KSMediaPickerHandlerBaseCell.self
    private static let k_iden_picture = NSStringFromClass(k_class_picture)
    
    override open func loadView() {
        let view = UIView()
        view.backgroundColor = .ks_background
        
        let classOjb = KSMediaPickerHandlerController.self
        
        _collectionView.register(classOjb.k_class_picture, forCellWithReuseIdentifier: classOjb.k_iden_picture)
        _collectionView.dataSource = self
        _collectionView.delegate = self
        view.addSubview(_collectionView)
        
        _navigationView.nextButton.addTarget(self, action: #selector(_didClick(nextButton:)), for: .touchUpInside)
        _navigationView.closeButton.addTarget(self, action: #selector(_didClick(closeButton:)), for: .touchUpInside)
        view.addSubview(_navigationView)
        
        view.addSubview(_addTagButton)
        _addTagButton.addTarget(self, action: #selector(_didClick(tagButton:)), for: .touchUpInside)
        
        self.view = view
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _collectionView.frame = view.bounds
        
        let navHeight = UIView.statusBarNavigationBarSize.height
        _navigationView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.size.width, height: navHeight))
        
        guard let size = itemModelArray.first?.contentSize else {
            return
        }
        
        let windowSize = view.bounds.size
        let windowWidth = windowSize.width
        let windowHeight = windowSize.height
        let itemSize: CGSize
        if size.width == windowWidth {
            itemSize = size
        } else {
            let width = windowWidth
            let height = floor(size.height*width/size.width)
            itemSize = CGSize(width: width, height: height)
        }
        _layout.itemSize = itemSize
        let bottom = windowHeight-navHeight-itemSize.height
        _collectionView.contentInset = UIEdgeInsets(top: navHeight, left: 0.0, bottom: bottom, right: 0.0)
        
        let lastY = navHeight+itemSize.height
        let viewW = CGFloat(55.0)
        let viewH = CGFloat(80.0)
        let viewX = (windowWidth-viewW)*0.5
        let viewY = (windowHeight-UIEdgeInsets.safeAreaInsets.bottom-lastY)*0.5+lastY
        _addTagButton.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        title = "1/\(itemModelArray.count)"
    }
    
    override open var title: String? {
        set {
            super.title = newValue
            _navigationView.title = newValue
        }
        get {
            return super.title
        }
    }
    
    @objc private func _didClick(tagButton: _button) {
        if let cell = _currentCell {
            let point = cell.contentView.center
            _didClickMarksView(cell: cell, point: point)
        }
    }
    
    @objc private func _didClick(closeButton: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func _didClick(nextButton: UIButton) {
        var outputArray = [KSMediaPickerOutputModel]()
        for item in itemModelArray {
            let outputModel: KSMediaPickerOutputModel
            let asset = item.asset
            guard let image = _image(from: item) else {
                continue
            }
            let tags: [String]?
            if let k_tags = item.markLabelModelArray {
                tags = k_tags.compactMap{$0.toJSON}
            } else {
                tags = nil
            }
            
            outputModel = KSMediaPickerOutputModel(asset: asset, image: image, thumb: image.equalResize(sideLength: 105.0), tags: tags)
            outputArray.append(outputModel)
        }
        let ctl = KSPublishViewController(outputModelArray: outputArray)
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    private func _image(from itemModel: KSMediaPickerItemModel) -> UIImage? {
        let asset = itemModel.asset
        let mainSize = UIScreen.main.bounds.size
        var k_image: UIImage? = nil
        PHImageManager.default().requestImage(for: asset, targetSize: mainSize, contentMode: .aspectFit, options: KSMediaPickerItemModel.pictureOptions) {(image, info) in
            k_image = image
        }
        if let image = k_image, let contentSize = itemModel.contentSize, var imageFrame = itemModel.imageFrame {
            let windowSize = _layout.itemSize
            let windowWidth = windowSize.width
            let imageWidth = contentSize.width
            if windowWidth != imageWidth {
                let scale = windowWidth/imageWidth
                imageFrame.size.width *= scale
                imageFrame.size.height *= scale
                imageFrame.origin.x *= scale
                imageFrame.origin.y *= scale
            }
            let imageSize = image.size
            let imageFrameSize = imageFrame.size
            let scaleWidth = imageSize.width/imageFrameSize.width
            let scaleHeight = imageSize.height/imageFrameSize.height
            let rect = CGRect(x: -(imageFrame.origin.x)*scaleWidth, y: -(imageFrame.origin.y)*scaleHeight, width: windowWidth*scaleWidth, height: windowSize.height*scaleHeight)
            let outputImageSize = CGSize(width: 720.0, height: windowSize.height*720.0/windowSize.width)
            k_image = image.cut(from: rect)?.aspectFit(from: outputImageSize, backgroundColor: .lightGray)
        }
        return k_image
    }
    
    private func _video(from itemModel: KSMediaPickerItemModel) -> AVURLAsset? {
        var urlAsset: AVAsset? = nil
        PHImageManager.default().requestAVAsset(forVideo: itemModel.asset, options: KSMediaPickerItemModel.videoOptions) {(k_urlAsset, audioMix, info) in
            urlAsset = k_urlAsset
        }
        repeat {
            RunLoop.current.run(mode: .default, before: Date(timeIntervalSinceNow: 0.2))
        } while urlAsset == nil
        if urlAsset is AVURLAsset {
            return urlAsset as? AVURLAsset
        } else {
            return nil
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemModelArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KSMediaPickerHandlerController.k_iden_picture, for: indexPath) as! KSMediaPickerHandlerBaseCell
        cell.itemModel = itemModelArray[indexPath.item]
        if cell.didClickMarksView == nil {
            cell.didClickMarksView = {[weak self] (cell, point) in
                self?._didClickMarksView(cell: cell, point: point)
            }
        }
        if _currentCell == nil, _currentPage == 0, indexPath.item == 0 {
            _currentCell = cell
        }
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.size != .zero else {
            return
        }
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.size.width
        let page = Int(ceil((offsetX-width*0.5)/width))
        if page != Int(_currentPage), page >= 0, page < itemModelArray.count {
            _currentPage = UInt(page)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _currentCell?.isUnfoldedAllLabel = false
    }
    
    public func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        _currentCell?.isUnfoldedAllLabel = true
    }
    
    private var _currentPage = UInt(0) {
        didSet {
            _currentCell = _collectionView.cellForItem(at: IndexPath(item: Int(_currentPage), section: 0)) as? KSMediaPickerHandlerBaseCell
            title = "\(_currentPage+1)/\(itemModelArray.count)"
        }
    }
    
    private var _currentCell: KSMediaPickerHandlerBaseCell?
    
    private func _didClickMarksView(cell: KSMediaPickerHandlerBaseCell, point: CGPoint) {
        let ctl = KSAddMarkLabelController()
        ctl.didReturnLabelCallback = {[weak self, weak cell, point] (text, isLocation) in
            if let `self` = self, let cell = cell {
                self._didReturnLabel(cell: cell, point: point, text: text, isLocation: isLocation)
            }
        }
        present(ctl, animated: true, completion: nil)
    }
    
    private func _didReturnLabel(cell: KSMediaPickerHandlerBaseCell, point: CGPoint, text: String, isLocation: Bool) {
        let size = cell.contentView.bounds.size
        let model = KSMarkModel(title: text, type: isLocation ? .location : .normal)
        model.anchorPoint = model.scale(point: point, superSize: size)
        cell.add(model: model).isUnfolded = true
    }
    
    deinit {
        for item in itemModelArray {
            item.markLabelModelArray = nil
        }
    }
}
