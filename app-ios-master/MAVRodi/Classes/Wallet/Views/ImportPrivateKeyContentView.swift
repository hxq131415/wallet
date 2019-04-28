//
//  ImportPrivateKeyContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/27.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class ImportPrivateKeyContentView: UIView , UITextFieldDelegate {

    @IBOutlet weak var ethPrivateKeyTextView: TETextView!
    @IBOutlet weak var etcPrivateKeyTextView: TETextView!
    @IBOutlet weak var setPwdTextField: UITextField!
    @IBOutlet weak var resetPwdTextField: UITextField!
    
    @IBOutlet weak var setPwdLbl: UILabel!
    @IBOutlet weak var rePwdLbl: UILabel!
    
    
    @IBOutlet weak var agreeSelectBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var bottomBtn: UIButton!
    
    @IBOutlet weak var leftIndicatorView: UIView!
    @IBOutlet weak var middleIndicatorView: UIView!
    @IBOutlet weak var rightIndicatorView: UIView!
    
    var importBtnTapClosure: (() -> Void)?
    var argreeBtnTapClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ethPrivateKeyTextView.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_eth_privatekey_placeholder_key)
        ethPrivateKeyTextView.placeholderColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        ethPrivateKeyTextView.placeholderFont = UIFont.systemFont(ofSize: 15)
        ethPrivateKeyTextView.layer.masksToBounds = true
        ethPrivateKeyTextView.layer.cornerRadius = 8
        ethPrivateKeyTextView.layer.borderColor = UIColorFromRGB(hexRGB: 0x7e7e7e).cgColor
        ethPrivateKeyTextView.layer.borderWidth = 1
        ethPrivateKeyTextView.font = UIFont.systemFont(ofSize: 15)
        ethPrivateKeyTextView.textContainerInset = UIEdgeInsets(top: 6, left: 8, bottom: 0, right: 8)
        ethPrivateKeyTextView.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        ethPrivateKeyTextView.autocorrectionType = .no
        ethPrivateKeyTextView.autocapitalizationType = .none
        
        etcPrivateKeyTextView.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_etc_privatekey_placeholder_key)
        etcPrivateKeyTextView.placeholderColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        etcPrivateKeyTextView.placeholderFont = UIFont.systemFont(ofSize: 15)
        etcPrivateKeyTextView.layer.masksToBounds = true
        etcPrivateKeyTextView.layer.cornerRadius = 8
        etcPrivateKeyTextView.layer.borderColor = UIColorFromRGB(hexRGB: 0x7e7e7e).cgColor
        etcPrivateKeyTextView.layer.borderWidth = 1
        etcPrivateKeyTextView.font = UIFont.systemFont(ofSize: 15)
        etcPrivateKeyTextView.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        etcPrivateKeyTextView.textContainerInset = UIEdgeInsets(top: 6, left: 8, bottom: 0, right: 8)
        etcPrivateKeyTextView.autocorrectionType = .no
        etcPrivateKeyTextView.autocapitalizationType = .none
        
        setPwdLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_setpwd_lbl_title_key)
        rePwdLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_repwd_lbl_title_key)
        
        setPwdTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_setpwd_textfield_placeholder_key)
        setPwdTextField.delegate = self
        setPwdTextField.borderStyle = .none
        setPwdTextField.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        setPwdTextField.font = UIFont.systemFont(ofSize: 15)
        setPwdTextField.textAlignment = .left
        setPwdTextField.keyboardType = .asciiCapable
        setPwdTextField.isSecureTextEntry = true
        setPwdTextField.addTarget(self, action: #selector(self.textFieldEditingChangedAction(textField:)), for: UIControlEvents.editingChanged)
        
        resetPwdTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_repwd_textfield_placeholder_key)
        resetPwdTextField.delegate = self
        resetPwdTextField.borderStyle = .none
        resetPwdTextField.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        resetPwdTextField.font = UIFont.systemFont(ofSize: 15)
        resetPwdTextField.textAlignment = .left
        resetPwdTextField.keyboardType = .asciiCapable
        resetPwdTextField.isSecureTextEntry = true
        
        agreeSelectBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_agreebtn_left_title_key), for: UIControlState.normal)
        agreeSelectBtn.setImage(UIImage(named: "icon_user_agement_normal"), for: UIControlState.normal)
        agreeSelectBtn.setImage(UIImage(named: "icon_user_agement_selected"), for: UIControlState.selected)
        agreeSelectBtn.titleRightAndImageLeftSetting(withSpace: 2)
        agreeSelectBtn.isSelected = true
        agreeSelectBtn.addTarget(self, action: #selector(self.agreeSelectBtnTapAction(btn:)), for: UIControlEvents.touchUpInside)
        
        agreeBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_agreebtn_right_title_key), for: UIControlState.normal)

        agreeBtn.addTarget(self, action: #selector(self.agreeBtnTapAction), for: UIControlEvents.touchUpInside)
        bottomBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_export_btn_title_key), for: UIControlState.normal)
        bottomBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x33C6B3)
        bottomBtn.addTarget(self, action: #selector(self.importBtnTapAction), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: - Action
    @objc func agreeSelectBtnTapAction(btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
    }
    
    @objc func agreeBtnTapAction() {
        
        if self.argreeBtnTapClosure != nil {
            self.argreeBtnTapClosure!()
        }
    }
    
    @objc func importBtnTapAction() {
        
        if self.importBtnTapClosure != nil {
            self.importBtnTapClosure!()
        }
    }
    
    // 输入发生变化
    @objc func textFieldEditingChangedAction(textField: UITextField) {
        
        if textField == setPwdTextField {
            if let pwd = textField.text {
                
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
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == setPwdTextField {
            if let text = textField.text {
                var pwd: String = ""
                if string.isEmpty {
                    // 删除
                    if text.count > 0 {
                        pwd = (text as NSString).substring(to: text.count - 1)
                    }
                    else {
                        pwd = ""
                    }
                }
                else {
                    pwd = text + string
                }
                
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
            }
        }
        
        return true
    }

}
