//
//  MRCustomAlertController.swift
//  NTMember
//
//  Created by rttx on 2018/2/7.
//  Copyright © 2018年 MT. All rights reserved.
//
//  公用弹框控制器

import UIKit

private let kAlertShowAnimateTimeInterval: TimeInterval = 0.21

//按钮类型
enum AlertButtonStyle {
    case cancel
    case confirm
}

class MRCustomAlertController: UIViewController , UIGestureRecognizerDelegate {
    
    private var alertTitle: String?
    private var alertMessage: String?
    
    private var isShowAlertView: Bool = false
    private var alertView: MRCustomAlertView?
    var isHiddenAlertTapAnyWhere: Bool = true // 是否点击黑色区域消失，默认true
    
    var completeClosure: (() -> Swift.Void)?
    var select: ((_ select: Bool) -> Swift.Void)?

    convenience init(title: String?, message: String?) {
        self.init(nibName: nil, bundle: nil)
        
        self.alertTitle = title
        self.alertMessage = message
        
        self.modalPresentationStyle = .overFullScreen
        
        alertView = MRCustomAlertView(frame: CGRect.zero, title: alertTitle, message: alertMessage)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.subViewInitilzation()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideAlertAction))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.isEnabled = isHiddenAlertTapAnyWhere
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subViewInitilzation() {
        
        alertView?.backgroundColor = UIColor.clear
        self.view.addSubview(alertView!)
        
        let alertViewWidth: CGFloat = 300 * theScaleToiPhone_6
        
        var titleHeight: CGFloat = 0
        var messageHeight: CGFloat = 0
        
        if let alert_title = alertView?.title {
            let titleSize = alert_title.calculateTextSizeConstrainedToSize(size: CGSize(width: alertViewWidth - MRCustomAlertView.kAlertViewLeftAndRightInset * 2.0, height: CGFloat(MAXFLOAT)), textFont: alertView!.titleLbl.font, numberOfLines: 2)
            titleHeight = titleSize.height
        }
        
        if let message = alertView?.message {
            
            let msgSize = message.calculateTextSizeConstrainedToSize(size: CGSize(width: alertViewWidth - MRCustomAlertView.kAlertViewLeftAndRightInset * 2.0, height: CGFloat(MAXFLOAT)), textFont: alertView!.textLbl.font, numberOfLines: 0, textAlignment: .center, lineBreakMode: .byTruncatingTail)
            messageHeight = msgSize.height
        }
        
        var alertViewHeight = MRCustomAlertView.kAlertViewTitleTop + titleHeight + MRCustomAlertView.kAlertViewMessageToBottomDistance + MRCustomAlertView.kAlertViewMessageToTitleDistance + messageHeight + MRCustomAlertView.kAlertViewMessageToHorizLineTopistance
        
        let minAlertViewHeight = alertViewWidth / 265.0 * 145.0
        let maxAlertViewHeight = Main_Screen_Height - 60
        
        alertViewHeight = alertViewHeight < minAlertViewHeight ? minAlertViewHeight : alertViewHeight
        alertViewHeight = alertViewHeight > maxAlertViewHeight ? maxAlertViewHeight : alertViewHeight
        
        alertView?.snp.remakeConstraints({ [weak self](make) in
            if let weakSelf = self {
                make.width.equalTo(alertViewWidth)
                make.height.equalTo(alertViewHeight)
                make.center.equalTo(weakSelf.view.snp.center)
            }
        })
        
        alertView?.superview?.setNeedsLayout()
        alertView?.superview?.layoutIfNeeded()
        alertView?.setNeedsLayout()
        alertView?.layoutIfNeeded()
        
        alertView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        alertView?.alpha = 0
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0)
    }
    
    // MARK: - Methods
    public func addAlertActions(actions: [MRCustomAlertAction]) {
        
        alertView?.addAlertActions(actions: actions)
    }
    
    @objc func hideAlertAction() {
        
        self.hideAlertView {
            
        }
    }
    
    func showAlertView() {
        
        if !isShowAlertView {
            
            UIView.animate(withDuration: kAlertShowAnimateTimeInterval, animations: { [weak self] in
                if let weakSelf = self {
                    weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0.55)
                    weakSelf.alertView?.transform = CGAffineTransform.identity
                    weakSelf.alertView?.alpha = 1.0
                }
            }) { [weak self](_) in
                if let weakSelf = self {
                    weakSelf.isShowAlertView = true
                }
            }
        }
    }
    
    func hideAlertView(completeClosure: (() -> Swift.Void)? = nil) {
        
        self.completeClosure = completeClosure
        if isShowAlertView {
            UIView.animate(withDuration: kAlertShowAnimateTimeInterval, animations: { [weak self] in
                if let weakSelf = self {
                    weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0)
                    weakSelf.alertView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    weakSelf.alertView?.alpha = 0.0
                }
            }) { [weak self](_) in
                if let weakSelf = self {
                    weakSelf.isShowAlertView = false
                    weakSelf.dismiss(animated: false, completion: {
                        if weakSelf.completeClosure != nil {
                            weakSelf.completeClosure!()
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: self.view)
        
        if let alertView = self.alertView , alertView.frame.contains(point) {
            return false
        }
        
        return true
    }
}

extension MRCustomAlertController {
    
    ///显示两个按钮  默认一个取消
    static func showAlertController(title:String?,
                                    message:String?,
                                    confirm:String,
                                    confirmClosure:@escaping ((AlertButtonStyle) -> Swift.Void)) {
        
        let alertController = MRCustomAlertController(title: title, message: message)
        alertController.isHiddenAlertTapAnyWhere = false
    
        let cancel = MRCustomAlertAction(title: "取消", style: .cancel) { (alert,select) in
            alertController.hideAlertView(completeClosure: {
                confirmClosure(AlertButtonStyle.cancel)
            })
        }
        let confirm_ = MRCustomAlertAction(title: confirm, style: .destructive) { (alert,select) in
            alertController.hideAlertView(completeClosure: {
                confirmClosure(AlertButtonStyle.confirm)
            })
        }
        alertController.addAlertActions(actions: [cancel,confirm_])
        MRTools.currentDisplayingViewController()?.present(alertController, animated: false, completion: {
            alertController.showAlertView()
        })
    }
    ///显示两个按钮
    static func showAlertController(title:String?,
                                    message:String?,
                                    cancel:String,
                                    confirm:String,
                                    confirmClosure:@escaping ((AlertButtonStyle) -> Swift.Void)) {
        
        let alertController = MRCustomAlertController(title: title, message: message)
        alertController.isHiddenAlertTapAnyWhere = false
        
        let cancel = MRCustomAlertAction(title: cancel, style: .cancel) { (alert,select) in
            alertController.hideAlertView(completeClosure: {
                confirmClosure(AlertButtonStyle.cancel)
            })
        }
        let confirm_ = MRCustomAlertAction(title: confirm, style: .destructive) { (alert,select) in
            alertController.hideAlertView(completeClosure: {
                confirmClosure(AlertButtonStyle.confirm)
            })
        }
        alertController.addAlertActions(actions: [cancel,confirm_])
        MRTools.currentDisplayingViewController()?.present(alertController, animated: false, completion: {
            alertController.showAlertView()
        })
    }
    ///显示一个按钮
    static func showAlertController(title:String?,
                                    message:String?,
                                    confirm:String,
                                    confirmClosure:@escaping (() -> Swift.Void)) {
        
        let alertController = MRCustomAlertController(title: title, message: message)
        alertController.isHiddenAlertTapAnyWhere = false
        
        let confirm_ = MRCustomAlertAction(title: confirm, style: .destructive) { (alert,select) in
            alertController.hideAlertView(completeClosure: {
                confirmClosure()
            })
        }
        alertController.alertView?.isShow(isShow:false)
        alertController.addAlertActions(actions: [confirm_])
        MRTools.currentDisplayingViewController()?.present(alertController, animated: false, completion: {
            alertController.showAlertView()
        })
    }
    
    //显示一个按钮加勾选
    static func showAlertController(title:String?,
                                    message:String?,
                                    isShow:Bool,
                                    confirm:String,
                                    confirmClosure:@escaping ((_ select: Bool) -> Swift.Void)) {
        
        let alertController = MRCustomAlertController(title: title, message: message)
        alertController.isHiddenAlertTapAnyWhere = false
        
        let confirm_ = MRCustomAlertAction(title: confirm, style: .destructive) { (alert,select) in
            alertController.hideAlertView(completeClosure: {
                confirmClosure(select)
//                select(select)
            })
        }
        alertController.alertView?.isShow(isShow:isShow)
        alertController.addAlertActions(actions: [confirm_])
        MRTools.currentDisplayingViewController()?.present(alertController, animated: false, completion: {
            alertController.showAlertView()
        })
    }
}


