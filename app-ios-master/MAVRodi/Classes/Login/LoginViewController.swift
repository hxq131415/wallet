//
//  LoginViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/29.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class LoginViewController: MRBaseViewController {

    lazy var backgroundImageVw: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: Main_Screen_Height))
    lazy var headerImageVw: UIImageView = UIImageView(frame: CGRect.zero)
    
    var loginView: LoginContentView!
    
    var canLogin:Bool = true
    
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
        
        backgroundImageVw.image = UIImage(named: "login_background_image")
        self.view.addSubview(backgroundImageVw)
        backgroundImageVw.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
//        if iSiPhone5_5S_5C() {
//            backgroundImageVw.image = UIImage(named: "login_background_image_568.jpg")
//        }else if iSiPhone6_7_8() {
//            backgroundImageVw.image = UIImage(named: "login_background_image_667.jpg")
//        }else if iSiPhone6_7_8Plus() {
//            backgroundImageVw.image = UIImage(named: "login_background_image_736.jpg")
//        }else if iSiPhoneX() {
//            backgroundImageVw.image = UIImage(named: "login_background_image_812.jpg")
//        }
        headerImageVw.backgroundColor = UIColorFromRGB(hexRGB: 0x19303f)
        headerImageVw.layer.cornerRadius = 107 * theScaleToiPhone_6 / 2
        headerImageVw.layer.masksToBounds = true
        headerImageVw.contentMode = .center
        headerImageVw.image = UIImage(named: "login_header_logo")
        self.view.addSubview(headerImageVw)
        headerImageVw.snp.makeConstraints { (make) in
            make.top.equalTo(96 * theScaleToiPhone_6)
            make.width.height.equalTo(107 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
        }
//
//        if MRTools.currentSystemLanguageType() == .en_us {
//            headerImageVw.image = UIImage(named: "login_header_logo")
//        }
//        else {
//            headerImageVw.image = UIImage(named: "login_header_logo_cn")
//        }

        let betaImageVw = UIImageView(frame: CGRect.zero)
        self.view.addSubview(betaImageVw)
        betaImageVw.snp.makeConstraints { (make) in
            make.left.equalTo(self.headerImageVw.snp.right).offset(5)
            make.width.height.greaterThanOrEqualTo(10)
            make.top.equalTo(self.headerImageVw).offset(5)
        }

        betaImageVw.image = UIImage(named: "icon_beta")

        betaImageVw.isHidden = (iSBETA != 1)
        
        loginView = Bundle.main.loadNibNamed("LoginContentView", owner: nil, options: nil)?.first as? LoginContentView
        loginView.backgroundColor = UIColor.clear
        loginView.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width - 80 * theScaleToiPhone_6, height: 250 * theScaleToiPhone_6)
        self.view.addSubview(loginView)
        
        
        loginView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerImageVw.snp.bottom).offset(40 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
            make.width.equalTo(Main_Screen_Width - 80 * theScaleToiPhone_6)
            make.height.equalTo(330 * theScaleToiPhone_6)
        }
        
        // force layout 若不及时layout，iOS11以下会出现位置错乱问题
        loginView.superview?.setNeedsLayout()
        loginView.superview?.layoutIfNeeded()
        
        if let email = UserDefaults.standard.value(forKey: UDKEY_LOGIN_USER_EMAIL) as? String {
            loginView.userNameTextField.text = email
        }
        
        loginView.loginBtnTapClosure = { [weak self] (userName, password) in
            if let weakSelf = self {
                if(!weakSelf.canLogin)
                {
                    weakSelf.showMessage("账号已被锁定")
                    return
                }
                if isNull(str: userName) {// 请输入邮箱
                    weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginEnterUserName_orEmail_Prompt_Key))
                    return
                }
                
                if isNull(str: password) {// 请输入登录密码
                    weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginEnterPassword_Prompt_Key))
                    return
                }
                
                weakSelf.requestForLogin(email: userName!, password: password!)
            }
        }
        
        loginView.registerBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                let registerViewCtrl = RegisterViewController()
                weakSelf.navigationController?.pushViewController(registerViewCtrl, animated: true)
            }
        }
        
        loginView.forgetPasswordBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                let forgetPasswordViewCtrl = ForgetPasswordViewController()
                weakSelf.navigationController?.pushViewController(forgetPasswordViewCtrl, animated: true)
            }
        }
        
    }
    
    // App语言切换通知
    override func appLanguageChanged(notifi: Notification) {
        // 刷新UI界面
        loginView.refreshUI()
    }
    func countDown(count: Int){
        // 设置倒计时,按钮背景颜色
    
        self.loginView.loginBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x111111)
        
        var remainingCount: Int = count {
            willSet {
                self.loginView.loginBtn.setTitle("请(\(newValue))秒后再登陆", for: .normal)
                
                if newValue <= 0 {
                self.loginView.loginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_login_button_title_Key), for: UIControlState.normal)
                }
            }
        }
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.loginView.loginBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x32C5B2)
                    self.canLogin = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    // MARK: - Request 
    func requestForLogin(email: String, password: String) {
        
        if !MRVerifyTools.verifyEmailNum(email) {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginEnterVerify_email_address))
            return
        }
        
        var params: [String: Any] = [:]
        params["account"] = email
//        params["password"] = password.md5()
        params["password"] = password
        
        self.show(withMessage: MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loging_Prompt_Key), in: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_USER_LOGIN, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                weakSelf.hideHUD()
                if status == 0 {
                    weakSelf.canLogin = true
                    if let dict = data as? [String: Any] {
                        let loginModel = LoginInfoModel(JSON: dict)
                        weakSelf.showSuccessMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginSuccessful_Msg_Key))
//                        let checkKey = String(format: "%@%d", "importantTips",(loginModel?.userInfo!.user_id)!)
//                        let useridCheckValue = UserDefaults.standard.string(forKey: checkKey)
                        
//                        if(useridCheckValue != nil){
                            // 保存登录信息
                            saveUserDefaultsWithValue(value: loginModel?.token, key: UDKEY_LOGIN_TOKEN)
                            saveUserDefaultsWithValue(value: loginModel?.refresh_token, key: UDKEY_LOGIN_REFRESH_TOKEN)
                            saveUserDefaultsWithValue(value: loginModel?.toJSON(), key: UDKEY_USER_LOGIN_DATA)
                            // 记录上一次登录账号
                            saveUserDefaultsWithValue(value: loginModel?.userInfo?.account, key: UDKEY_LOGIN_USER_EMAIL)
                            // 请求个人信息，判断是否已经创建钱包了
                            MRTools.requestForGetUserData(completeBlock: {
                                if let userInfo = MRCommonShared.shared.userInfo {
                                    if userInfo.is_bind_wallet == 1 {
                                        (UIApplication.shared.delegate as? MRAppDelegate)?.setupWalletTabBarController()
                                    }
                                    else {
                                        (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                                    }
                                }
                                else {
                                    (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                                }
                                
                                weakSelf.navigationController?.dismiss(animated: true, completion: nil)
                            })
//                        }
                        /*
                        else{
                            //首先弹框提示用户重要注意
                            let confirm = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key)
                            MRCustomAlertController.showAlertController(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginEnterTips_ImportantAttention_title_Key), message: MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginEnterTips_ImportantAttention_content_Key), isShow: true, confirm: confirm, confirmClosure:{[weak self] (select) in
                                if(select)
                                {
                                    let checkKey = String(format: "%@%d", "importantTips",(loginModel?.userInfo!.user_id)!)
                                    UserDefaults.standard.set(true, forKey: checkKey)
                                    // 保存登录信息
                                    saveUserDefaultsWithValue(value: loginModel?.token, key: UDKEY_LOGIN_TOKEN)
                                    saveUserDefaultsWithValue(value: loginModel?.refresh_token, key: UDKEY_LOGIN_REFRESH_TOKEN)
                                    saveUserDefaultsWithValue(value: loginModel?.toJSON(), key: UDKEY_USER_LOGIN_DATA)
                                    // 记录上一次登录账号
                                    saveUserDefaultsWithValue(value: loginModel?.userInfo?.account, key: UDKEY_LOGIN_USER_EMAIL)
                                    // 请求个人信息，判断是否已经创建钱包了
                                    MRTools.requestForGetUserData(completeBlock: {
                                        if let userInfo = MRCommonShared.shared.userInfo {
                                            if userInfo.is_bind_wallet == 1 {
                                                (UIApplication.shared.delegate as? MRAppDelegate)?.setupWalletTabBarController()
                                            }
                                            else {
                                                (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                                            }
                                        }
                                        else {
                                            (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                                        }
                                        
                                        weakSelf.navigationController?.dismiss(animated: true, completion: nil)
                                    })
                                }
                                else
                                {
                                    if(loginModel?.cpStatus == 0)//状态返回值cpStatus，为0则必须修改支付密码
                                    {
                                        let confirm = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key)
                                        MRCustomAlertController.showAlertController(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginEnterTips_ChangePayPasswrod_title_Key), message: MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginEnterTips_ChangePayPasswrod_content_Key), confirm: confirm, confirmClosure: {
                                            
                                            let modifyPwdCtrl = ForceChangeWalletModifyPasswordViewController()
                                            modifyPwdCtrl.loginModel = loginModel
                                            self!.navigationController?.pushViewController(modifyPwdCtrl, animated: true)
                                        })
                                    }
                                    else
                                    {
                                        // 保存登录信息
                                        saveUserDefaultsWithValue(value: loginModel?.token, key: UDKEY_LOGIN_TOKEN)
                                        saveUserDefaultsWithValue(value: loginModel?.refresh_token, key: UDKEY_LOGIN_REFRESH_TOKEN)
                                        saveUserDefaultsWithValue(value: loginModel?.toJSON(), key: UDKEY_USER_LOGIN_DATA)
                                        // 记录上一次登录账号
                                        saveUserDefaultsWithValue(value: loginModel?.userInfo?.account, key: UDKEY_LOGIN_USER_EMAIL)
                                        // 请求个人信息，判断是否已经创建钱包了
                                        MRTools.requestForGetUserData(completeBlock: {
                                            if let userInfo = MRCommonShared.shared.userInfo {
                                                if userInfo.is_bind_wallet == 1 {
                                                    (UIApplication.shared.delegate as? MRAppDelegate)?.setupWalletTabBarController()
                                                }
                                                else {
                                                    (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                                                }
                                            }
                                            else {
                                                (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                                            }
                                            
                                            weakSelf.navigationController?.dismiss(animated: true, completion: nil)
                                        })
                                    }
                                }
                                
                                
                            })
                        }
                        */
                        
                    }
                }
                else if status == -21
                {
                    weakSelf.canLogin = false
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    weakSelf.countDown(count: 60*5)
                    
                }
                else {
                    weakSelf.canLogin = true
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginFailed_Msg_Key))
                    }
                }
            }
        }
    }
    
    
}
