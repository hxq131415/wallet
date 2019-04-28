//
//  PlanJoinContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/11.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

@objc protocol PlanPlanUnfreeAccountContentViewDelegate: NSObjectProtocol {
    
    // 金额输入发生变化
    @objc func amoutInputChanged(text: String?)
}

class PlanUnfreeAccountContentView: UIView, UITextFieldDelegate {

    lazy var amountLeftLbl: UILabel = UILabel(frame: CGRect.zero)
    
    var amountTextField: UITextField = {
        let amountTextField_ = UITextField(frame: CGRect.zero)
        return amountTextField_
    }()
    
    var constTextField: UITextField = {
        let constTextField_ = UITextField(frame: CGRect.zero)
        return constTextField_
    }()
    
    lazy var balanceLbl: UILabel = UILabel(frame: CGRect.zero)
    
    var minerView: MRMinerFeeView = {
        let minerVw = MRMinerFeeView(frame: CGRect.zero)
        return minerVw
    }()
    
    lazy var passwordLbl: UILabel = UILabel(frame: CGRect.zero)
    
    var joinBtn: UIButton = {
        let joinBtn_ = UIButton(type: UIButtonType.custom)
        return joinBtn_
    }()
    
    lazy var bottomLbl: UILabel = UILabel(frame: CGRect.zero)
    
    
    weak var delegate: PlanPlanUnfreeAccountContentViewDelegate?
    
    var joinBtnTapClosure:(() -> ())?
    var bottomLblTapClosure:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //先边框
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor(red: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.5).cgColor
        
        //中阴影
        self.layer.shadowColor = UIColor(red: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.5).cgColor
        self.layer.shadowOpacity = 1//不透明度
        self.layer.shadowRadius = 2//设置阴影所照射的范围
        self.layer.shadowOffset = CGSize(width: 0, height: 0)// 设置阴影的偏
        //后设置圆角
        self.layer.cornerRadius = 4
    }
    
    func subViewInitialization() {
        
        self.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        let constLeftLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        constLeftLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_consume_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        self.addSubview(constLeftLbl)
        constLeftLbl.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalToSuperview().offset(40)
        }
        
        let balanceText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_balance_text_key) + "0.00"
        balanceLbl.configLabel(text: balanceText, textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 13))
        self.addSubview(balanceLbl)
        balanceLbl.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalToSuperview().offset(40)
        }
        
        self.addSubview(constTextField)
        constTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(constLeftLbl.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        constTextField.font = UIFont.systemFont(ofSize: 18)
        constTextField.textColor = MRColorManager.DarkBlackTextColor
        constTextField.textAlignment = .left
        constTextField.text = "100"
        constTextField.isEnabled = false
        
        
        
        let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
        constRightLbl.configLabel(text: "Mcoin", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
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
        
        self.addSubview(minerView)
        minerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(sepertorLineVw2.snp.bottom).offset(10)
            make.height.equalTo(70)
        }
   
        self.addSubview(joinBtn)
        joinBtn.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.right.equalTo(-28)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.minerView.snp.bottom).offset(24 * theScaleToiPhone_6)
        }
        
        joinBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_bottom_btn_unfreeze_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x33c6b3))
        joinBtn.layer.masksToBounds = true
        joinBtn.layer.cornerRadius = 48 / 2
        
        joinBtn.addTarget(self, action: #selector(self.joinBtnAction), for: UIControlEvents.touchUpInside)
        
        self.addSubview(bottomLbl)
        bottomLbl.snp.makeConstraints { (make) in
            make.left.equalTo(28)
            make.right.equalTo(-28)
            make.top.equalTo(joinBtn.snp.bottom).offset(20 * theScaleToiPhone_6)
        }
        
        bottomLbl.textColor = UIColorFromRGB(hexRGB: 0x16a2ac)
        bottomLbl.font = UIFont.systemFont(ofSize: 10)
        
        let title = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_contentView_bottom_text_key)
        let attributeString = NSMutableAttributedString(string: title)
        attributeString.addAttribute(NSAttributedStringKey.underlineStyle, value: 1, range: NSRange(location: 0, length: title.count))
        attributeString.addAttribute(NSAttributedStringKey.underlineColor, value: UIColorFromRGB(hexRGB: 0x16a2ac), range: NSRange(location: 0, length: title.count))
        bottomLbl.attributedText = attributeString
#if DEBUG
        bottomLbl.alpha = 1.0
#else
        bottomLbl.alpha = 0
#endif
        
        
        bottomLbl.isUserInteractionEnabled = true
        bottomLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.bottomLblAction(tap:))))
        
    }
    
    // MARK: - Action
    @objc func joinBtnAction() {
        self.endEditing(true)
    
        if joinBtnTapClosure != nil {
            joinBtnTapClosure!()
        }
    }
    
    @objc func bottomLblAction(tap: UITapGestureRecognizer) {
        self.endEditing(true)
        
        if bottomLblTapClosure != nil {
            bottomLblTapClosure!()
        }
    }
    
    @objc func textFieldInputChanged(textField: UITextField) {
        
//        if let amout = textField.text?.toDouble() {
//            // 计算消耗的MCOIN
//            if let entryFee = MRCommonShared.shared.config?.entryFee {
//                var costAmount = amout * entryFee / 100.0
//
//                if costAmount < 1 {
//                    costAmount = 1.0
//                }
//
//                let decimal = NSDecimalNumber.roundingDoubleValueWithScale(scale: 0, doubleValue: costAmount)
//
//                constTextField.text = String(format: "%d", Int(decimal))
//            }
//            else {
//                constTextField.text = String(format: "%d", 0)
//            }
//        }
//        else {
//            constTextField.text = String(format: "%d", 0)
//        }
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(PlanJoinContentViewDelegate.amoutInputChanged(text:))) {
            //self.delegate!.amoutInputChanged(text: textField.text)
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}
