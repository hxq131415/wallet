//
//  RegisterViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/30.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  注册

import UIKit

class RegisterViewController: MRBaseViewController {

    lazy var backgroundImageVw: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: Main_Screen_Height))
    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    var registerView: RegisterContentView!
    
    private var timer: Timer?
    private var countOfDown: Int = 61
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.subViewInitlzation()
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Intialization
    func subViewInitlzation() {
        
        self.view.addSubview(backgroundImageVw)
        backgroundImageVw.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        backgroundImageVw.image = UIImage(named: "login_background_image")
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.bottomLine.isHidden = true
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_Navigation_title_key)
        navBarView.titleLbl.textColor = UIColor.white
        navBarView.backButtonImage = UIImage(named: "icon_back_white")
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        registerView = Bundle.main.loadNibNamed("RegisterContentView", owner: nil, options: nil)?.first as? RegisterContentView
        self.view.addSubview(registerView)
        
        registerView.backgroundColor = UIColor.clear
        registerView.frame = CGRect(x: 0, y: MR_Custom_NavigationBar_Height + 100 * theScaleToiPhone_6, width: Main_Screen_Width, height: Main_Screen_Height - MR_Custom_NavigationBar_Height - 100 * theScaleToiPhone_6)
        registerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(MR_Custom_NavigationBar_Height + 100 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
            make.width.equalTo(Main_Screen_Width - 80 * theScaleToiPhone_6)
            make.height.equalTo(Main_Screen_Height - MR_Custom_NavigationBar_Height - 100 * theScaleToiPhone_6)
        }
        
        // force layout 若不及时layout，iOS11以下会出现位置错乱问题
        registerView.superview?.setNeedsLayout()
        registerView.superview?.layoutIfNeeded()
        
        // 获取验证码
        registerView.getVerifyCodeBtnTapClosure = { (email) in
            if isNull(str: email) {
                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_email_empty_prompt_Key))
                return
            }
            
            self.requestForGetVerifyCode(email: email!)
        }
        
        registerView.returnLoginBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        registerView.languageSwitchingBtnTapClosure = { (isChinese) in
            self.changeAppLanguage(isChinese: isChinese)
        }
        
        // 用户协议
        registerView.userAgreementBtnTapClosure = {
            let userAgreementCtrl = UserAgreementViewController()
            self.navigationController?.pushViewController(userAgreementCtrl, animated: true)
        }
        
        // 注册
        registerView.registerBtnTapClosure = { (userName, email, verifycode, loginPassword, invitationcode, isChecked) in
            
            if isNull(str: userName) {
                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_username_empty_prompt_Key))
                return
            }
            
            if isNull(str: email) {
                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_email_empty_prompt_Key))
                return
            }
            
            if isNull(str: verifycode) {
                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_verifycode_empty_prompt_Key))
                return
            }
            
            if isNull(str: loginPassword) {
                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_loginPassword_empty_prompt_Key))
                return
            }
            
            if isNull(str: invitationcode) {
                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_invitationcode_empty_prompt_Key))
                return
            }
            
//            if !isChecked {
//                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_useragree_check_prompt_Key))
//                return
//            }
            
            self.requestForRegister(userName: userName!, email: email!, verifyCode: verifycode!, loginPassword: loginPassword!, invitationCode: invitationcode!)
        }
        
    }

    override func appLanguageChanged(notifi: Notification) {
        
        registerView.refreshUI()
    }
    
    // 切换语言
    func changeAppLanguage(isChinese: Bool) {
        
        if isChinese {
            
            UserDefaults.standard.setValue(MRSystemLanaguageType.zh_cn.rawValue, forKey: UDKEY_APP_CURRENT_SET_LANGUAGE)
            UserDefaults.standard.synchronize()
        }else {
            
            UserDefaults.standard.setValue(MRSystemLanaguageType.en_us.rawValue, forKey: UDKEY_APP_CURRENT_SET_LANGUAGE)
            UserDefaults.standard.synchronize()
        }
        
        self.show(withMessage: "正在设置语言...", in: self.view)
        dispatch_after_in_main(2, block: {
            self.hideHUD()
            NotificationCenter.default.post(name: Notification.Name(rawValue: NNKEY_APP_LANAGUAGE_CHANGED_NOTIFICATION), object: nil, userInfo: nil)
        })
        
    }
    func startTimer() {
        
        if timer == nil {
            timer = Timer(fireAt: Date.distantPast, interval: 1.0, target: self, selector: #selector(self.updateTimerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTimerAction() {
        
        let verifyCodeBtn = registerView.sendVerifyCodeBtn
        
        if countOfDown <= 1 {
            countOfDown = 61
            self.stopTimer()
            verifyCodeBtn.isEnabled = true
            verifyCodeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_getVerifycode_button_title_key), for: UIControlState.normal)
            verifyCodeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Register_getVerifycode_button_title_key), for: UIControlState.highlighted)
        }
        else {
            countOfDown = countOfDown - 1
            verifyCodeBtn.isEnabled = false
            verifyCodeBtn.setTitle("\(countOfDown)s", for: UIControlState.normal)
            verifyCodeBtn.setTitle("\(countOfDown)s", for: UIControlState.highlighted)
        }
    }
    
    // MARK: - Request
    func requestForGetVerifyCode(email: String) {
        
        var params: [String: Any] = [:]
        params["mail"] = email
        params["type"] = MRGetVerifyCodeType.register.rawValue
        
        
        self.show(withMessage: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_Sending_Key), in: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_SEND_VERIFYCODE, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                weakSelf.hideHUD()
                weakSelf.startTimer()
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_Send_Successful_Key))
                    }
                }
                else {
                    if let errMsg = message, !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_Send_Faild_Key))
                    }
                }
            }
        }
    }
    
    // 注册
    func requestForRegister(userName: String, email: String, verifyCode: String, loginPassword: String, invitationCode: String) {
        
        var params: [String: Any] = [:]
        params["username"] = userName
        params["account"] = email
        params["verifyCode"] = verifyCode
        params["password"] = loginPassword
        params["invitationCode"] = invitationCode
        
        self.show(withMessage: nil, in: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_USER_REGISTER, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                weakSelf.hideHUD()
                if status == 0 {
                    if let msg = message , !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("Registered successfully")
                    }
                    
                    if let dict = data as? [String: Any] {
                        let loginModel = LoginInfoModel(JSON: dict)
                        
                        // 保存登录信息
                        saveUserDefaultsWithValue(value: loginModel?.token, key: UDKEY_LOGIN_TOKEN)
                        saveUserDefaultsWithValue(value: loginModel?.refresh_token, key: UDKEY_LOGIN_REFRESH_TOKEN)
                        saveUserDefaultsWithValue(value: loginModel?.toJSON(), key: UDKEY_USER_LOGIN_DATA)
                        saveUserDefaultsWithValue(value: loginModel?.userInfo?.account, key: UDKEY_LOGIN_USER_EMAIL)
                    }
                    
                    (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                    weakSelf.navigationController?.dismiss(animated: true, completion: nil)
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage("Registration failed")
                    }
                }
            }
        }
    }
    
    
}
