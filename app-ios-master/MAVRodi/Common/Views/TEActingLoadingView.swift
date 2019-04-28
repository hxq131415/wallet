//
//  TEActingLoadingView.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/6/19.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  加载等待
/**
 * @brief  加载等待
 *
 * system  UIActivityIndicatorView
 * custom  自定制加载等待View
 */

import UIKit
import Foundation

enum TEActingLoadingType {
    case system  // activity view
    case custom  // custom view
}

// 系统加载样式
class TESystemActivityView: UIView {
    
    lazy var activityloadView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitlzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subViewInitlzation() {
        
        self.addSubview(activityloadView)
        activityloadView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        activityloadView.hidesWhenStopped = true
        activityloadView.color = UIColor.white
    }
    
    func startAnimating() {
        activityloadView.startAnimating()
    }
    
    func stopAnimating() {
        activityloadView.stopAnimating()
    }
    
}

// 自定制加载样式
// TODO: - 未完成!
class TECustomActivityView: UIView {
    
    lazy var animateImageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitlzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subViewInitlzation() {
        
        self.addSubview(animateImageView)
        animateImageView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        let image :UIImage = UIImage.animatedImageNamed("loading", duration: 3)!;
//        let image1 :UIImage = UIImage(named: "icon_plan_reward_bg")!
//        let image2 :UIImage = UIImage(named: "icon_plan_reward_box")!
//        let imageArray:NSArray = NSArray(array: [image1,image2])

        let imageArray:NSArray = NSArray.init(array: image.images!);//赋值
        animateImageView.animationImages=imageArray as? [UIImage];
        //周期时间
        animateImageView.animationDuration=2;
        //重复次数，0为无限制
        animateImageView.animationRepeatCount=0;
//        animateImageView.backgroundColor = UIColor.clear
        
        //icon_password_close
//        animateImageView.animationImages = []
    }
    
    func startAnimating() {
        animateImageView.startAnimating()
    }
    
    func stopAnimating() {
        animateImageView.stopAnimating()
    }
    
}

private let kActingLoadViewTag: Int = 83081
private let kAnimateTime: TimeInterval = 0.2

class TEActingLoadingView: UIView {
    
    lazy var systemActivityView: TESystemActivityView = TESystemActivityView(frame: CGRect.zero)
    lazy var customActivityView: TECustomActivityView = TECustomActivityView(frame: CGRect.zero)
    private var type: TEActingLoadingType = .system
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, actingViewType: TEActingLoadingType) {
        self.init(frame: frame)
        self.type = actingViewType
        
        self.subViewIntilzation()
    }
    
    private func subViewIntilzation() {
        
        self.addSubview(systemActivityView)
        systemActivityView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(68)
            make.height.equalTo(68)
        }
        
        systemActivityView.backgroundColor = UIColorFromRGB(hexRGB: 0x333333)
        systemActivityView.setCornerRadius(radius: 3)
        
        self.addSubview(customActivityView)
        customActivityView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        customActivityView.backgroundColor = UIColorFromRGB(hexRGB: 0x333333)
        customActivityView.setCornerRadius(radius: 20)

        if type == .custom {
            customActivityView.isHidden = false
            systemActivityView.isHidden = true
        }
        else {
            customActivityView.isHidden = true
            systemActivityView.isHidden = false
        }
    }
    
    private func startAnimating() {
        customActivityView.startAnimating()
        systemActivityView.startAnimating()
    }
    
    private func stopAnimating() {
        customActivityView.stopAnimating()
        systemActivityView.stopAnimating()
    }
    
    // 系统加载等待
    @discardableResult//showSystemActingLoadingViewToSuperView
    class func showCustomActingLoadingViewToSuperView(superView: UIView, belowView: UIView? = nil,  loadingBackgroundColor: UIColor? = nil) -> TEActingLoadingView {
        
        if let actingLoadView = superView.viewWithTag(kActingLoadViewTag) {
            actingLoadView.removeFromSuperview()
        }
        
        let actingLoadingView = TEActingLoadingView(frame: CGRect.zero, actingViewType: .system)
        actingLoadingView.tag = kActingLoadViewTag
        actingLoadingView.backgroundColor = loadingBackgroundColor
        
        if belowView != nil {
            
            superView.insertSubview(actingLoadingView, belowSubview: belowView!)
            actingLoadingView.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                if belowView!.alpha >= 1.0 && !belowView!.isHidden {
                    make.top.equalTo(belowView!.snp.bottom)
                }
                else {
                    make.top.equalToSuperview()
                }
            }
        }
        else {
            superView.addSubview(actingLoadingView)
            actingLoadingView.snp.remakeConstraints { (make) in
                make.left.right.bottom.top.equalToSuperview()
            }
        }
        
        actingLoadingView.superview?.setNeedsLayout()
        actingLoadingView.superview?.layoutIfNeeded()
        actingLoadingView.setNeedsLayout()
        actingLoadingView.layoutIfNeeded()
        
        actingLoadingView.backgroundColor = UIColor.clear
        actingLoadingView.isUserInteractionEnabled = false
        
        actingLoadingView.startAnimating()
        
        return actingLoadingView
    }
    
    // 自定制加载等待
    @discardableResult//showCustomActingLoadingViewToSuperView
    class func showSystemActingLoadingViewToSuperView(superView: UIView, belowView: UIView? = nil,  loadingBackgroundColor: UIColor? = nil) -> TEActingLoadingView {
        if let actingLoadView = superView.viewWithTag(kActingLoadViewTag) {
            actingLoadView.removeFromSuperview()
        }
        let rootRect = UIApplication.shared.windows.first?.frame   //应用屏幕大小
        
        let container = UIView()   //全屏且透明，盖在最上面， 可以自定义点击事件， 从而实现模态和非模态框效果。
        container.backgroundColor = UIColor.clear
        container.frame = rootRect!
        container.tag = kActingLoadViewTag
        let actingLoadingView = TEActingLoadingView(frame: superView.frame, actingViewType: .custom)
//        actingLoadingView.tag = kActingLoadViewTag
//        actingLoadingView.backgroundColor = loadingBackgroundColor
        actingLoadingView.backgroundColor =  UIColorFromRGB(hexRGB: 0x333333)
        

        if belowView != nil {
            
            belowView!.superview?.setNeedsLayout()
            belowView!.superview?.layoutIfNeeded()
//            belowView!.backgroundColor = UIColorFromRGB(hexRGB: 0x003333)
            superView.insertSubview(actingLoadingView, belowSubview: belowView!)
            actingLoadingView.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                if belowView!.alpha >= 1.0 && !belowView!.isHidden {
                    make.top.equalTo(belowView!.snp.bottom)
                }
                else {
                    make.top.equalToSuperview()
                }
            }
        }
        else {
            container.addSubview(actingLoadingView)
            superView.addSubview(container)
            actingLoadingView.snp.remakeConstraints { (make) in
                make.left.right.bottom.top.equalToSuperview()
            }
        }
        
        actingLoadingView.superview?.setNeedsLayout()
        actingLoadingView.superview?.layoutIfNeeded()
        actingLoadingView.setNeedsLayout()
        actingLoadingView.layoutIfNeeded()
        
        actingLoadingView.backgroundColor = UIColor.clear
        actingLoadingView.isUserInteractionEnabled = false
        
        actingLoadingView.startAnimating()
        
        return actingLoadingView
    }
    
    class func hideActingLoadingViewInSuperView(superView: UIView) {
        
        if let actingLoadView = superView.viewWithTag(kActingLoadViewTag) {
            UIView.animate(withDuration: kAnimateTime, animations: {
                actingLoadView.alpha = 0
            }) { (_) in
                actingLoadView.removeFromSuperview()
            }
        }
    }
    
}
