//
//  KSMediaPickerViewerController.swift
// 
//
//  Created by kinsun on 2019/3/25.
//

import UIKit

open class KSMediaPickerViewerController: KSMediaViewerController<KSMediaPickerOutputModel> {
    
    static private let k_class_picture = KSMediaViewerPictureCell.self
    static private let k_iden_picture = NSStringFromClass(k_class_picture)

    override open func loadMediaViewerView() -> KSMediaViewerView {
        let view = KSMediaPickerViewerView()
        let collectionView = view.collectionView
        let classObj = KSMediaPickerViewerController.self
        collectionView?.register(classObj.k_class_picture, forCellWithReuseIdentifier: classObj.k_iden_picture)
        return view
    }
    
    override open func mediaViewerCell(at indexPath: IndexPath, data: KSMediaPickerOutputModel, of collectionView: UICollectionView) -> KSMediaViewerCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: KSMediaPickerViewerController.k_iden_picture, for: indexPath) as! KSMediaViewerCell
    }
    
    override open func didClickViewCurrentItem() {
        dismiss(animated: true, completion: nil)
    }
    
    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        (view as! KSMediaPickerViewerView).pageControl.update(with: scrollView)
    }
    
    @objc override open func setDataArray(_ dataArray: [KSMediaPickerOutputModel], currentIndex: Int) {
        super.setDataArray(dataArray, currentIndex: currentIndex)
        let pageControl = (view as! KSMediaPickerViewerView).pageControl
        let count = dataArray.count
        if count > 1 {
            pageControl.numberOfPages = count
            pageControl.currentPage = currentIndex
        } else {
            pageControl.isHidden = true
        }
    }
    
    override open var currentThumb: UIImage? {
        return dataArray[currentIndex].thumb
    }
}
