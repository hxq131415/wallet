//
//  ForgetPasswordViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/3.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  忘记密码

import UIKit

class ForgetPasswordViewController: MRBaseViewController {
    
    lazy var backgroundImageVw: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: Main_Screen_Height))
    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    var forgetContentView: ForgetPasswordContentView!
    
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_NavigationTitle_Key)
        navBarView.titleLbl.textColor = UIColor.white
        navBarView.backButtonImage = UIImage(named: "icon_back_white")
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        forgetContentView = Bundle.main.loadNibNamed("ForgetPasswordContentView", owner: nil, options: nil)?.last as? ForgetPasswordContentView
        forgetContentView.backgroundColor = UIColor.clear
        self.view.addSubview(forgetContentView)
        
        forgetContentView.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width - 80 * theScaleToiPhone_6, height: 250 * theScaleToiPhone_6)
        forgetContentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp.bottom).offset(174 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
            make.width.equalTo(Main_Screen_Width - 80 * theScaleToiPhone_6)
            make.height.equalTo(330 * theScaleToiPhone_6)
        }
        
        // force layout 若不及时layout，iOS11以下会出现位置错乱问题
        forgetContentView.superview?.setNeedsLayout()
        forgetContentView.superview?.layoutIfNeeded()
        
        if let email = UserDefaults.standard.value(forKey: UDKEY_LOGIN_USER_EMAIL) as? String {
            forgetContentView.emailTextField.text = email
        }
        
        forgetContentView.sendVerifyCodeBtnTapClosure = { [weak self](email) in
            if let weakSelf = self {
                if isNull(str: email) {// 请输入邮箱
                    weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_email_empty_prompt_Key))
                    return
                }
                
                weakSelf.requestForGetVerifyCode(email: email!)
            }
        }
        
        forgetContentView.returnLoginBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        forgetContentView.confirmBtnTapClosure = { [weak self] (email, verifycode,  newpassword) in
            if let weakSelf = self {
                
                if isNull(str: email) {// 请输入邮箱
                    weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_email_empty_prompt_Key))
                    return
                }
                
                if isNull(str: verifycode) {
                    weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_verifycode_empty_prompt_Key))
                    return
                }
                
                if isNull(str: newpassword) {// 请输入新密码
                    weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_newPassword_empty_prompt_Key))
                    return
                }
                
                weakSelf.requestForResetPassword(mail: email!, verifycode: verifycode!, newPwd: newpassword!)
            }
        }
        
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
        
        let verifyCodeBtn = forgetContentView.sendVerifyCodeBtn
        
        if countOfDown <= 1 {
            countOfDown = 61
            self.stopTimer()
            verifyCodeBtn.isEnabled = true
            verifyCodeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_getVerifyCode_btnTitle_Key), for: UIControlState.normal)
            verifyCodeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_getVerifyCode_btnTitle_Key), for: UIControlState.highlighted)
        }
        else {
            countOfDown = countOfDown - 1
            verifyCodeBtn.isEnabled = false
            verifyCodeBtn.setTitle("\(countOfDown)s", for: UIControlState.normal)
            verifyCodeBtn.setTitle("\(countOfDown)s", for: UIControlState.highlighted)
        }
    }
    
    override func appLanguageChanged(notifi: Notification) {
        forgetContentView.refreshUI()
    }
    
    // MARK: - Request
    func requestForGetVerifyCode(email: String) {
        
        var params: [String: Any] = [:]
        params["mail"] = email
        params["type"] = MRGetVerifyCodeType.resetPassword.rawValue
        
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
    
    // 重置密码
    func requestForResetPassword(mail: String, verifycode: String, newPwd: String) {
        
        var params: [String: Any] = [:]
        params["account"] = mail
        params["verifyCode"] = verifycode
        params["password"] = newPwd
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_RETRIEVE_PASSWORD, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        weakSelf.popWithAnimate()
                    })
                }
                else {
                    if let errMsg = message, !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                }
            }
        }
    }

}
