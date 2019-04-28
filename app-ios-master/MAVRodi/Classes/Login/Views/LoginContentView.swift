//
//  LoginContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/30.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class LoginContentView: UIView {

    @IBOutlet weak var backgroundVw: UIView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    var loginBtnTapClosure: ((_ username: String?, _ password: String?) -> ())?
    var registerBtnTapClosure: (() -> ())?
    var forgetPasswordBtnTapClosure: (() -> ())?
    
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
        
        userNameTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_userName_placeholder_Key)
        userNameTextField.setValue(UIColorFromRGB(hexRGB: 0x16a2ac), forKeyPath: "_placeholderLabel.textColor")
        userNameTextField.setValue(UIFont.systemFont(ofSize: 16), forKeyPath: "_placeholderLabel.font")
        userNameTextField.textAlignment = .left
        userNameTextField.textColor = UIColorFromRGB(hexRGB: 0x16a2ac)
        userNameTextField.font = UIFont.systemFont(ofSize: 16)
        userNameTextField.keyboardType = .asciiCapable
        userNameTextField.returnKeyType = .next
        
        let leftView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 48))
        leftView1.image = UIImage(named: "MailIcon")
        leftView1.contentMode = .center
        userNameTextField.leftView = leftView1
        userNameTextField.leftViewMode = .always
        
        passwordTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_password_placeholder_Key)
        passwordTextField.setValue(UIColorFromRGB(hexRGB: 0x16a2ac), forKeyPath: "_placeholderLabel.textColor")
        passwordTextField.setValue(UIFont.systemFont(ofSize: 16), forKeyPath: "_placeholderLabel.font")
        passwordTextField.isSecureTextEntry = true
        
        let leftView2 = UIImageView(frame: CGRect(x: 14, y: 0, width: 54, height: 48))
        leftView2.image = UIImage(named: "PasswordIcon")
        leftView2.contentMode = .center
        passwordTextField.leftView = leftView2
        passwordTextField.leftViewMode = .always
        
        passwordTextField.textAlignment = .left
        passwordTextField.textColor = UIColorFromRGB(hexRGB: 0x16a2ac)
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.returnKeyType = .go
        
        userNameTextField.backgroundColor = UIColorFromRGB(hexRGB: 0x19303f)
        userNameTextField.layer.cornerRadius = 4
//        userNameTextField.layer.borderWidth = 1
//        userNameTextField.layer.borderColor = UIColorFromRGB(hexRGB: 0x1a1a1a).cgColor
        
        passwordTextField.backgroundColor = UIColorFromRGB(hexRGB: 0x19303f)
        passwordTextField.layer.cornerRadius = 4
//        passwordTextField.layer.borderWidth = 1
//        passwordTextField.layer.borderColor = UIColorFromRGB(hexRGB: 0x1a1a1a).cgColor
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        forgetPasswordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_forgetPassword_button_title_Key), for: UIControlState.normal)
        
        loginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_login_button_title_Key), for: UIControlState.normal)
        loginBtn.layer.cornerRadius = 4
        loginBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x32C5B2)
        
        registerBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_register_button_title_Key), for: UIControlState.normal)
//        registerBtn.layer.cornerRadius = 4
//        registerBtn.layer.masksToBounds = true
//        registerBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x64caff).cgColor
//        registerBtn.layer.borderWidth = 1.0
        
        
        loginBtn.addTarget(self, action: #selector(self.loginAction), for: UIControlEvents.touchUpInside)
        registerBtn.addTarget(self, action: #selector(self.registerAction), for: UIControlEvents.touchUpInside)
        forgetPasswordBtn.addTarget(self, action: #selector(self.forgetPasswordAction), for: UIControlEvents.touchUpInside)
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
    @objc func loginAction() {
        self.endEditing(true)
        if self.loginBtnTapClosure != nil {
            self.loginBtnTapClosure!(userNameTextField.text, passwordTextField.text)
        }
    }
    
    @objc func registerAction() {
        self.endEditing(true)
        if self.registerBtnTapClosure != nil {
            self.registerBtnTapClosure!()
        }
    }
    
    @objc func forgetPasswordAction() {
        self.endEditing(true)
        if self.forgetPasswordBtnTapClosure != nil {
            self.forgetPasswordBtnTapClosure!()
        }
    }
    
    func refreshUI() {
        
        userNameTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_userName_placeholder_Key)
        passwordTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_password_placeholder_Key)
        forgetPasswordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_forgetPassword_button_title_Key), for: UIControlState.normal)
        registerBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_register_button_title_Key), for: UIControlState.normal)
        loginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_login_button_title_Key), for: UIControlState.normal)
        loginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_login_button_title_Key), for: UIControlState.normal)
    }
    
}

extension LoginContentView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            if !isNull(str: textField.text) {
                passwordTextField.becomeFirstResponder()
                return true
            }
        }
        else if textField == passwordTextField {
            if !isNull(str: textField.text) {
                textField.resignFirstResponder()
                self.loginAction()
                return true
            }
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    
}

