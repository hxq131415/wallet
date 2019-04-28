//
//  WalletEnterPasswordAlertController.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/7.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  输入钱包密码

import UIKit

class WalletEnterPasswordAlertController: MRBaseViewController {
    
    lazy var enterPwdAlertVw: WalletEnterPasswordView =
        WalletEnterPasswordView(frame: CGRect(x: 0, y: 0, width: 320 * theScaleToiPhone_6, height: 220 * theScaleToiPhone_6))
    
    var enterPwdFinishClosure: ((_ pwd: String) -> Void)?
    var isDeleteWallet: Bool = false
    
    var hideAlertViewClosure: (() -> Swift.Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x424242).withAlphaComponent(0.0)
        
        self.enterPwdAlertVw.center = CGPoint(x: Main_Screen_Width * 0.5, y: Main_Screen_Height * 0.5 - 50)
        self.view.addSubview(self.enterPwdAlertVw)
        
        // force layout
        self.enterPwdAlertVw.setNeedsLayout()
        self.enterPwdAlertVw.layoutIfNeeded()
        
        self.enterPwdAlertVw.layer.cornerRadius = 5
        self.enterPwdAlertVw.layer.masksToBounds = true
        self.enterPwdAlertVw.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        self.enterPwdAlertVw.alpha = 0.4
        
        if isDeleteWallet {
            self.enterPwdAlertVw.determineBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletSettingsPage_delete_btn_title_key), for: UIControlState.normal)
            
            self.enterPwdAlertVw.enterUserNameLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletEnterPasswordAlert_login_pwd_top_lbl_text_key), numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x111111), font: UIFont.systemFont(ofSize: 16))
            
            let paraphStyle = NSMutableParagraphStyle()
            paraphStyle.alignment = .center
            let userNamePlaceholderAttText = NSMutableAttributedString(string: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletEnterPasswordAlert_login_pwd_textfield_placeholder_key), attributes: [NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.paragraphStyle: paraphStyle])
            self.enterPwdAlertVw.pwdTextField.attributedPlaceholder = userNamePlaceholderAttText
        }
        
        
        self.enterPwdAlertVw.cancelBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.hideAlert()
            }
        }
        
        self.enterPwdAlertVw.determineBtnTapClosure = { [weak self](pwd) in
            if let weakSelf = self {
                if !weakSelf.isDeleteWallet  {
                    if isNull(str: pwd) {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletEnterPasswordAlert_wallet_pwd_enter_empty_prompt_text_key))
                        return
                    }
                }
                else {
                    if isNull(str: pwd) {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletEnterPasswordAlert_login_pwd_textfield_placeholder_key))
                        return
                    }
                }
                
                weakSelf.hideAlert()
                if weakSelf.enterPwdFinishClosure != nil {
                    weakSelf.enterPwdFinishClosure!(pwd!)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    func showAlert() {
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let weakSelf = self {
                weakSelf.enterPwdAlertVw.transform = .identity
                weakSelf.enterPwdAlertVw.alpha = 1
                weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x424242).withAlphaComponent(0.3)
            }
        }) { (_) in
            
        }
    }
    
    func hideAlert() {
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let weakSelf = self {
                weakSelf.enterPwdAlertVw.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                weakSelf.enterPwdAlertVw.alpha = 0
                weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x424242).withAlphaComponent(0)
            }
        }) { [weak self](_) in
            if let weakSelf = self {
                weakSelf.dismiss(animated: false, completion: {
                    if weakSelf.hideAlertViewClosure != nil {
                        weakSelf.hideAlertViewClosure!()
                    }
                })
            }
        }
    }

}
