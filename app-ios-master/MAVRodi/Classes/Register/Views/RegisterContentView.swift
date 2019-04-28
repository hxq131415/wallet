//
//  LoginContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/30.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class RegisterContentView: UIView {

    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var invitationCodeTextField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var checkAgreementBtn: UIButton!
    @IBOutlet weak var userAgreementBtn: UIButton!
    
    @IBOutlet weak var returnLoginBtn: UIButton!
    
    @IBOutlet weak var chineseBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    
    lazy var sendVerifyCodeBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    var getVerifyCodeBtnTapClosure: ((_ email: String?) -> ())?
    var registerBtnTapClosure: ((_ userName: String?, _ email: String?, _ verifyCode: String?, _ loginPassword: String?, _ invitationCode: String?, _ isChecked: Bool) -> ())?
    var userAgreementBtnTapClosure: (() -> ())?
    var returnLoginBtnTapClosure: (() -> ())?
    var languageSwitchingBtnTapClosure: ((Bool) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundVw.backgroundColor = UIColor.clear
        
        self.configTextField(textField: userNameTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_username_placeholder_key))
        self.setTextFieldLeftView(textField: userNameTextField, image: UIImage(named: "icon_username"))
        userNameTextField.keyboardType = .asciiCapable
        userNameTextField.returnKeyType = .next
        
        self.configTextField(textField: emailTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_email_placeholder_key))
        self.setTextFieldLeftView(textField: emailTextField, image: UIImage(named: "MailIcon"))
        emailTextField.keyboardType = .asciiCapable
        emailTextField.returnKeyType = .next
        
        self.configTextField(textField: verifyCodeTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_verifycode_placeholder_key))
        self.setTextFieldLeftView(textField: verifyCodeTextField, image: UIImage(named: "icon_verify_code"))
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 115, height: 40))
        
        sendVerifyCodeBtn.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        sendVerifyCodeBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x16a2ac), for: UIControlState.normal)
        sendVerifyCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        sendVerifyCodeBtn.layer.cornerRadius = 8
        sendVerifyCodeBtn.layer.masksToBounds = true
        sendVerifyCodeBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x0d737c)
        sendVerifyCodeBtn.setImage(UIImage(named: "icon_send_verifycode_plan"), for: UIControlState.normal)
        sendVerifyCodeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_getVerifycode_button_title_key), for: UIControlState.normal)
        sendVerifyCodeBtn.addTarget(self, action: #selector(self.getVerifyCodeAction), for: UIControlEvents.touchUpInside)
        rightView.addSubview(sendVerifyCodeBtn)
        
        sendVerifyCodeBtn.titleLeftImageRightSetting(withSpace: 5)
        
        verifyCodeTextField.rightView = rightView
        verifyCodeTextField.rightViewMode = .always
        
        verifyCodeTextField.keyboardType = .asciiCapable
        verifyCodeTextField.returnKeyType = .next
        
        self.configTextField(textField: loginPasswordTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_loginpassword_placeholder_key))
        self.setTextFieldLeftView(textField: loginPasswordTextField, image: UIImage(named: "PasswordIcon"))
        
        //是否加密显示
//        let loginPwdRightBtn = UIButton(type: UIButtonType.custom)
//        loginPwdRightBtn.setImage(UIImage(named: "icon_password_open"), for: UIControlState.selected)
//        loginPwdRightBtn.setImage(UIImage(named: "icon_password_close"), for: UIControlState.normal)
//        loginPwdRightBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        loginPwdRightBtn.tag = 2001
//        loginPwdRightBtn.addTarget(self, action: #selector(self.passwordOpenBtnAction(btn:)), for: UIControlEvents.touchUpInside)
//        loginPasswordTextField.rightView = loginPwdRightBtn
//        loginPasswordTextField.rightViewMode = .always
        
        loginPasswordTextField.isSecureTextEntry = true
        loginPasswordTextField.keyboardType = .asciiCapable
        loginPasswordTextField.returnKeyType = .next
        
        self.configTextField(textField: invitationCodeTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_invitationcode_placeholder_key))
        self.setTextFieldLeftView(textField: invitationCodeTextField, image: UIImage(named: "icon_invitationcode"))
        invitationCodeTextField.keyboardType = .asciiCapable
        invitationCodeTextField.returnKeyType = .go
        
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Confirm_BtnTitle_Key), for: UIControlState.normal)
        confirmBtn.layer.cornerRadius = 4
        confirmBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x2FBBA8)
        
        confirmBtn.addTarget(self, action: #selector(self.registerAction), for: UIControlEvents.touchUpInside)
        
        let leftTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_user_agree_left_title_key)
        checkAgreementBtn.setTitle(leftTitle, for: UIControlState.normal)
        checkAgreementBtn.setImage(UIImage(named: "icon_user_agement_normal"), for: UIControlState.normal)
        checkAgreementBtn.setImage(UIImage(named: "icon_user_agement_selected"), for: UIControlState.selected)
        
        checkAgreementBtn.titleRightAndImageLeftSetting(withSpace: 2)
        checkAgreementBtn.addTarget(self, action: #selector(self.checkUserAgementBtnAction), for: UIControlEvents.touchUpInside)
        
        userAgreementBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_user_agree_right_title_key), for: UIControlState.normal)
        userAgreementBtn.addTarget(self, action: #selector(self.userAgreementBtnAction), for: UIControlEvents.touchUpInside)
    
        returnLoginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Confirm_Return_Login_BtnTitle_Key), for: UIControlState.normal)
        
        chineseBtn.setImage(UIImage(named: "icon_reg_language_normal")?.withRenderingMode(.alwaysOriginal), for: UIControlState.normal)
        chineseBtn.setImage(UIImage(named: "icon_reg_language_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.selected)
        englishBtn.setImage(UIImage(named: "icon_reg_language_normal")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        englishBtn.setImage(UIImage(named: "icon_reg_language_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.selected)
        chineseBtn.titleRightAndImageLeftSetting(withSpace: 5)
        englishBtn.titleRightAndImageLeftSetting(withSpace: 5)
        
        if MRTools.currentSystemLanguageType() == .en_us {
            englishBtn.isSelected = true
        }else {
            chineseBtn.isSelected = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func refreshUI() {
        
        self.configTextField(textField: userNameTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_username_placeholder_key))
        self.configTextField(textField: emailTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_email_placeholder_key))
        self.configTextField(textField: verifyCodeTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_verifycode_placeholder_key))
        sendVerifyCodeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_getVerifycode_button_title_key), for: UIControlState.normal)
        self.configTextField(textField: loginPasswordTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_loginpassword_placeholder_key))
        self.configTextField(textField: invitationCodeTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_invitationcode_placeholder_key))
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Confirm_BtnTitle_Key), for: UIControlState.normal)
        returnLoginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Confirm_Return_Login_BtnTitle_Key), for: UIControlState.normal)
    }
    
    func configTextField(textField: UITextField, placeholder: String) {
        
        textField.backgroundColor = UIColorFromRGB(hexRGB: 0x19303f)
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColorFromRGB(hexRGB: 0x19303f).cgColor
        
        textField.placeholder = placeholder
        textField.setValue(UIColorFromRGB(hexRGB: 0x16a2ac), forKeyPath: "_placeholderLabel.textColor")
        textField.setValue(UIFont.systemFont(ofSize: 16), forKeyPath: "_placeholderLabel.font")
        textField.textAlignment = .left
        textField.textColor = UIColorFromRGB(hexRGB: 0x16a2ac)
        textField.font = UIFont.systemFont(ofSize: 16)
    }
    
    func setTextFieldLeftView(textField: UITextField, image: UIImage?) {
        
        let leftView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 48))
        leftView2.image = image
        leftView2.contentMode = .center
        textField.leftView = leftView2
//        leftView2.addvertialLineWithColor(color: UIColorFromRGB(hexRGB: 0x424141), lineWidth: 1, lineHeight: 27)
        
        textField.leftViewMode = .always
    }
    
    // MARK: - Action
    @objc func registerAction() {
        
        if self.registerBtnTapClosure != nil {
            self.registerBtnTapClosure!(userNameTextField.text,
                                        emailTextField.text,
                                        verifyCodeTextField.text,
                                        loginPasswordTextField.text,
                                        invitationCodeTextField.text,
                                        checkAgreementBtn.isSelected)
        }
    }
    
    @IBAction func reutrnLoginAction(_ sender: UIButton) {
        if returnLoginBtnTapClosure != nil {
            returnLoginBtnTapClosure!()
        }
    }
    
    @IBAction func languageSwitchingAction(_ sender: UIButton) {
        chineseBtn.isSelected = !chineseBtn.isSelected
        englishBtn.isSelected = !englishBtn.isSelected
        
        if languageSwitchingBtnTapClosure != nil {
            languageSwitchingBtnTapClosure!(chineseBtn.isSelected)
        }
    }
    
    
    
    @objc func passwordOpenBtnAction(btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
        if btn.tag == 2001 {
            loginPasswordTextField.isSecureTextEntry = !btn.isSelected
        }
    }
    
    @objc func getVerifyCodeAction() {
        
        if self.getVerifyCodeBtnTapClosure != nil {
            self.getVerifyCodeBtnTapClosure!(emailTextField.text)
        }
    }
    
    @objc func checkUserAgementBtnAction() {
        
        checkAgreementBtn.isSelected = !checkAgreementBtn.isSelected
    }
    
    @objc func userAgreementBtnAction() {
        
        if self.userAgreementBtnTapClosure != nil {
            self.userAgreementBtnTapClosure!()
        }
    }
}

extension RegisterContentView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            if !isNull(str: textField.text) {
                emailTextField.becomeFirstResponder()
                return true
            }
        }
        else if textField == emailTextField {
            if !isNull(str: textField.text) {
                
                return true
            }
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    
}

