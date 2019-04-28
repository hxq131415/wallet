//
//  MRPaymentPasswordInputView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/4.
//  Copyright © 2018年 rttx. All rights reserved.
//

/**
 * 微信，支付宝，支付密码输入框
 */

import UIKit

//========================= 微信，支付宝，支付密码输入框 ==============================//

// 密码输入框 掩码View
class MRInputMaskView: UIView {
    
    private var dotView: UIView = {
        let dotVw_ = UIView(frame: CGRect.zero)
        return dotVw_
    }()
    
    var dotSize: CGFloat = 10 {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    var isHidenMaskDot: Bool = true {
        didSet {
            if isHidenMaskDot {
                self.hideMaskDot()
            }
            else {
                self.showMaskDot()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(dotView)
        dotView.frame = CGRect(x: 0, y: 0, width: dotSize, height: dotSize)
        dotView.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        dotView.backgroundColor = UIColorFromRGB(hexRGB: 0x000000)
        dotView.layer.masksToBounds = true
        dotView.layer.cornerRadius = dotView.frame.size.height * 0.5
        dotView.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dotView.frame = CGRect(x: (self.frame.size.width - dotSize) * 0.5, y: (self.frame.size.height - dotSize) * 0.5, width: dotSize, height: dotSize)
        dotView.layer.cornerRadius = dotView.frame.size.height * 0.5
    }
    
    func showMaskDot() {
        
        UIView.animate(withDuration: 0.2) {
            self.dotView.alpha = 1
        }
    }
    
    func hideMaskDot() {
        
        UIView.animate(withDuration: 0.2) {
            self.dotView.alpha = 0
        }
    }
    
}

// 支付密码输入View
class MRPaymentPasswordInputiew: UIView, UITextFieldDelegate {
    
    private var pwdTextField: MRTextField = {
        let pwdTextField_ = MRTextField(frame: CGRect.zero)
        return pwdTextField_
    }()
    
    private var contentBackgroundView: UIView = {
        let backgroundVw = UIView(frame: CGRect.zero)
        return backgroundVw
    }()
    
    private var maskViewArray: [MRInputMaskView] = []
    
    // 密码输入完成回调
    var passwordInputFinsihClosure: ((_ pwd: String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitalization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.subViewInitalization()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let subVwWidth: CGFloat = (self.frame.size.width - 7.0 * 5) / 6.0
        let subVwHeight = subVwWidth
        let itemSpacing: CGFloat = 7
        
        pwdTextField.snp.updateConstraints { (make) in
            make.height.equalTo(subVwHeight)
        }
        
        contentBackgroundView.snp.updateConstraints { (make) in
            make.height.equalTo(subVwHeight)
        }
        
        for index in 0 ..< 6 {
            let maskVw = maskViewArray[index]
            maskVw.frame = CGRect(x: CGFloat(index) * (subVwWidth + itemSpacing), y: 0, width: subVwWidth, height: subVwHeight)
            maskVw.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
            maskVw.layer.cornerRadius = 5
            maskVw.layer.masksToBounds = true
            maskVw.layer.borderColor = UIColorFromRGB(hexRGB: 0xe9eaeb).cgColor
            maskVw.layer.borderWidth = 1
            
            maskVw.setNeedsLayout()
            maskVw.layoutIfNeeded()
        }
    }
    
    // MARK: - subView initializations
    private func subViewInitalization() {
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        pwdTextField.delegate = self
        
        pwdTextField.backgroundColor = UIColor.white
        pwdTextField.isSecureTextEntry = true
        pwdTextField.font = UIFont.systemFont(ofSize: 18)
        pwdTextField.keyboardType = UIKeyboardType.numberPad
        pwdTextField.returnKeyType = .done
        
        pwdTextField.addTarget(self, action: #selector(self.textFieldEditingChanged), for: UIControlEvents.editingChanged)
        
        self.addSubview(contentBackgroundView)
        contentBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        contentBackgroundView.backgroundColor = UIColor.white
        contentBackgroundView.isUserInteractionEnabled = false
        
        let subVwWidth: CGFloat = (100 - 7.0 * 5) / 6.0
        let subVwHeight = subVwWidth
        let itemSpacing: CGFloat = 7
        
        pwdTextField.snp.updateConstraints { (make) in
            make.height.equalTo(subVwHeight)
        }
        
        contentBackgroundView.snp.updateConstraints { (make) in
            make.height.equalTo(subVwHeight)
        }
        
        for index in 0 ..< 6 {
            let maskVw = MRInputMaskView(frame: CGRect(x: CGFloat(index) * (subVwWidth + itemSpacing), y: 0, width: subVwWidth, height: subVwHeight))
            maskVw.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
            maskVw.layer.cornerRadius = 5
            maskVw.layer.masksToBounds = true
            maskVw.layer.borderColor = UIColorFromRGB(hexRGB: 0xe9eaeb).cgColor
            maskVw.layer.borderWidth = 1
            contentBackgroundView.addSubview(maskVw)
            maskViewArray.append(maskVw)
        }
        
    }
    
    // 清空输入的密码
    func cleanInputPassword() {
        
        for index in 0 ..< maskViewArray.count {
            let maskView = maskViewArray[index]
            maskView.isHidenMaskDot = true
        }
        
        pwdTextField.text = nil
    }
    
    // MARK: - Action
    @objc func textFieldEditingChanged() {
        
        if let text = pwdTextField.text {
            let length = text.count
            if length >= 0 && length <= maskViewArray.count {
                for index in 0 ..< maskViewArray.count {
                    let maskView = maskViewArray[index]
                    if index < length {
                        maskView.isHidenMaskDot = false
                    }
                    else {
                        maskView.isHidenMaskDot = true
                    }
                }
            }
            
            if length >= 6 {
                // 支付密码输入完毕
                if self.passwordInputFinsihClosure != nil {
                    self.passwordInputFinsihClosure!(text)
                }
            }
        }
        
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // 当上次有输入时则清空上次输入的数据
        if textField.text != nil && textField.text!.count > 0 {
            self.cleanInputPassword()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            if string.isEmpty {
                // 删除操作
                return true
            }
            else {
                if text.count >= maskViewArray.count {
                    return false
                }
            }
            
        }
        
        return true
    }
    
}

//======================================================================//


// 设置支付密码弹框
class SetPaymentPasswordAlertView: UIView, UITextFieldDelegate {
    
    lazy var topBtn: UIButton = UIButton(type: UIButtonType.custom)
    lazy var sendVerifyCodeBtn: UIButton = UIButton(type: UIButtonType.custom)
    lazy var cancelBtn: UIButton = UIButton(type: UIButtonType.custom)
    lazy var determineBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    lazy var passwordTextField: UITextField = UITextField(frame: CGRect.zero)
    lazy var verifyCodeTextField: UITextField = UITextField(frame: CGRect.zero)
    
    private var inputMaskViewArray: [MRInputMaskView] = []
    
    var sendVerifyCodeBtnTapClosure: (() -> Void)?
    var cancelBtnTapClosure: (() -> Void)?
    var determineBtnTapClosure: ((_ paymentPwd: String?, _ verifyCode: String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitlzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func subViewInitlzation() {
        
        self.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        self.addSubview(topBtn)
        topBtn.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(10)
            make.height.greaterThanOrEqualTo(10)
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        topBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: SetPaymentPassword_top_title_key), textColor: UIColorFromRGB(hexRGB: 0xbabcc6), font: UIFont.systemFont(ofSize: 15), normalImage: nil, selectedImage: nil, backgroundColor: nil)
        topBtn.titleLabel?.textAlignment = .center
        
        self.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(self.topBtn.snp.bottom).offset(10)
            make.height.equalTo(48)
        }
        
        passwordTextField.textAlignment = .left
        passwordTextField.font = UIFont.systemFont(ofSize: 14)
        passwordTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: SetPaymentPassword_password_placeholder_text_key)
        passwordTextField.isSecureTextEntry = true
        
        
        let sepLineVw = UIView(frame: CGRect.zero)
        self.addSubview(sepLineVw)
        sepLineVw.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.passwordTextField)
            make.top.equalTo(self.passwordTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        sepLineVw.backgroundColor = UIColorFromRGB(hexRGB: 0xdedede)
        
        self.addSubview(verifyCodeTextField)
        verifyCodeTextField.snp.makeConstraints { (make) in
//            make.left.equalTo(self.passwordTextField.snp.left)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(200)
            make.top.equalTo(self.passwordTextField.snp.bottom)
            make.right.equalToSuperview().offset(-124)
            make.height.equalTo(48)
        }
        
//        verifyCodeTextField.layer.cornerRadius = 5
//        verifyCodeTextField.layer.masksToBounds = true
//        verifyCodeTextField.layer.borderColor = UIColorFromRGB(hexRGB: 0xe9eaeb).cgColor
//        verifyCodeTextField.layer.borderWidth = 0
        verifyCodeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 20))
        verifyCodeTextField.leftViewMode = .always
        verifyCodeTextField.font = UIFont.systemFont(ofSize: 14)
        verifyCodeTextField.keyboardType = UIKeyboardType.numberPad
        verifyCodeTextField.returnKeyType = .done
        verifyCodeTextField.textAlignment = .left
//        verifyCodeTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: SetPaymentPassword_password_placeholder_text_key)
        
        
        
        
        self.addSubview(sendVerifyCodeBtn)
        sendVerifyCodeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(35)
            make.centerY.equalTo(self.verifyCodeTextField.snp.centerY)
            make.right.equalToSuperview().offset(-24)
        }
        
        
//        sendVerifyCodeBtn.configButtonForTitleState(title: MRLocalizableStringManager.localizableStringFromTableHandle(key:  SetPaymentPassword_get_verifycode_btn_title_key), textAlignment:.center, font: UIFont.systemFont(ofSize: 15), backgroundColor: UIColorFromRGB(hexRGB: 0x444444), normalTextColor: UIColorFromRGB(hexRGB: 0xFFFFFF), selectedTextColor: UIColorFromRGB(hexRGB: 0xFFFFFF))
//        sendVerifyCodeBtn.titleLabel?.numberOfLines = 0
//        sendVerifyCodeBtn.titleRightAndImageLeftSetting(withSpace: 2)
        
        
        sendVerifyCodeBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key:  SetPaymentPassword_get_verifycode_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0x16A2AC), font: UIFont.systemFont(ofSize: 12), normalImage: UIImage(named: "icon_send_verifycode_plan"), selectedImage: UIImage(named: "icon_send_verifycode_plan"), backgroundColor: nil)
        sendVerifyCodeBtn.titleLabel?.textAlignment = .left
        sendVerifyCodeBtn.titleLabel?.numberOfLines = 0
        sendVerifyCodeBtn.titleLeftImageRightSetting(withSpace: 2)
        sendVerifyCodeBtn.addTarget(self, action: #selector(self.sendVerifyCodeBtnAction), for: UIControlEvents.touchUpInside)
        
        let sepLineVw2 = UIView(frame: CGRect.zero)
        self.addSubview(sepLineVw2)
        sepLineVw2.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.passwordTextField)
            make.top.equalTo(self.verifyCodeTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        sepLineVw2.backgroundColor = UIColorFromRGB(hexRGB: 0xdedede)
        
        self.addSubview(determineBtn)
        determineBtn.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.top.equalTo(sepLineVw2.snp.bottom).offset(15)

//            make.bottom.equalToSuperview()
//            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        determineBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x2ABBB0))
        determineBtn.layer.cornerRadius = 25
        determineBtn.addTarget(self, action: #selector(self.determineBtnAction), for: UIControlEvents.touchUpInside)
        
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.top.equalTo(self.determineBtn.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
//        cancelBtn.layer.cornerRadius = 25

        cancelBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_cancel_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0x2ABBB0), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: nil)
        
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Action
    @objc func sendVerifyCodeBtnAction() {
        
        if self.sendVerifyCodeBtnTapClosure != nil {
            self.sendVerifyCodeBtnTapClosure!()
        }
    }
    
    @objc func cancelBtnAction() {
        
        if self.cancelBtnTapClosure != nil {
            self.cancelBtnTapClosure!()
        }
    }
    
    @objc func determineBtnAction() {
        
        if self.determineBtnTapClosure != nil {
            self.determineBtnTapClosure!(passwordTextField.text, verifyCodeTextField.text)
        }
    }
    
    
}
