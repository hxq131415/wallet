//
//  WalletReceiptContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class WalletReceiptContentView: UIView {

    private var contentBackgroundView: UIView = UIView(frame: CGRect.zero)
    
    var iocnImgView: UIImageView = {
        return UIImageView(frame: CGRect.zero)
    }()
    
    var topLbl: UILabel = {
        return UILabel(frame: CGRect.zero)
    }()
    
    lazy var qrCodeView: InvitationQRCodeView = InvitationQRCodeView(frame: CGRect.zero)
    var copyBtnTapClosure: (() -> ())?
    var shareAddressBtnTapClosure: (() -> ())?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitialzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func subViewInitialzation() {
        
        self.backgroundColor = UIColor.clear
        self.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x7e7e7e).withAlphaComponent(0.29), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8)
        
        self.addSubview(contentBackgroundView)
        contentBackgroundView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        contentBackgroundView.backgroundColor = UIColor.white
        contentBackgroundView.layer.cornerRadius = 8
        contentBackgroundView.layer.masksToBounds = true
        
        iocnImgView.image = UIImage(named: "icon_receive_logo")
        contentBackgroundView.addSubview(iocnImgView)
        iocnImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(38 * theScaleToiPhone_6)
            make.top.equalToSuperview().offset(30)
        }
        
        contentBackgroundView.addSubview(qrCodeView)
        qrCodeView.snp.makeConstraints { (make) in
            make.width.height.equalTo(160 * theScaleToiPhone_6)
            make.top.equalTo(self.iocnImgView.snp.bottom).offset(33 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
        }
        
        qrCodeView.configQRCodeContent(content: "")
        
        contentBackgroundView.addSubview(topLbl)
        topLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35 * theScaleToiPhone_6)
            make.right.equalToSuperview().offset(-35 * theScaleToiPhone_6)
            make.top.equalTo(qrCodeView.snp.bottom).offset(20 * theScaleToiPhone_6)
        }
        topLbl.numberOfLines = 0
        topLbl.configLabel(text: nil, textAlignment: NSTextAlignment.center, textColor: MRColorManager.DarkBlackTextColor, font: UIFont.systemFont(ofSize: 15))
        
        let sepertorLineVw = UIView(frame: CGRect.zero)
        contentBackgroundView.addSubview(sepertorLineVw)
        sepertorLineVw.snp.makeConstraints { (make) in
            make.left.equalTo(30 * theScaleToiPhone_6)
            make.right.equalTo(-30 * theScaleToiPhone_6)
            make.top.equalTo(self.topLbl.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        
        sepertorLineVw.backgroundColor = MRColorManager.TableViewSeparatorLineDarkColor
        
        let copyBtn = UIButton(type: UIButtonType.custom)
        contentBackgroundView.addSubview(copyBtn)
        copyBtn.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(15)
            make.height.equalTo(15)
            make.bottom.equalTo(sepertorLineVw.snp.top).offset(-8)
            make.right.equalTo(sepertorLineVw.snp.right).offset(-5)
        }
        copyBtn.setImage(UIImage(named: "icon_receive_copy"), for: UIControlState.normal)
        copyBtn.addTarget(self, action: #selector(self.copyBtnAction), for: UIControlEvents.touchUpInside)
        
        let shareBtn = UIButton(type: UIButtonType.custom)
        shareBtn.frame = CGRect(x: 0, y: 0, width: 160 * theScaleToiPhone_6, height: 48 * theScaleToiPhone_6)
        contentBackgroundView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.width.equalTo(160 * theScaleToiPhone_6)
            make.height.equalTo(48 * theScaleToiPhone_6)
            make.bottom.equalTo(-34 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
        }
        shareBtn.layer.cornerRadius = shareBtn.height() / 2
        shareBtn.layer.masksToBounds = true
        
        shareBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x33c6b3)
    shareBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_shareAddress_btn_title_key), for: UIControlState.normal)
        shareBtn.addTarget(self, action: #selector(self.shareBtnAction), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func copyBtnAction() {
        
        if copyBtnTapClosure != nil {
            copyBtnTapClosure!()
        }
    }
    
    @objc func shareBtnAction() {
        
        if shareAddressBtnTapClosure != nil {
            shareAddressBtnTapClosure!()
        }
    }
}
