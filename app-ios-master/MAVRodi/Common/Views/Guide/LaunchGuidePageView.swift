//
//  LaunchGuidePageView.swift
//  NTMember
//
//  Created by rttx on 2018/1/12.
//  Copyright © 2018年 MT. All rights reserved.
//
//  App引导页

import UIKit

private let kLaunchImageScaleAndHideAnimateTime: Double = 0.65
private let kLaunchImageScaleInsertValue: CGFloat = 80
private let kLaunchGuideViewBaseTagInWindow: Int = 83872
private let kLaunchGuideViewImageViewBaseTag: Int = 83224

class LaunchGuidePageView: UIView , UIScrollViewDelegate {
    
    var guideImages: [String] = ["iPhone_6_guide_image_1", "iPhone_6_guide_image_2", "iPhone_6_guide_image_3"]
    
    var mainScrollView: UIScrollView = UIScrollView(frame: CGRect.zero)
    var pageControl: UIPageControl = UIPageControl(frame: CGRect.zero)
    var toOpenBtn: UIButton = UIButton(type: .custom)
    var currentIndex: Int = 0
    
    var launchGuideAnimationFinishClosure: ((_ launchView: LaunchGuidePageView) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if iSiPhone6_7_8Plus() {
            guideImages = ["iPhone_plus_guide_image_1", "iPhone_plus_guide_image_2", "iPhone_plus_guide_image_3"]
        }
        else if iSiPhoneX() {
            guideImages = ["iPhone_X_guide_image_1", "iPhone_X_guide_image_2", "iPhone_X_guide_image_3"]
        }
        else {
            guideImages = ["iPhone_6_guide_image_1", "iPhone_6_guide_image_2", "iPhone_6_guide_image_3"]
        }
        
        self.subViewInitlzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subViewInitlzation() {
        
        mainScrollView.frame = CGRect(x: 0.0, y: 0.0, width: Main_Screen_Width, height: Main_Screen_Height)
        mainScrollView.backgroundColor = UIColor.white
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.isPagingEnabled = true
        mainScrollView.decelerationRate = UIScrollViewDecelerationRateFast
        mainScrollView.bounces = false
        mainScrollView.delegate = self
        
        self.addSubview(mainScrollView)
        
        for index in 0 ..< guideImages.count {
            
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * Main_Screen_Width, y: 0, width: Main_Screen_Width, height: Main_Screen_Height))
            imageView.tag = kLaunchGuideViewImageViewBaseTag + index
            imageView.contentMode = .scaleAspectFill
            var imgName = guideImages[index]
            imgName = "\(imgName).jpg"
            imageView.image = UIImage(named: imgName)
            imageView.isUserInteractionEnabled = true
            mainScrollView.addSubview(imageView)
        }
        
        mainScrollView.contentSize = CGSize(width: CGFloat(guideImages.count) * Main_Screen_Width, height: Main_Screen_Height)
        
        let width: CGFloat = 130.0
        let height: CGFloat = 40.0
        let x = (Main_Screen_Width - width) * 0.5
        var y = Main_Screen_Height - 133 * 0.5 - height
        if iSiPhone6_7_8Plus() {
            y = Main_Screen_Height - 148 * 0.5 - height
        }
        else if iSiPhoneX() {
            y = Main_Screen_Height - 177 * 0.5 - height
        }
        else if iSiPhone6_7_8() {
            y = Main_Screen_Height - 132 * 0.5 - height
        }
        else {
            y = Main_Screen_Height - 109 * 0.5 - height
        }
        
        toOpenBtn.frame = CGRect(x: x, y: y, width: width, height: height)
        self.addSubview(toOpenBtn)
        
        toOpenBtn.backgroundColor = UIColor.clear
        toOpenBtn.addTarget(self, action: #selector(self.toOpenAction), for: .touchUpInside)
    }
    
    //  捕获`开始体验`按钮，图片放大渐隐
    @objc func toOpenAction() {
        
        if currentIndex != guideImages.count - 1 {
            return
        }
        
        if let imageVw = mainScrollView.viewWithTag(kLaunchGuideViewImageViewBaseTag) {
            
            UIView.transition(with: self, duration: kLaunchImageScaleAndHideAnimateTime, options: UIViewAnimationOptions.curveLinear, animations: { [weak self] in
                if let weakSelf = self {
                    let tmpFrame = imageVw.frame.insetBy(dx: -kLaunchImageScaleInsertValue, dy: -kLaunchImageScaleInsertValue)
                    imageVw.frame = tmpFrame
                    imageVw.alpha = 0
                    weakSelf.toOpenBtn.alpha = 0
                    weakSelf.alpha = 0
                }
            }, completion: { [weak self](_) in
                if let weakSelf = self {
                    weakSelf.removeFromSuperview()
                    if weakSelf.launchGuideAnimationFinishClosure != nil {
                        weakSelf.launchGuideAnimationFinishClosure!(weakSelf)
                    }
                }
            })
        }
    }
    
    static func showLaunchGuideViewToWindow(window: UIWindow?) -> LaunchGuidePageView? {
        
        if let keyWindow = window {
            
            if let launchView = keyWindow.viewWithTag(kLaunchGuideViewBaseTagInWindow) as? LaunchGuidePageView {
                return launchView
            }
            
            let frame = keyWindow.frame
            let launchGuideView = LaunchGuidePageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
            launchGuideView.tag = kLaunchGuideViewBaseTagInWindow
            keyWindow.addSubview(launchGuideView)
            
            return launchGuideView
        }
        return nil
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x / Main_Screen_Width)
    }
    
}


