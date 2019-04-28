//
//  CreateWalletTableContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class CreateWalletTableContentView: UIView, UITextFieldDelegate {

    @IBOutlet weak var setPwdLbl: UILabel!
    
    @IBOutlet weak var topTitleLbl: UILabel!
    @IBOutlet weak var contentTextLbl: UILabel!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var rePwdTextField: UITextField!
    @IBOutlet weak var topTextLblContentView: UIView!
    
    @IBOutlet weak var alertBtn1: UIButton!
    @IBOutlet weak var alertBtn2: UIButton!
    @IBOutlet weak var alertBtn3: UIButton!
    @IBOutlet weak var alertBtn4: UIButton!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var createBtn: UIButton!
    
    
    var createBtnTapClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //先边框
        topTextLblContentView.layer.borderWidth = 0.3
        topTextLblContentView.layer.borderColor = UIColorFromRGB(hexRGB: 0x8a8a8a).cgColor
        topTextLblContentView.layer.cornerRadius = 8
        topTextLblContentView.layer.masksToBounds = true
        
        
        topTitleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_top_reminder_title_key)
        contentTextLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_top_reminder_content_key)
        
        setPwdLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_setpwd_lbl_title_key)

        
        pwdTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_setpwd_textfield_placeholder_key)
        pwdTextField.delegate = self
        pwdTextField.borderStyle = .none
        pwdTextField.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        pwdTextField.font = UIFont.systemFont(ofSize: 15)
        pwdTextField.textAlignment = .left
        pwdTextField.keyboardType = .asciiCapable
        pwdTextField.isSecureTextEntry = true
        pwdTextField.addTarget(self, action: #selector(self.textFieldEditingChangedAction(textField:)), for: UIControlEvents.editingChanged)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 40))
        pwdTextField.leftView = leftView
        pwdTextField.leftViewMode = .always
        
        rePwdTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_repwd_textfield_placeholder_key)
        rePwdTextField.delegate = self
        rePwdTextField.borderStyle = .none
        rePwdTextField.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        rePwdTextField.font = UIFont.systemFont(ofSize: 15)
        rePwdTextField.textAlignment = .left
        rePwdTextField.keyboardType = .asciiCapable
        rePwdTextField.isSecureTextEntry = true

        let leftView2 = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 40))
        rePwdTextField.leftView = leftView2
        rePwdTextField.leftViewMode = .always
        
        pwdTextField.layer.cornerRadius = 2
        pwdTextField.layer.masksToBounds = true
        rePwdTextField.layer.cornerRadius = 2
        rePwdTextField.layer.masksToBounds = true
        
        alertBtn1.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_alert1_title_key), for: UIControlState.normal)
        alertBtn2.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_alert2_title_key), for: UIControlState.normal)
        alertBtn3.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_alert3_title_key), for: UIControlState.normal)
        alertBtn4.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_alert4_title_key), for: UIControlState.normal)
        
        let image = UIImage(color: UIColorFromRGB(hexRGB: 0xAA0202), withFrame: CGRect(x: 0, y: 0, width: 8, height: 8))
        if let image_ = image!.imageCompress(to: CGSize(width: 8, height: 8), corners: UIRectCorner.allCorners, cornerRadius: 4) {
            alertBtn1.setImage(image_, for: UIControlState.normal)
            alertBtn2.setImage(image_, for: UIControlState.normal)
            alertBtn3.setImage(image_, for: UIControlState.normal)
            alertBtn4.setImage(image_, for: UIControlState.normal)
        }
        alertBtn1.titleRightAndImageLeftSetting(withSpace: 4)
        alertBtn2.titleRightAndImageLeftSetting(withSpace: 4)
        alertBtn3.titleRightAndImageLeftSetting(withSpace: 4)
        alertBtn4.titleRightAndImageLeftSetting(withSpace: 4)
        
        createBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: CreateWalletPage_create_btn_title_key), for: UIControlState.normal)
        createBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x33c6b3)
        createBtn.layer.masksToBounds = true
        createBtn.layer.cornerRadius = createBtn.height() / 2
        createBtn.addTarget(self, action: #selector(self.createBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: - Action
    @objc func selectAgreeBtnAction(btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
    }
    
    @objc func createBtnAction() {
        
        if self.createBtnTapClosure != nil {
            self.createBtnTapClosure!()
        }
    }
    
    // 输入发生变化
    @objc func textFieldEditingChangedAction(textField: UITextField) {
        
        if textField == pwdTextField {
            if let pwd = textField.text {
                numberLabel.text = "\(pwd.count)"
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
    
}
