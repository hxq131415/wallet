//
//  WalletTradingConfirmContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/12.
//  Copyright © 2018年 rttx. All rights reserved.
//
// 转款确认

import UIKit

class WalletTradingConfirmContentView: UIView {

    lazy var contentView: UIView = UIView(frame: CGRect.zero)
    
    var titleLbl1: UILabel = {
        let textLbl = UILabel(frame: CGRect.zero)
        return textLbl
    }()
    
    var constTextField: UITextField = {
        let constTextField_ = UITextField(frame: CGRect.zero)
        return constTextField_
    }()
    
    // 矿工费
    var minerFeeView: MRMinerFeeView = {
        let minerFeeVw_ = MRMinerFeeView(frame: CGRect.zero)
        return minerFeeVw_
    }()
    
    var titleLbl2: UILabel = {
        let textLbl = UILabel(frame: CGRect.zero)
        return textLbl
    }()
    
    var confirmBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    var confirmBtnTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subViewInitialization() {
        
        self.backgroundColor = UIColor.clear
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        contentView.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        contentView.cornerRadius = 8
        
        contentView.addSubview(titleLbl1)
        titleLbl1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(35)
            make.height.equalTo(40)
        }
        
        titleLbl1.configLabel(text: "转出金额", numberOfLines: 1, textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        
        contentView.addSubview(constTextField)
        constTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.titleLbl1.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        if Main_Screen_Width < 375 {
            constTextField.font = UIFont.systemFont(ofSize: 25)
        }
        else {
            constTextField.font = UIFont.systemFont(ofSize: 30)
        }
        
        constTextField.textColor = MRColorManager.DarkBlackTextColor
        constTextField.textAlignment = .center
        constTextField.isEnabled = false
        
        let separtorLineVw1 = UIView(frame: CGRect.zero)
        separtorLineVw1.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
        contentView.addSubview(separtorLineVw1)
        separtorLineVw1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.constTextField)
            make.height.equalTo(1)
            make.top.equalTo(self.constTextField.snp.bottom).offset(10)
        }
        
        contentView.addSubview(minerFeeView)
        minerFeeView.snp.makeConstraints { (make) in
            make.left.equalTo(separtorLineVw1)
            make.right.equalTo(separtorLineVw1)
            make.top.equalTo(separtorLineVw1.snp.bottom).offset(30)
            make.height.equalTo(70)
        }
        
        contentView.addSubview(titleLbl2)
        titleLbl2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.minerFeeView.snp.bottom).offset(20)
            make.height.greaterThanOrEqualTo(10)
        }
        
        titleLbl2.configLabel(text: nil, numberOfLines: 0, textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 10))
        
        contentView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.titleLbl2.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
        
        confirmBtn.configButtonForNormal(title: "立即转款", textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x365ad8))
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.cornerRadius = 8
        confirmBtn.addTarget(self, action: #selector(self.confirmBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 扩散1pt
        let shadowSize0:CGFloat = 1
        let shadowSpreadRect0 = CGRect(x: -shadowSize0, y: -shadowSize0, width: self.bounds.size.width+shadowSize0*2, height: self.bounds.size.height+shadowSize0*2)
        let shadowSpreadRadius0 = contentView.layer.cornerRadius + shadowSize0;
        let shadowPath0 = UIBezierPath(roundedRect: shadowSpreadRect0, cornerRadius: shadowSpreadRadius0)
        
        self.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x7e7e7e).withAlphaComponent(0.29), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 4, shadowOpacity: 1.0, shadowPath: shadowPath0.cgPath)
    }
    
    @objc func confirmBtnAction() {
        
        if self.confirmBtnTapClosure != nil {
            self.confirmBtnTapClosure!()
        }
    }
    
}
