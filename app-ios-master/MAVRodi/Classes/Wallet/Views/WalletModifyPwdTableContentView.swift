//
//  CreateWalletTableContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class WalletModifyPwdTableContentView: UIView, UITextFieldDelegate, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var curPwdTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var rePwdTextField: UITextField!
    @IBOutlet weak var bottomInfoLbl: TTTAttributedLabel!
    
    @IBOutlet weak var tipsBLInfoLbl: UILabel!
    
    @IBOutlet weak var tipsLLInfoLbl: UILabel!
    
    @IBOutlet weak var tipsNInfoLbl: UILabel!
    
    @IBOutlet weak var tips8InfoLbl: UILabel!
    
    
    
    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var curPwdLbl: UILabel!
    @IBOutlet weak var newPwdLbl: UILabel!
    @IBOutlet weak var rePwdLbl: UILabel!
    
    @IBOutlet weak var leftIndicatorView: UIView!
    @IBOutlet weak var middleIndicatorView: UIView!
    @IBOutlet weak var rightIndicatorView: UIView!
    
    var createBtnTapClosure: (() -> Void)?
    var resetPwdBtnTapClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        curPwdLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_current_password_title_key)
        newPwdLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_new_password_title_key)
        rePwdLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_re_password_title_key)
        tipsBLInfoLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_tipsBL_lbl_text_key)
        tipsLLInfoLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_tipsBL_lbl_text_key)
        tipsNInfoLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_tipsBL_lbl_text_key)
        tips8InfoLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_tipsBL_lbl_text_key)
        
        bottomInfoLbl.textAlignment = .left
        bottomInfoLbl.numberOfLines = 0
        
        let leftText = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_bottom_lbl_text_key)
        let rightText = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_bottom_right_btn_title_key)
        
        let bottomInfoText = leftText + rightText
        
        
        let attributeText: NSMutableAttributedString = NSMutableAttributedString(string: bottomInfoText)
        attributeText.addAttributes([NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x676767), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, attributeText.string.count))
        
        let range = (bottomInfoText as NSString).range(of: rightText)
        attributeText.addAttributes([NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x64CAFF), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], range: range)
        
        bottomInfoLbl.delegate = self
        bottomInfoLbl.attributedText = attributeText
        
        bottomInfoLbl.activeLinkAttributes = [NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x33C6B3), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        bottomInfoLbl.linkAttributes = [NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x33C6B3), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        bottomInfoLbl.addLink(toTransitInformation: ["select": rightText], with: range)
        
        curPwdTextField.borderStyle = .none
        curPwdTextField.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        curPwdTextField.font = UIFont.systemFont(ofSize: 15)
        curPwdTextField.textAlignment = .left
        curPwdTextField.keyboardType = .asciiCapable
        curPwdTextField.isSecureTextEntry = true
        
        pwdTextField.delegate = self
        pwdTextField.borderStyle = .none
        pwdTextField.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        pwdTextField.font = UIFont.systemFont(ofSize: 15)
        pwdTextField.textAlignment = .left
        pwdTextField.keyboardType = .asciiCapable
        pwdTextField.isSecureTextEntry = true
        pwdTextField.addTarget(self, action: #selector(self.textFieldEditingChangedAction(textField:)), for: UIControlEvents.editingChanged)
        
        rePwdTextField.delegate = self
        rePwdTextField.borderStyle = .none
        rePwdTextField.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        rePwdTextField.font = UIFont.systemFont(ofSize: 15)
        rePwdTextField.textAlignment = .left
        rePwdTextField.keyboardType = .asciiCapable
        rePwdTextField.isSecureTextEntry = true
        
        createBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_confirm_btn_title_key), for: UIControlState.normal)
        createBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x33C6B3)
        createBtn.layer.masksToBounds = true
        createBtn.layer.cornerRadius = 4
        createBtn.addTarget(self, action: #selector(self.createBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: - Action
    @objc func createBtnAction() {
        
        if self.createBtnTapClosure != nil {
            self.createBtnTapClosure!()
        }
    }
    
    @objc func resetPwdBtnAction() {
        
        
    }
    
    // 输入发生变化
    @objc func textFieldEditingChangedAction(textField: UITextField) {
        
        if textField == pwdTextField {
            if let pwd = textField.text {
                
                // 验证是否超过8位
                if(pwd.count >= 8)
                {
                    tips8InfoLbl.textColor = UIColorFromRGB(hexRGB: 0x33C6B3)
                }
                else{
                    tips8InfoLbl.textColor = UIColorFromRGB(hexRGB: 0xAA0202)
                }
                // 验证是否包含大写字母
                if(MRVerifyTools.verifyContainsCapitalLetter(pwd))
                {
                    tipsBLInfoLbl.textColor = UIColorFromRGB(hexRGB: 0x33C6B3)
                }
                else{
                    tipsBLInfoLbl.textColor = UIColorFromRGB(hexRGB: 0xAA0202)
                }
                // 验证是否包含小写字母
                if(MRVerifyTools.verifyContainsLowerLetter(pwd))
                {
                    tipsLLInfoLbl.textColor = UIColorFromRGB(hexRGB: 0x33C6B3)
                }
                else{
                    tipsLLInfoLbl.textColor = UIColorFromRGB(hexRGB: 0xAA0202)
                }
                
                // 验证是否包含数字/不包含特殊字符
                if(MRVerifyTools.verifyContainsIncludeNumber(pwd))
                {
                    tipsNInfoLbl.textColor = UIColorFromRGB(hexRGB: 0x33C6B3)
                }
                else{
                    tipsNInfoLbl.textColor = UIColorFromRGB(hexRGB: 0xAA0202)
                }
                
                
                
                /**
                let level = MRTools.getWalletPasswordLevel(pwd: pwd)
                switch level {
                case .low:
                    Log(message: "密码强度 低")
                    leftIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0xe0004f)
                    middleIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
                    rightIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
                case .middle:
                    Log(message: "密码强度 中")
                    leftIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0xe0004f)
                    middleIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0xfffc00)
                    rightIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
                case .high:
                    Log(message: "密码强度 高")
                    leftIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0xe0004f)
                    middleIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0xfffc00)
                    rightIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0x80c269)
                case .none:
                    Log(message: "密码强度 无")
                    leftIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
                    middleIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
                    rightIndicatorView.backgroundColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
                }
                **/
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // 输入拦截
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    // MARK: - TTTAttributedLabelDelegate
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithTransitInformation components: [AnyHashable : Any]!) {
        
        if self.resetPwdBtnTapClosure != nil {
            self.resetPwdBtnTapClosure!()
        }
    }
    
}
