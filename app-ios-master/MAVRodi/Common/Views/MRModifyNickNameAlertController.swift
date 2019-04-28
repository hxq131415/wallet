//
//  MRModifyNickNameAlertController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/5.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MRModifyNickNameAlertController: UIViewController {
    
    lazy var modifyUserNameAlertVw: MRModifyNickNameAlertView =
        MRModifyNickNameAlertView(frame: CGRect(x: 0, y: 0, width: 344 * theScaleToiPhone_6, height: 255))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x424242).withAlphaComponent(0.0)
        
        self.modifyUserNameAlertVw.center = CGPoint(x: Main_Screen_Width * 0.5, y: Main_Screen_Height * 0.5 - 50)
        self.view.addSubview(self.modifyUserNameAlertVw)
        
        // force layout
        self.modifyUserNameAlertVw.setNeedsLayout()
        self.modifyUserNameAlertVw.layoutIfNeeded()
        
        self.modifyUserNameAlertVw.layer.cornerRadius = 5
        self.modifyUserNameAlertVw.layer.masksToBounds = true
        self.modifyUserNameAlertVw.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        self.modifyUserNameAlertVw.alpha = 0.4
        
        self.modifyUserNameAlertVw.cancelBtnTapClosure = {
            self.hideAlert()
        }
        
        self.modifyUserNameAlertVw.determineBtnTapClosure = { (userName, quoteText) in
            if isNull(str: userName) {
                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ModifyUserName_nickname_empty_prompt_Key))
                return
            }
            
//            if isNull(str: quoteText) {
//                self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ModifyUserName_quetes_empty_prompt_Key))
//                return
//            }
            
            Log(message: "\(userName!), \(quoteText!)")
            self.requestForModifyNickName(nickName: userName!, person_quotes: quoteText!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Request
    func requestForModifyNickName(nickName: String, person_quotes: String) {
        
        var params: [String: Any] = [:]
        params["nickname"] = nickName
        params["personalQuotes"] = person_quotes
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_USER_UPDATE_USER_INFO, parameters: params, requestInfo: nil) { (data, status, message) in
            TEActingLoadingView.hideActingLoadingViewInSuperView(superView: self.view)
            self.hideAlert()
            if status == 0 {
                if let msg = message , !msg.isEmpty {
                    self.showMessage(msg)
                }
                else {
                    self.showMessage("修改成功")
                }
            }
            else {
                if let msg = message , !msg.isEmpty {
                    self.showMessage(msg)
                }
                else {
                    self.showMessage("修改失败")
                }
            }
        }
    }
    
    // MARK: -
    func showAlert() {
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let weakSelf = self {
                weakSelf.modifyUserNameAlertVw.transform = .identity
                weakSelf.modifyUserNameAlertVw.alpha = 1
                weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x424242).withAlphaComponent(0.3)
            }
        }) { (_) in
            
        }
    }
    
    func hideAlert() {
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let weakSelf = self {
                weakSelf.modifyUserNameAlertVw.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                weakSelf.modifyUserNameAlertVw.alpha = 0
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
