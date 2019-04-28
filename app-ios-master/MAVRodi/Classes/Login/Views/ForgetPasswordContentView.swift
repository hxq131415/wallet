//
//  LoginContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/30.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class ForgetPasswordContentView: UIView {

    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var verifyCodeTextField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var returnLoginBtn: UIButton!
    
    lazy var sendVerifyCodeBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    var sendVerifyCodeBtnTapClosure: ((_ email: String?) -> ())?
    var confirmBtnTapClosure: ((_ email: String?, _ verifyCode: String?, _ password: String?) -> ())?
    var returnLoginBtnTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundVw.backgroundColor = UIColor.clear
//        backgroundVw.layer.cornerRadius = 8
//        backgroundVw.layer.masksToBounds = true
        
//        self.layer.shadowColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0.58).cgColor
//        self.layer.shadowOffset = CGSize(width: -1, height: -1)
//        self.layer.shadowRadius = 2
//        self.layer.shadowOpacity = 1.0
        
        self.configTextField(textField: emailTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_email_placeholder_Key), leftImage: UIImage(named: "MailIcon"))
        emailTextField.keyboardType = .asciiCapable
        emailTextField.returnKeyType = .next
        
        self.configTextField(textField: verifyCodeTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_getVerifyCode_placeholder_Key), leftImage: UIImage(named: "icon_verify_code"))
        verifyCodeTextField.keyboardType = .asciiCapable
        verifyCodeTextField.returnKeyType = .next
        
        self.configTextField(textField: newPasswordTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_newPassword_placeholder_Key), leftImage: UIImage(named: "PasswordIcon"))
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 115, height: 40))
        
        sendVerifyCodeBtn.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        sendVerifyCodeBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x16a2ac), for: UIControlState.normal)
        sendVerifyCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        sendVerifyCodeBtn.layer.cornerRadius = 8
        sendVerifyCodeBtn.layer.masksToBounds = true
        sendVerifyCodeBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x0d737c)
        sendVerifyCodeBtn.setImage(UIImage(named: "icon_send_verifycode_plan"), for: UIControlState.normal)
        sendVerifyCodeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_getVerifyCode_btnTitle_Key), for: UIControlState.normal)
        sendVerifyCodeBtn.addTarget(self, action: #selector(self.getVerifyCodeBtnAction), for: UIControlEvents.touchUpInside)
        rightView.addSubview(sendVerifyCodeBtn)
       
        sendVerifyCodeBtn.titleLeftImageRightSetting(withSpace: 5)
        
        verifyCodeTextField.rightView = rightView
        verifyCodeTextField.rightViewMode = .always
        
//        let loginPwdRightBtn = UIButton(type: UIButtonType.custom)
//        loginPwdRightBtn.setImage(UIImage(named: "icon_password_open"), for: UIControlState.selected)
//        loginPwdRightBtn.setImage(UIImage(named: "icon_password_close"), for: UIControlState.normal)
//        loginPwdRightBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        loginPwdRightBtn.tag = 2001
//        loginPwdRightBtn.addTarget(self, action: #selector(self.passwordOpenBtnAction(btn:)), for: UIControlEvents.touchUpInside)
//        newPasswordTextField.rightView = loginPwdRightBtn
//        newPasswordTextField.rightViewMode = .always
        
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.keyboardType = .asciiCapable
        newPasswordTextField.returnKeyType = .go
        
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Confirm_BtnTitle_Key), for: UIControlState.normal)
        confirmBtn.layer.cornerRadius = 4
        confirmBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x2FBBA8)
        
        confirmBtn.addTarget(self, action: #selector(self.confirmBtnAction), for: UIControlEvents.touchUpInside)
    
        returnLoginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Confirm_Return_Login_BtnTitle_Key), for: UIControlState.normal)
    }
    
    func refreshUI() {
        
        self.configTextField(textField: emailTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_email_placeholder_Key), leftImage: UIImage(named: "MailIcon"))
        self.configTextField(textField: verifyCodeTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_getVerifyCode_placeholder_Key), leftImage: UIImage(named: "icon_verify_code"))
        self.configTextField(textField: newPasswordTextField, placeholder: MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_newPassword_placeholder_Key), leftImage: UIImage(named: "PasswordIcon"))
        sendVerifyCodeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_getVerifyCode_btnTitle_Key), for: UIControlState.normal)
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Confirm_BtnTitle_Key), for: UIControlState.normal)
        returnLoginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Confirm_Return_Login_BtnTitle_Key), for: UIControlState.normal)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let shadowSize0:CGFloat = 1
//        let shadowSpreadRect0 = CGRect(x: -shadowSize0, y: -shadowSize0, width: self.bounds.size.width+shadowSize0*2, height: self.bounds.size.height+shadowSize0*2)
//        let shadowSpreadRadius0 = 2 + shadowSize0;
//        let shadowPath0 = UIBezierPath(roundedRect: shadowSpreadRect0, cornerRadius: shadowSpreadRadius0)
//        self.layer.shadowPath = shadowPath0.cgPath
    }
    
    // MARK: - Action
    @objc func confirmBtnAction() {
        
        if self.confirmBtnTapClosure != nil {
            self.confirmBtnTapClosure!(emailTextField.text, verifyCodeTextField.text, newPasswordTextField.text)
        }
    }
    
    @IBAction func reutrnLoginAction(_ sender: UIButton) {
        if returnLoginBtnTapClosure != nil {
            returnLoginBtnTapClosure!()
        }
    }
    
    @objc func passwordOpenBtnAction(btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
        newPasswordTextField.isSecureTextEntry = !btn.isSelected
    }
    
    @objc func getVerifyCodeBtnAction() {
        
        if self.sendVerifyCodeBtnTapClosure != nil {
            self.sendVerifyCodeBtnTapClosure!(emailTextField.text)
        }
    }
    
    func configTextField(textField: UITextField, placeholder: String?, leftImage: UIImage?) {
        
        textField.placeholder = placeholder
        textField.setValue(UIColorFromRGB(hexRGB: 0x16a2ac), forKeyPath: "_placeholderLabel.textColor")
        textField.setValue(UIFont.systemFont(ofSize: 16), forKeyPath: "_placeholderLabel.font")
        textField.textAlignment = .left
        textField.textColor = UIColorFromRGB(hexRGB: 0x16a2ac)
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.keyboardType = .asciiCapable
        textField.returnKeyType = .next
        
        let leftView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 48))
        leftView1.image = leftImage
        leftView1.contentMode = .center
        textField.leftView = leftView1
        textField.leftViewMode = .always
        
//        textField.backgroundColor = UIColorFromRGB(hexRGB: 0x242323)
//        textField.layer.cornerRadius = 4
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColorFromRGB(hexRGB: 0x1a1a1a).cgColor
        
        textField.delegate = self
    }
    
}

extension ForgetPasswordContentView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            if !isNull(str: textField.text) {
                verifyCodeTextField.becomeFirstResponder()
                return true
            }
        }
        else if textField == verifyCodeTextField {
            if !isNull(str: textField.text) {
                newPasswordTextField.becomeFirstResponder()
                return true
            }
        }
        else if textField == newPasswordTextField {
            if !isNull(str: textField.text) {
                newPasswordTextField.resignFirstResponder()
                self.confirmBtnAction()
                return true
            }
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    
}

