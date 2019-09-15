//
//  KSMediaPickerCameraView.swift
// 
//
//  Created by kinsun on 2019/3/11.
//

import UIKit

extension KSMediaPickerCameraView {
    
    private enum previewSize: UInt {
        case square
        case hdPicture
        case hdVideo
        
        private static let _squareSize = CGSize(width: 1.0, height: 1.0)
        private static let _hdPictureSize = CGSize(width: 3.0, height: 4.0)
        private static let _hdVideoSize = CGSize(width: 9.0, height: 16.0)
        
        public var cgSizeValue: CGSize {
            get {
                switch self {
                case .square:
                    return previewSize._squareSize
                case .hdPicture:
                    return previewSize._hdPictureSize
                case .hdVideo:
                    return previewSize._hdVideoSize
                }
            }
        }
    }
}

import AVFoundation

open class KSMediaPickerCameraView: UIView {

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if arch(i386) || arch(x86_64)
    private let _frontCameraDevice: AVCaptureDevice?
    private let _backCameraDevice: AVCaptureDevice?
    #else
    private let _frontCameraDevice: AVCaptureDevice
    private let _backCameraDevice: AVCaptureDevice
    #endif
    private var _videoInput: AVCaptureDeviceInput?
    private lazy var _imageOutput = AVCaptureStillImageOutput()
    private let _session = {() -> AVCaptureSession in
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        return session
    }()
    private let _previewLayer: AVCaptureVideoPreviewLayer
    public let toolBar = KSMediaPickerCameraToolBar(style: .darkContent)
    private let _takePhotoButton = {() -> UIButton in
        let frame = CGRect(origin: .zero, size: CGSize(width: 80.0, height: 80.0))
        let takePhotoButton = KSBorderButton(type: .custom)
        takePhotoButton.frame = frame
        let layer = takePhotoButton.layer
        layer.masksToBounds = true
        layer.borderWidth = 8.0
        layer.cornerRadius = frame.size.height*0.5
        let color = UIColor.ks_main
        let borderColor = UIColor.ks_lightMain
        takePhotoButton.setBackgroundColor(color, for: .normal)
        takePhotoButton.setBackgroundColor(color.withAlphaComponent(0.5), for: .highlighted)
        takePhotoButton.setBorderColor(borderColor, for: .normal)
        takePhotoButton.setBorderColor(borderColor.withAlphaComponent(0.5), for: .highlighted)
        return takePhotoButton
    }()
    
    override public init(frame: CGRect) {
        #if arch(i386) || arch(x86_64)
        _frontCameraDevice = nil
        _backCameraDevice = nil
        #else
        var frontCameraDevice: AVCaptureDevice? = nil
        var backCameraDevice: AVCaptureDevice? = nil
        let devices = AVCaptureDevice.devices(for: .video)
        for device in devices {
            switch device.position {
            case .back:
                backCameraDevice = device
                break
            case .front:
                frontCameraDevice = device
                break
            default:
                break
            }
        }
        _frontCameraDevice = frontCameraDevice!
        _backCameraDevice = backCameraDevice!
        #endif
        
        _previewLayer = AVCaptureVideoPreviewLayer(session: _session)
        _previewLayer.videoGravity = .resizeAspectFill
        _previewLayer.backgroundColor = UIColor.ks_black.cgColor
        startRunning = _session.startRunning
        stopRunning = _session.stopRunning
        super.init(frame: frame)
        backgroundColor = .ks_white
        #if arch(i386) || arch(x86_64)
        _videoInput = nil
        #else
        _videoInput = _videoInputFrom(device: _backCameraDevice)
        #endif
        if let input = _videoInput, _session.canAddInput(input) {
            _session.addInput(input)
        }
        if _session.canAddOutput(_imageOutput) {
            _session.addOutput(_imageOutput)
        }
        
        layer.addSublayer(_previewLayer)
        
        _takePhotoButton.addTarget(self, action: #selector(_didClick(takePhotoButton:)), for: .touchUpInside)
        addSubview(_takePhotoButton)
        toolBar.cameraOrientation.addTarget(self, action: #selector(_didClick(cameraOrientation:)), for: .touchUpInside)
        toolBar.priviewSizeButton.addTarget(self, action: #selector(_didClick(priviewSizeButton:)), for: .touchUpInside)
        toolBar.flashlightButton.addTarget(self, action: #selector(_didClick(flashlightButton:)), for: .touchUpInside)
        addSubview(toolBar)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let bounds = self.bounds
        let windowSize = bounds.size
        let windowWidth = windowSize.width
        let floatZore = CGFloat(0.0)
        
        var viewX = floatZore
        var viewY = UIView.statusBarSize.height
        var viewW = windowWidth
        var viewH = UIView.navigationBarSize.height
        toolBar.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        
        let size = _takePhotoButton.bounds.size
        viewW = size.width
        viewH = size.height
        viewX = (windowWidth-viewW)*0.5
        viewY = windowSize.height-viewH
        _takePhotoButton.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
    }
    
    override open func layoutSublayers(of layer: CALayer) {
        let windowSize = layer.bounds.size
        let windowWidth = windowSize.width
        let floatZore = CGFloat(0.0)
        
        let viewX = floatZore
        let viewY: CGFloat
        let viewW = windowWidth
        let viewH: CGFloat
        switch _previewSizeType {
        case .square:
            viewY = UIView.statusBarNavigationBarSize.height
            viewH = viewW
            break
        default:
            viewY = floatZore
            let size = _previewSizeType.cgSizeValue
            viewH = floor(size.height/size.width*viewW)
            break
        }
        _previewLayer.frame = CGRect(x: viewX, y: viewY, width: viewW, height: viewH)
        super.layoutSublayers(of: layer)
    }
    
    private var _previewSizeType = KSMediaPickerCameraView.previewSize.square {
        didSet {
            setNeedsLayout()
        }
    }

    public let startRunning: () -> Void
    public let stopRunning: () -> Void
    open var didTakePhotoCallback: ((KSMediaPickerCameraView, UIImage) -> Void)?
    
    open var isBackCameraDevice: Bool {
        return _videoInput?.device == _backCameraDevice
    }
    
    @objc private func _didClick(cameraOrientation: KSMediaPickerCameraToolBar.button) {
        #if arch(i386) || arch(x86_64)
        #else
        guard let input = _videoInput else {
            return
        }
        
        let trans = CATransition()
        trans.duration = 0.5
        trans.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        trans.type = CATransitionType(rawValue: "oglFlip")
        
        var device = input.device
        if device == _frontCameraDevice {
            device = _backCameraDevice
            trans.subtype = .fromLeft
        } else if device == _backCameraDevice {
            device = _frontCameraDevice
            trans.subtype = .fromRight
        }
        guard let newInput = _videoInputFrom(device: device) else {
            return
        }
        _session.beginConfiguration()
        _session.removeInput(input)
        if _session.canAddInput(newInput) {
            _session.addInput(newInput)
            _videoInput = newInput
            toolBar.type = device == _backCameraDevice ? .photos : .noFlashlightPhotos
        } else {
            _session.addInput(input)
        }
        _session.commitConfiguration()
        _previewLayer.add(trans, forKey: nil)
        #endif
    }
    
    private func _videoInputFrom(device: AVCaptureDevice) -> AVCaptureDeviceInput? {
        let input: AVCaptureDeviceInput?
        do {
            try input = AVCaptureDeviceInput(device: device)
        } catch {
            input = nil
        }
        return input
    }
    
    @objc private func _didClick(priviewSizeButton: KSMediaPickerCameraToolBar.button) {
        let status = priviewSizeButton.status
        let newStatus: KSMediaPickerCameraToolBar.button.status
        let sizeType: KSMediaPickerCameraView.previewSize
        switch status {
        case .status1://1:1
            newStatus = .status2
            sizeType = .hdPicture
            toolBar.style = .lightContent
            break
        case .status2://3:4
            newStatus = .status1
            sizeType = .square
            toolBar.style = .darkContent
            break
        default:
            return
        }
        priviewSizeButton.status = newStatus
        _previewSizeType = sizeType
    }
    
    @objc private func _didClick(flashlightButton: KSMediaPickerCameraToolBar.button) {
        guard let device = _videoInput?.device else {
            return
        }
        try? device.lockForConfiguration()
        let status = flashlightButton.status
        let newStatus: KSMediaPickerCameraToolBar.button.status
        let flashMode: AVCaptureDevice.FlashMode
        switch status {
        case .status1://auto
            newStatus = .status2
            flashMode = .on
            break
        case .status2://on
            newStatus = .status3
            flashMode = .off
            break
        case .status3://off
            newStatus = .status1
            flashMode = .auto
            break
        }
        if device.isFlashModeSupported(flashMode) {
            flashlightButton.status = newStatus
            device.flashMode = flashMode
        }
    }
    
    @objc private func _didClick(takePhotoButton: KSBorderButton) {
        guard let conntion = _imageOutput.connection(with: .video) else {
            return
        }
        _imageOutput.captureStillImageAsynchronously(from: conntion, completionHandler: _didTakePhotoAfter)
    }
    
    private func _didTakePhotoAfter(imageDataSampleBuffer: CMSampleBuffer?, error: Error?) {
        guard let k_imageDataSampleBuffer = imageDataSampleBuffer,
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(k_imageDataSampleBuffer) else {
            return
        }
        let image = UIImage(JPEGData: imageData, of: _previewSizeType.cgSizeValue)
        stopRunning()
        if didTakePhotoCallback != nil {
            didTakePhotoCallback!(self, image)
        }
    }
    
}
