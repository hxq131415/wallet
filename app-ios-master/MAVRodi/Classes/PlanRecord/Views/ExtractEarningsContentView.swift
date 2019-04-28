//
//  ExtractEarningsContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/26.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class ExtractEarningsContentView: UIView, UITextFieldDelegate {
    
    var amountTextField: UITextField = {
        let amountTextField_ = UITextField(frame: CGRect.zero)
        return amountTextField_
    }()
    
    var constTextField: UITextField = {
        let constTextField_ = UITextField(frame: CGRect.zero)
        return constTextField_
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField(frame: CGRect.zero)
        return textField
    }()
    
    lazy var passwordLbl: UILabel = UILabel(frame: CGRect.zero)
    
    var amountInputFinishClosure: ((_ amount: String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subViewInitialization() {
        
        self.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        self.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(40)
        }
        
        amountTextField.setPlaceholderTextColor(textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), textFont: UIFont.systemFont(ofSize: 18), textAlignment: .left)
        amountTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExtractionEanringsPage_amount_textfield_placeholder_key)
        amountTextField.font = UIFont.systemFont(ofSize: 18)
        amountTextField.keyboardType = UIKeyboardType.decimalPad
        amountTextField.returnKeyType = .done
        amountTextField.delegate = self
        
        let amountLeftLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        amountLeftLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_amount_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        
        amountTextField.leftView = amountLeftLbl
        amountTextField.leftViewMode = .always
        
        let amountRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 35))
        amountRightLbl.configLabel(text: "ETC", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
        amountRightLbl.sizeToFit()
        amountTextField.rightView = amountRightLbl
        amountTextField.rightViewMode = .always
        
        let sepertorLineVw1 = UIView(frame: CGRect.zero)
        self.addSubview(sepertorLineVw1)
        sepertorLineVw1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.amountTextField)
            make.top.equalTo(self.amountTextField.snp.bottom).offset(15)
            make.height.equalTo(1)
        }
        
        sepertorLineVw1.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
        
        self.addSubview(constTextField)
        constTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(sepertorLineVw1.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        constTextField.font = UIFont.systemFont(ofSize: 18)
        constTextField.textColor = MRColorManager.DarkBlackTextColor
        constTextField.textAlignment = .left
        constTextField.text = "0"
        constTextField.isEnabled = false
        
        let constLeftLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        constLeftLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferConfirm_minesfee_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        constTextField.leftView = constLeftLbl
        constTextField.leftViewMode = .always
        
        let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
        constRightLbl.configLabel(text: "MCOIN", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
        constRightLbl.sizeToFit()
        constTextField.rightView = constRightLbl
        constTextField.rightViewMode = .always
        
        let sepertorLineVw2 = UIView(frame: CGRect.zero)
        self.addSubview(sepertorLineVw2)
        sepertorLineVw2.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.constTextField)
            make.top.equalTo(self.constTextField.snp.bottom).offset(15)
            make.height.equalTo(1)
        }
        
        sepertorLineVw2.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
        
        self.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(sepertorLineVw2.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        passwordTextField.font = UIFont.systemFont(ofSize: 13)
        passwordTextField.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.returnKeyType = .done
        passwordTextField.textAlignment = .center
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.isSecureTextEntry = true
        
        let paraphStyle = NSMutableParagraphStyle()
        paraphStyle.alignment = .center
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_enter_wallet_password_placeholder), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e), NSAttributedStringKey.paragraphStyle: paraphStyle])
        
        let sepertorLineVw3 = UIView(frame: CGRect.zero)
        self.addSubview(sepertorLineVw3)
        sepertorLineVw3.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.passwordTextField)
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(15)
            make.height.equalTo(1)
        }
        
        sepertorLineVw3.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
        
        self.addSubview(passwordLbl)
        passwordLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.passwordTextField)
            make.right.equalTo(self.passwordTextField)
            make.height.greaterThanOrEqualTo(10)
            make.top.equalTo(sepertorLineVw3.snp.bottom).offset(20)
        }
        
        passwordLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: ExtractionEanringsPage_content_bottom_textlbl_text_key), textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 10))
        passwordLbl.numberOfLines = 0
        
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == amountTextField {
            if self.amountInputFinishClosure != nil {
                if let text = amountTextField.text {
                    self.amountInputFinishClosure!(text)
                }
            }
        }
    }

}
