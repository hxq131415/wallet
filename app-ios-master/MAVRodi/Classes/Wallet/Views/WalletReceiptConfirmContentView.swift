//
//  WalletReceiptConfirmContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/12.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  收获确认

import UIKit

@objc protocol WalletReceiptConfirmContentViewDelegate: NSObjectProtocol {
    
    // 金额输入发生变化
    @objc func amoutInputChanged(text: String?)
}

class WalletReceiptConfirmContentView: UIView, UITextFieldDelegate {
    
    lazy var amountLeftLbl: UILabel = UILabel(frame: CGRect.zero)
    
    var amountTextField: UITextField = {
        let amountTextField_ = UITextField(frame: CGRect.zero)
        return amountTextField_
    }()
    
    var constTextField: UITextField = {
        let constTextField_ = UITextField(frame: CGRect.zero)
        return constTextField_
    }()
    
    var joinBtn: UIButton = {
        let joinBtn_ = UIButton(type: UIButtonType.custom)
        return joinBtn_
    }()
    
    
    
    weak var delegate: WalletReceiptConfirmContentViewDelegate?
    
    var confirmBtnTapClosure:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        // 扩散1pt
        let shadowSize0:CGFloat = 1
        let shadowSpreadRect0 = CGRect(x: -shadowSize0, y: -shadowSize0, width: self.bounds.size.width+shadowSize0*2, height: self.bounds.size.height+shadowSize0*2)
        let shadowSpreadRadius0 = self.layer.cornerRadius + shadowSize0;
        let shadowPath0 = UIBezierPath(roundedRect: shadowSpreadRect0, cornerRadius: shadowSpreadRadius0)

        self.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x7e7e7e).withAlphaComponent(0.29), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 4, shadowOpacity: 1.0, shadowPath: shadowPath0.cgPath)
    }
    
    func subViewInitialization() {
        
        self.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        amountLeftLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        amountLeftLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptConfirmPage_left_amount_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        self.addSubview(amountLeftLbl)
        amountLeftLbl.snp.makeConstraints { (make) in
            make.left.equalTo(26)
            make.top.equalTo(40 * theScaleToiPhone_6)
        }
        
        amountTextField.textAlignment = .center
        amountTextField.isEnabled = false
        self.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalTo(amountLeftLbl.snp.bottom).offset(35 * theScaleToiPhone_6)
            make.height.equalTo(40)
        }
        
        amountTextField.setPlaceholderTextColor(textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), textFont: UIFont.systemFont(ofSize: 15), textAlignment: .center)
        amountTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptConfirmPage_amount_textfield_placehorder_text_key)
        amountTextField.font = UIFont.systemFont(ofSize: 15)
        amountTextField.keyboardType = UIKeyboardType.decimalPad
        amountTextField.returnKeyType = .done
        amountTextField.delegate = self
        
        let amountRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 35))
        amountRightLbl.configLabel(text: "ETC", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 13))
        amountRightLbl.sizeToFit()
        amountTextField.rightView = amountRightLbl
        amountTextField.rightViewMode = .always
        
        amountTextField.addTarget(self, action: #selector(self.textFieldInputChanged(textField:)), for: UIControlEvents.editingChanged)
        
        let sepertorLineVw1 = UIView(frame: CGRect.zero)
        self.addSubview(sepertorLineVw1)
        sepertorLineVw1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.amountTextField)
            make.top.equalTo(self.amountTextField.snp.bottom).offset(12 * theScaleToiPhone_6)
            make.height.equalTo(1)
        }
        
        sepertorLineVw1.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
        
        let constLeftLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        constLeftLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptConfirmPage_left_fee_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        self.addSubview(constLeftLbl)
        constLeftLbl.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(sepertorLineVw1.snp.bottom).offset(30 * theScaleToiPhone_6)
        }
 
        self.addSubview(constTextField)
        constTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-26)
            make.top.equalTo(constLeftLbl.snp.bottom).offset(10 * theScaleToiPhone_6)
            make.height.equalTo(40)
        }
        
        constTextField.font = UIFont.systemFont(ofSize: 15)
        constTextField.textColor = MRColorManager.DarkBlackTextColor
        constTextField.textAlignment = .center
//        constTextField.text = "0"
        constTextField.isEnabled = false
        
        
        
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

        self.addSubview(joinBtn)
        joinBtn.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.right.equalTo(-28)
            make.height.equalTo(48)
            make.bottom.equalTo(-59 * theScaleToiPhone_6)
        }
        
        joinBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptConfirmPage_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 16), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x33c6b3))
        joinBtn.layer.masksToBounds = true
        joinBtn.layer.cornerRadius = 48 / 2
        
        joinBtn.addTarget(self, action: #selector(self.joinBtnAction), for: UIControlEvents.touchUpInside)

    }
    
    // MARK: - Action
    @objc func joinBtnAction() {
        self.endEditing(true)
        
        if confirmBtnTapClosure != nil {
            confirmBtnTapClosure!()
        }
        
    }

    @objc func textFieldInputChanged(textField: UITextField) {
        
        if let amout = textField.text?.toDouble() {
            // 计算消耗的MCOIN
            if let entryFee = MRCommonShared.shared.config?.entryFee {
                var costAmount = amout * entryFee / 100.0
                
                if costAmount < 1 {
                    costAmount = 1.0
                }
                
                let decimal = NSDecimalNumber.roundingDoubleValueWithScale(scale: 0, doubleValue: costAmount)
                
                constTextField.text = String(format: "%d", Int(decimal))
            }
            else {
                constTextField.text = String(format: "%d", 0)
            }
        }
        else {
            constTextField.text = String(format: "%d", 0)
        }
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(PlanJoinContentViewDelegate.amoutInputChanged(text:))) {
            self.delegate!.amoutInputChanged(text: textField.text)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}

//class WalletReceiptConfirmContentView: UIView {
//
//    lazy var contentView: UIView = UIView(frame: CGRect.zero)
//
//    var titleLbl1: UILabel = {
//        let textLbl = UILabel(frame: CGRect.zero)
//        return textLbl
//    }()
//
//    var constTextField: UITextField = {
//        let constTextField_ = UITextField(frame: CGRect.zero)
//        return constTextField_
//    }()
//
//    var totalAmoutLbl: UILabel = {
//        return UILabel(frame: CGRect.zero)
//    }()
//
//    var tradingFeeLbl: UILabel = {
//        return UILabel(frame: CGRect.zero)
//    }()
//
//    var bottomLbl: UILabel = {
//        let textLbl = UILabel(frame: CGRect.zero)
//        return textLbl
//    }()
//
//    var confirmBtn: UIButton = {
//        let btn = UIButton(type: UIButtonType.custom)
//        return btn
//    }()
//
//    var confirmBtnTapClosure: (() -> ())?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.subViewInitialization()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    func subViewInitialization() {
//
//        self.backgroundColor = UIColor.clear
//
//        self.addSubview(contentView)
//        contentView.snp.makeConstraints { (make) in
//            make.left.right.top.bottom.equalToSuperview()
//        }
//
//        contentView.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
//        contentView.cornerRadius = 8
//
//        contentView.addSubview(titleLbl1)
//        titleLbl1.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.top.equalToSuperview().offset(35)
//            make.height.equalTo(40)
//        }
//
//        titleLbl1.configLabel(text: "转出金额", numberOfLines: 1, textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
//
//        contentView.addSubview(constTextField)
//        constTextField.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.top.equalTo(self.titleLbl1.snp.bottom).offset(10)
//            make.height.equalTo(40)
//        }
//
//        if Main_Screen_Width < 375 {
//            constTextField.font = UIFont.systemFont(ofSize: 25)
//        }
//        else {
//            constTextField.font = UIFont.systemFont(ofSize: 30)
//        }
//
//        constTextField.textColor = MRColorManager.DarkBlackTextColor
//        constTextField.textAlignment = .center
//        constTextField.isEnabled = false
//
//        let separtorLineVw1 = UIView(frame: CGRect.zero)
//        separtorLineVw1.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
//        contentView.addSubview(separtorLineVw1)
//        separtorLineVw1.snp.makeConstraints { (make) in
//            make.left.right.equalTo(self.constTextField)
//            make.height.equalTo(1)
//            make.top.equalTo(self.constTextField.snp.bottom).offset(10)
//        }
//
//        contentView.addSubview(totalAmoutLbl)
//        totalAmoutLbl.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.top.equalTo(separtorLineVw1.snp.bottom).offset(24)
//            make.height.greaterThanOrEqualTo(10)
//        }
//
//        totalAmoutLbl.configLabel(text: "总金额      123.123456ETC", numberOfLines: 1, textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
//
//        contentView.addSubview(tradingFeeLbl)
//        tradingFeeLbl.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.top.equalTo(self.totalAmoutLbl.snp.bottom).offset(20)
//            make.height.greaterThanOrEqualTo(10)
//        }
//
//        tradingFeeLbl.configLabel(text: "交易费      0.123456ETC", numberOfLines: 1, textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
//
//        let separtorLineVw2 = UIView(frame: CGRect.zero)
//        separtorLineVw2.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
//        contentView.addSubview(separtorLineVw2)
//        separtorLineVw2.snp.makeConstraints { (make) in
//            make.left.right.equalTo(self.constTextField)
//            make.height.equalTo(1)
//            make.top.equalTo(self.tradingFeeLbl.snp.bottom).offset(24)
//        }
//
//        contentView.addSubview(bottomLbl)
//        bottomLbl.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.top.equalTo(separtorLineVw2.snp.bottom).offset(20)
//            make.height.greaterThanOrEqualTo(10)
//        }
//
//        bottomLbl.configLabel(text: nil, numberOfLines: 0, textAlignment: NSTextAlignment.left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 10))
//
//        contentView.addSubview(confirmBtn)
//        confirmBtn.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(20)
//            make.right.equalToSuperview().offset(-20)
//            make.top.equalTo(self.bottomLbl.snp.bottom).offset(30)
//            make.height.equalTo(50)
//        }
//
//        confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptConfirm_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x365ad8))
//        confirmBtn.layer.masksToBounds = true
//        confirmBtn.layer.cornerRadius = 8
//        confirmBtn.addTarget(self, action: #selector(self.confirmBtnAction), for: UIControlEvents.touchUpInside)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // 扩散1pt
//        let shadowSize0:CGFloat = 1
//        let shadowSpreadRect0 = CGRect(x: -shadowSize0, y: -shadowSize0, width: self.bounds.size.width+shadowSize0*2, height: self.bounds.size.height+shadowSize0*2)
//        let shadowSpreadRadius0 = contentView.layer.cornerRadius + shadowSize0;
//        let shadowPath0 = UIBezierPath(roundedRect: shadowSpreadRect0, cornerRadius: shadowSpreadRadius0)
//
//        self.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x7e7e7e).withAlphaComponent(0.29), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 4, shadowOpacity: 1.0, shadowPath: shadowPath0.cgPath)
//    }
//
//    @objc func confirmBtnAction() {
//
//        if self.confirmBtnTapClosure != nil {
//            self.confirmBtnTapClosure!()
//        }
//    }
//
//}
