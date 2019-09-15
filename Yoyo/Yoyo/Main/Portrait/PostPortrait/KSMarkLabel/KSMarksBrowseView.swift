//
//  KSMarksBrowseView.swift
//  Yoyo
//
//  Created by kinsun on 2019/9/15.
//  Copyright © 2019年 dhlg. All rights reserved.
//

import UIKit

open class KSMarksBrowseView: UIView, UICollectionViewDataSource, KSMediaPickerHandlerCollectionViewDelegate {
    
    private class _cell: UICollectionViewCell {
        
        public static let iden = "KSMarksBrowseView._cell"
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public let marksView = {() -> KSMarksView in
            let marksView = KSMarksView()
            marksView.isUserInteractionEnabled = false
            return marksView
        }()
        
        private let _imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(_imageView)
            contentView.addSubview(marksView)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            _imageView.frame = contentView.bounds
            marksView.frame = contentView.bounds
        }
        
        open var model: KSMarksBrowseModel? {
            didSet {
                if let model = model {
                    _imageView.sd_setImage(with: URL(string: model.imageSrc), completed: nil)
                    marksView.markModelArray = model.tags
                } else {
                    _imageView.image = nil
                    marksView.markModelArray = nil
                }
            }
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let _collectionView: KSMediaPickerHandlerCollectionView
    private let _layout = {() -> UICollectionViewFlowLayout in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        return layout
    }()

    @objc public override init(frame: CGRect) {
        let collectionView = KSMediaPickerHandlerCollectionView(frame: .zero, collectionViewLayout: _layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        _collectionView = collectionView
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.register(_cell.self, forCellWithReuseIdentifier: _cell.iden)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let size = bounds.size
        _layout.itemSize = size
        _collectionView.frame = bounds
    }
    
    @objc open var dataArray: [KSMarksBrowseModel]? {
        didSet {
            _collectionView.reloadData()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: _cell.iden, for: indexPath) as! _cell
        cell.model = dataArray?[indexPath.item]
        if _currentCell == nil, _currentPage == 0, indexPath.item == 0 {
            _currentCell = cell
            cell.marksView.isUnfoldedAllLabel = true
        }
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.size != .zero, let dataArray = dataArray else {
            return
        }
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.size.width
        let page = Int(ceil((offsetX-width*0.5)/width))
        if page != _currentPage, page >= 0, page < dataArray.count {
            _currentPage = page
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _currentCell?.marksView.isUnfoldedAllLabel = false
    }
    
    public func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        _currentCell?.marksView.isUnfoldedAllLabel = true
    }
    
    private var _currentPage = Int(0) {
        didSet {
            _currentCell = _collectionView.cellForItem(at: IndexPath(item: _currentPage, section: 0)) as? _cell
        }
    }
    
    private var _currentCell: _cell?
}
