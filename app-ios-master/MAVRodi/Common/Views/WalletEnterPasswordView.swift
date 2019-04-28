//
//  WalletEnterPasswordView.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/7.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class WalletEnterPasswordView: UIView {

    lazy var cancelBtn: UIButton = UIButton(type: UIButtonType.custom)
    lazy var determineBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    lazy var pwdTextField: UITextField = UITextField(frame: CGRect.zero)
    lazy var enterUserNameLbl = UILabel(frame: CGRect.zero)
    
    var cancelBtnTapClosure: (() -> ())?
    var determineBtnTapClosure: ((_ pwd: String?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitlzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subViewInitlzation() {
        
        self.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        enterUserNameLbl = UILabel(frame: CGRect.zero)
        self.addSubview(enterUserNameLbl)
        enterUserNameLbl.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(10)
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        
        enterUserNameLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletEnterPasswordAlert_wallet_pwd_top_lbl_text_key), numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x111111), font: UIFont.systemFont(ofSize: 16))
        
        self.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints { (make) in
            make.width.equalTo(180 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
            make.top.equalTo(enterUserNameLbl.snp.bottom).offset(20)
            make.height.equalTo(45 * theScaleToiPhone_6)
        }
        
        let paraphStyle = NSMutableParagraphStyle()
        paraphStyle.alignment = .center
        let userNamePlaceholderAttText = NSMutableAttributedString(string: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletEnterPasswordAlert_wallet_pwd_textfield_placeholder_key), attributes: [NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.paragraphStyle: paraphStyle])
        pwdTextField.attributedPlaceholder = userNamePlaceholderAttText
        
        pwdTextField.font = UIFont.systemFont(ofSize: 15)
        pwdTextField.textAlignment = .center
        pwdTextField.keyboardType = UIKeyboardType.default
        pwdTextField.returnKeyType = .done
        pwdTextField.isSecureTextEntry = true
        
        
        let sepertorLineVw2 = UIView(frame: CGRect.zero)
        self.addSubview(sepertorLineVw2)
        sepertorLineVw2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.height.equalTo(1)
            make.bottom.equalTo(self.pwdTextField.snp.bottom).offset(10)
        }
        
        sepertorLineVw2.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
        
        cancelBtn.setImage(UIImage(named: "icon_black_return"), for: UIControlState.normal)
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(26)
            make.top.equalTo(44)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
//        cancelBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_cancel_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xbabcc6), font: UIFont.systemFont(ofSize: 15), normalImage: nil, selectedImage: nil, backgroundColor: nil)
        
        self.addSubview(determineBtn)
        determineBtn.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(150 )
            make.height.equalTo(48 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20 * theScaleToiPhone_6)
        }
        
        determineBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x33C6B3), for: UIControlState.normal)
        determineBtn.layer.cornerRadius = 24
        determineBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x33C6B3).cgColor
        determineBtn.layer.borderWidth = 1.0
        determineBtn.layer.masksToBounds = true
        determineBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        determineBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key), for: UIControlState.normal)
//        determineBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0x424458), font: UIFont.systemFont(ofSize: 15), normalImage: nil, selectedImage: nil, backgroundColor: nil)
        
        
        
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnAction), for: UIControlEvents.touchUpInside)
        determineBtn.addTarget(self, action: #selector(self.determineBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Action
    @objc func cancelBtnAction() {
        
        if self.cancelBtnTapClosure != nil {
            self.cancelBtnTapClosure!()
        }
    }
    
    @objc func determineBtnAction() {
        
        if self.determineBtnTapClosure != nil {
            self.determineBtnTapClosure!(pwdTextField.text)
        }
    }

}
