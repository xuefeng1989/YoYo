//
//  KSAddMarkLabelController.swift
//  KSMediaPickerDemo
//
//  Created by kinsun on 2019/9/13.
//  Copyright © 2019年 kinsun. All rights reserved.
//

import UIKit

private class _KSAddMarkLabelBaseCell: UITableViewCell {
    
    private static let k_iden = "_KSAddMarkLabelBaseCell"
    open class var iden: String {
        return k_iden
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        let contentView = self.contentView
        contentView.backgroundColor = UIColor.ks_white.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 10.5
        contentView.layer.masksToBounds = true
        
        if let textLabel = textLabel {
            textLabel.text = "+  添加自定义（限 8 个字）"
            textLabel.font = .systemFont(ofSize: 16.0)
            textLabel.textColor = .ks_white
            textLabel.textAlignment = .left
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: 15.0, y: 10.0, width: bounds.size.width-30.0, height: bounds.size.height-10.0)
        
        if let textLabel = textLabel {
            let windowSize = contentView.bounds.size
            let viewX = CGFloat(20.0)
            let viewW = windowSize.width-viewX*2.0
            let viewH = textLabel.font.lineHeight
            let viewY = (windowSize.height-viewH)*0.5
            textLabel.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        }
    }
}

private class _KSAddMarkLabelCell: _KSAddMarkLabelBaseCell {
    
    private static let k_iden = "_KSAddMarkLabelCell"
    open class override var iden: String {
        return k_iden
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        if let imageView = imageView {
            imageView.tintColor = .ks_white
            imageView.image = UIImage(named: "icon_add_mark_location")?.withRenderingMode(.alwaysTemplate)
            imageView.contentMode = .scaleAspectFill
        }
        if let textLabel = textLabel {
            textLabel.text = " "
        }
        if let detailTextLabel = detailTextLabel {
            detailTextLabel.text = " "
            detailTextLabel.font = .systemFont(ofSize: 13.0)
            detailTextLabel.textColor = .ks_lightGray
            detailTextLabel.textAlignment = .left
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView,
            let textLabel = textLabel,
            let detailTextLabel = detailTextLabel {
            let windowSize = contentView.bounds.size
            let windowWidth = windowSize.width
            let windowHeight = windowSize.height
            let margin = CGFloat(20.0)
            
            var viewX = margin
            var viewW = CGFloat(17.0)
            var viewH = viewW
            var viewY = (windowHeight-viewH)*0.5
            imageView.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
            
            let textLabelHeight = textLabel.font.lineHeight
            let detailTextLabelHeight = detailTextLabel.font.lineHeight
            
            viewX = imageView.frame.maxX+10.0
            viewY = (windowHeight-textLabelHeight-detailTextLabelHeight-10.0)*0.5
            viewW = windowWidth-viewX-margin
            viewH = textLabelHeight
            textLabel.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
            
            viewY = textLabel.frame.maxY+10.0
            viewH = detailTextLabelHeight
            detailTextLabel.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        }
    }
    
    open var model: BMKPoiInfo? {
        didSet {
            textLabel?.text = model?.name
            detailTextLabel?.text = model?.address
            setNeedsLayout()
        }
    }
}

open class KSAddMarkLabelController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overCurrentContext;
        modalTransitionStyle = .crossDissolve;
    }
    
    private let _searchBar = KSAddMarkLabelSearchView()
    private let _cancelButton = {() -> UIButton in
        let cancelButton = UIButton(type: .custom)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 13.0)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.ks_white, for: .normal)
        return cancelButton
    }()
    private let _tableView = {() -> UITableView in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 80.0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
    }()
    
    override open func loadView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        
        let addCellClass = _KSAddMarkLabelBaseCell.self
        _tableView.register(addCellClass, forCellReuseIdentifier: addCellClass.iden)
        let cellClass = _KSAddMarkLabelCell.self
        _tableView.register(cellClass, forCellReuseIdentifier: cellClass.iden)
        _tableView.delegate = self
        _tableView.dataSource = self
        let contentView = view.contentView
        contentView.addSubview(_tableView)
        contentView.addSubview(_searchBar)
        _cancelButton.addTarget(self, action: #selector(_closeController), for: .touchUpInside)
        contentView.addSubview(_cancelButton)
        
        let textField = _searchBar.textField
        textField.delegate = self
        
        self.view = view
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let windowSize = view.bounds.size
        let windowWidth = windowSize.width
        let windowHeight = windowSize.height
        
        let navHeight = UIView.navigationBarSize.height
        let statusBarHeight = UIView.statusBarSize.height
        
        var viewW = CGFloat(45.0)
        var viewH = navHeight
        var viewX = windowWidth-viewW-5.0
        var viewY = statusBarHeight
        _cancelButton.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        
        viewX = 15.0
        viewH = 30.0
        viewY = (navHeight-viewH)*0.5+statusBarHeight
        viewW = _cancelButton.frame.origin.x-viewX
        _searchBar.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        
        viewX = 0.0
        viewY = navHeight+statusBarHeight
        viewW = windowWidth
        viewH = windowHeight-viewY
        _tableView.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        
        let inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: UIEdgeInsets.safeAreaInsets.bottom, right: 0.0)
        _tableView.contentInset = inset
        _tableView.separatorInset = inset
    }
    
    @objc private func _closeController() {
        dismiss(animated: true, completion: nil)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        _getNearbyAddress()
        // Do any additional setup after loading the view.
    }
    
    private var _isSearch = false
    
    private func _search(address: String) {
        _isSearch = true
        KSGlobalTools.searchCurrentAroundLocation(withName: address, page: 0) {[weak self] (poiInfoList, currentPage, totalPage, errorCode) in
            self?._dataArray = poiInfoList
        }
    }
    
    private func _getNearbyAddress() {
        _isSearch = false
        KSGlobalTools.getCurrentLocation { [weak self] (latitude, longitude, error) in
            if let `self` = self {
                KSGlobalTools.searchCurrentAroundLocationWithcallback({[weak self] (poiInfoList, errorCode) in
                    if errorCode == Int(BMK_SEARCH_NO_ERROR.rawValue) {
                        if self?._isSearch == false {
                            self?._dataArray = poiInfoList
                        }
                        self?._nearbyDataArray = poiInfoList
                    }
                })
            }
        }
    }
    
    private var _nearbyDataArray: [BMKPoiInfo]?
    
    private var _dataArray: [BMKPoiInfo]? {
        didSet {
            _tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (_dataArray?.count ?? 0)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: _KSAddMarkLabelBaseCell.iden, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: _KSAddMarkLabelCell.iden, for: indexPath) as! _KSAddMarkLabelCell
            cell.model = _dataArray?[indexPath.row]
            return cell
        }
    }
    
    private weak var _okAction: UIAlertAction?
    private weak var _textField: UITextField?
    private weak var _alert: UIAlertController?
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let alert = UIAlertController(title: "请输入标签", message: "标签最多8个字", preferredStyle: .alert)
            _alert = alert
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            let ok = UIAlertAction(title: "确定", style: .default) {[weak self] (action) in
                if let `self` = self, let textField = self._textField {
                    self._didFinishAddLabel(textField)
                }
            }
            ok.isEnabled = false
            _okAction = ok
            alert.addAction(ok)
            
            alert.addTextField {[weak self] (textField) in
                textField.returnKeyType = .done
                textField.delegate = self
                textField.clearButtonMode = .whileEditing
                if let `self` = self {
                    textField.addTarget(self, action: #selector(self._textFieldDidChangedValue(_:)), for: .editingChanged)
                    self._textField = textField
                }
            }
            present(alert, animated: true, completion: nil)
        } else if let cell = tableView.cellForRow(at: indexPath) as? _KSAddMarkLabelCell {
            if let callback = didReturnLabelCallback, let text = cell.model?.name {
                print("location label is "+text)
                callback(text, true)
                _closeController()
            }
        }
//        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == _searchBar.textField {
            _isSearch = false
            _dataArray = _nearbyDataArray
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case _textField:
            if let count = textField.text?.count, count > 0 && count <= 8 {
                _didFinishAddLabel(textField)
                _alert?.dismiss(animated: true, completion: nil)
            }
        case _searchBar.textField:
            if let text = textField.text {
                _search(address: text)
            }
            textField.resignFirstResponder()
        default:
            break
        }
        return false
    }
    
    @objc private func _textFieldDidChangedValue(_ textField: UITextField) {
        let count = textField.text?.count ?? 0
        _okAction?.isEnabled = count > 0 && count <= 8
    }
    
    private func _didFinishAddLabel(_ textField: UITextField) {
        if let callback = didReturnLabelCallback, let text = textField.text {
            print("input label is "+text)
            callback(text, false)
            _closeController()
        }
    }
    
    open var didReturnLabelCallback: ((String, Bool) -> Void)?
}
