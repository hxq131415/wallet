//
//  MRPaymentPasswordInputController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/4.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

enum PaymentPwdAlertType {
    case setPwd      // 设置密码
    case confirmPwd  // 密码确认
}

class MRPaymentPasswordInputController: MRBaseViewController {
    
    lazy var payPasswordInputView: SetPaymentPasswordAlertView =
        SetPaymentPasswordAlertView(frame: CGRect(x: 0, y: 0, width: 344 * theScaleToiPhone_6, height: 300))
    var type: PaymentPwdAlertType = .setPwd
    
    var confirmBtnTapClosure: ((_ pwd: String, _ verifyCode: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x424242).withAlphaComponent(0.0)
        
        self.payPasswordInputView.center = CGPoint(x: Main_Screen_Width * 0.5, y: Main_Screen_Height * 0.5 - 80)
        self.view.addSubview(self.payPasswordInputView)
        
        if type == .setPwd {
            payPasswordInputView.topBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: SetPaymentPassword_top_title_key), textColor: UIColorFromRGB(hexRGB: 0xbabcc6), font: UIFont.systemFont(ofSize: 15), normalImage: nil, selectedImage: nil, backgroundColor: nil)
            payPasswordInputView.topBtn.titleLabel?.textAlignment = .center
        }
        else {
            payPasswordInputView.topBtn.configButtonForNormal(title: "密码确认", textColor: UIColorFromRGB(hexRGB: 0xbabcc6), font: UIFont.systemFont(ofSize: 15), normalImage: nil, selectedImage: nil, backgroundColor: nil)
            payPasswordInputView.topBtn.titleLabel?.textAlignment = .center
        }
        
        // force layout
        self.payPasswordInputView.setNeedsLayout()
        self.payPasswordInputView.layoutIfNeeded()
        
        self.payPasswordInputView.layer.cornerRadius = 5
        self.payPasswordInputView.layer.masksToBounds = true
        self.payPasswordInputView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        self.payPasswordInputView.alpha = 0.3
        
        self.payPasswordInputView.cancelBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.hideAlert()
            }
        }
        
        // 发送验证码
        self.payPasswordInputView.sendVerifyCodeBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                if let email = MRCommonShared.shared.loginInfo?.userInfo?.account {
                    weakSelf.view.endEditing(true)
                    weakSelf.requestForGetVerifyCode(email: email)
                }
            }
        }
        
        self.payPasswordInputView.determineBtnTapClosure = { [weak self](paymenPwd, verifyCode) in
            if let weakSelf = self {
                
                weakSelf.view.endEditing(true)
                
                if isNull(str: paymenPwd) {
                    weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: SetPaymentPassword_password_placeholder_text_key))
                    return
                }
                
                if isNull(str: verifyCode) {
                    weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ForgetPassword_verifycode_empty_prompt_Key))
                    return
                }
                
                if weakSelf.confirmBtnTapClosure != nil {
                    weakSelf.hideAlert()
                    weakSelf.confirmBtnTapClosure!(paymenPwd!, verifyCode!)
                }
                else {
                    if let email = MRCommonShared.shared.loginInfo?.userInfo?.account {
                        weakSelf.requestForResetPassword(mail: email, verifycode: verifyCode!, newPwd: paymenPwd!)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    MRCommonShared.shared.cleanUserLoginInfo()
                    weakSelf.navigationController?.popToRootViewController(animated: false)
                    (UIApplication.shared.delegate as? MRAppDelegate)?.checkUserLoginState()
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                        weakSelf.popWithAnimate()
//                        
//                    })
                }
                else {
                    if let errMsg = message, !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                }
            }
        }
    }
    
    // MARK: -
    func showAlert() {
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let weakSelf = self {
                weakSelf.payPasswordInputView.transform = .identity
                weakSelf.payPasswordInputView.alpha = 1
                weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x424242).withAlphaComponent(0.3)
            }
        }) { (_) in
            
        }
    }
    
    func hideAlert() {
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let weakSelf = self {
                weakSelf.payPasswordInputView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                weakSelf.payPasswordInputView.alpha = 0
                weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x424242).withAlphaComponent(0)
            }
        }) { [weak self](_) in
            if let weakSelf = self {
                weakSelf.dismiss(animated: false, completion: {
                    
                })
            }
        }
    }

}
