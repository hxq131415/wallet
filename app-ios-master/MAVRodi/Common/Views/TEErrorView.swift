//
//  TEErrorView.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/6/12.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

private let kErrorViewTag: Int = 20917

class TEErrorView: UIView {
    
    lazy var iconImageView: UIImageView = UIImageView(frame: CGRect.zero)
    lazy var statusLbl: UILabel = UILabel(frame: CGRect.zero)
    lazy var refreshBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    var retryTapClosure: (() -> ())?
    var yOffSet: CGFloat = 0 {
        didSet {
            self.updateSubViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitlzation()
        self.updateSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subViewInitlzation() {
        
        self.addSubview(iconImageView)
        
        iconImageView.isUserInteractionEnabled = true
        iconImageView.image = UIImage(named: "icon_failed_to_load")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.iconImageViewTapAction))
        tapGesture.numberOfTapsRequired = 1
        iconImageView.addGestureRecognizer(tapGesture)
        
        self.addSubview(statusLbl)
        
        statusLbl.configLabel(text: "加载出错啦~", numberOfLines: 1, textAlignment: .center, textColor: MRColorManager.LightGrayTextColor, font: UIFont.systemFont(ofSize: 14))
        
        self.addSubview(refreshBtn)
        
        refreshBtn.configButtonForNormal(title: "立即刷新", textColor: MRColorManager.DarkBlackTextColor, font: UIFont.systemFont(ofSize: 14), normalImage: nil, selectedImage: nil, backgroundColor: MRColorManager.WhiteColor)
        refreshBtn.setCornerRadius(radius: 2)
        refreshBtn.setBorderWithColor(borderColor: MRColorManager.LightGrayBorderColor, borderWidth: 1)
        refreshBtn.addTarget(self, action: #selector(self.iconImageViewTapAction), for: .touchUpInside)
    }
    
    func updateSubViews() {
        
        iconImageView.snp.remakeConstraints { (make) in
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70 + yOffSet)
        }
        
        statusLbl.snp.remakeConstraints { (make) in
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
        }
        
        refreshBtn.snp.remakeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.top.equalTo(statusLbl.snp.bottom).offset(49)
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc func iconImageViewTapAction() {
        
        if retryTapClosure != nil {
            retryTapClosure!()
        }
    }
    
    // MARK: - 弹出错误页面
    /**
     - 弹出错误页面
     - superVw 需要添加的view
     - belowView 在下面
     -
     - @return TEErrorView
     */
    @discardableResult
    class func showErrorViewToSuperView(_ superVw: UIView, belowView: UIView?, retryTapClosure: (() -> ())?) -> TEErrorView {
        
        let errView = TEErrorView(frame: superVw.bounds)
        errView.tag = kErrorViewTag
        errView.retryTapClosure = retryTapClosure
        errView.backgroundColor = MRColorManager.WhiteColor
        
        if belowView != nil {
            if belowView!.alpha == 1.0 && !belowView!.isHidden {
                errView.yOffSet = belowView!.frame.maxY
            }
            superVw.insertSubview(errView, belowSubview: belowView!)
        }
        else {
            superVw.addSubview(errView)
        }
        
        errView.setNeedsLayout()
        errView.layoutIfNeeded()
        
        return errView
    }
    
    // 隐藏ErrorView
    class func hideErrorViewInSuperView(_ superVw: UIView) {
        
        if let errVw = superVw.viewWithTag(kErrorViewTag) as? TEErrorView {
            errVw.removeFromSuperview()
        }
    }
    
    
}
