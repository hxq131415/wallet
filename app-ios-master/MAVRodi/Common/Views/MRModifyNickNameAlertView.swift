//
//  MRModifyNickNameAlertView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/5.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MRModifyNickNameAlertView: UIView {
    
    lazy var cancelBtn: UIButton = UIButton(type: UIButtonType.custom)
    lazy var determineBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    lazy var userNameTextField: UITextField = UITextField(frame: CGRect.zero)
//    lazy var quoteTextField: UITextField = UITextField(frame: CGRect.zero)
    
    var cancelBtnTapClosure: (() -> ())?
    var determineBtnTapClosure: ((_ userName: String?, _ quoteText: String?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitlzation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subViewInitlzation() {
        
        self.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        let enterUserNameLbl = UILabel(frame: CGRect.zero)
        self.addSubview(enterUserNameLbl)
        enterUserNameLbl.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(10)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        enterUserNameLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: ModifyUserName_username_top_title_label_key), numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0xbabcc6), font: UIFont.systemFont(ofSize: 16))
        
        self.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(180 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
            make.top.equalTo(enterUserNameLbl.snp.bottom).offset(10)
            make.height.equalTo(45)
        }
        
        let paraphStyle = NSMutableParagraphStyle()
        paraphStyle.alignment = .center
        let userNamePlaceholderAttText = NSMutableAttributedString(string: MRLocalizableStringManager.localizableStringFromTableHandle(key: ModifyUserName_username_textfield_placeholder_key), attributes: [NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0xbabcc6), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.paragraphStyle: paraphStyle])
        userNameTextField.attributedPlaceholder = userNamePlaceholderAttText
        userNameTextField.textAlignment = .center
        userNameTextField.font = UIFont.systemFont(ofSize: 18)
        userNameTextField.keyboardType = UIKeyboardType.default
        userNameTextField.returnKeyType = .done
        
        let sepertorLineVw1 = UIView(frame: CGRect.zero)
        self.addSubview(sepertorLineVw1)
        sepertorLineVw1.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(userNameTextField.snp.bottom).offset(0)
        }

        sepertorLineVw1.backgroundColor = UIColorFromRGB(hexRGB: 0xe9eaeb)
//
//        self.addSubview(quoteTextField)
//        quoteTextField.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.width.equalTo(220 * theScaleToiPhone_6)
//            make.top.equalTo(sepertorLineVw1.snp.bottom).offset(10)
//            make.height.equalTo(45)
//        }
//
//        let paraphStyle1 = NSMutableParagraphStyle()
//        paraphStyle1.alignment = .center
//        let quotesPlaceholderAttText = NSMutableAttributedString(string: MRLocalizableStringManager.localizableStringFromTableHandle(key: ModifyUserName_quote_textfield_placeholder_key), attributes: [NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0xbabcc6), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.paragraphStyle: paraphStyle1])
//        quoteTextField.attributedPlaceholder = quotesPlaceholderAttText
//        quoteTextField.font = UIFont.systemFont(ofSize: 16)
//        quoteTextField.keyboardType = UIKeyboardType.default
//        quoteTextField.returnKeyType = .done
        
//        let sepertorLineVw2 = UIView(frame: CGRect.zero)
//        self.addSubview(sepertorLineVw2)
//        sepertorLineVw2.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(1)
//            make.top.equalTo(self.quoteTextField.snp.bottom).offset(10)
//        }
        
//        sepertorLineVw2.backgroundColor = UIColorFromRGB(hexRGB: 0xe9eaeb)
        self.addSubview(determineBtn)
        determineBtn.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.top.equalTo(sepertorLineVw1.snp.bottom).offset(15)
            
            //            make.bottom.equalToSuperview()
            //            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        determineBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x2ABBB0))
        determineBtn.layer.cornerRadius = 25
        
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(50)
            make.top.equalTo(self.determineBtn.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        //        cancelBtn.layer.cornerRadius = 25
        
        cancelBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_cancel_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0x2ABBB0), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: nil)
        
        
//        self.addSubview(cancelBtn)
//        cancelBtn.snp.makeConstraints { (make) in
//            make.width.equalTo(100)
//            make.height.equalTo(40)
//            make.bottom.equalToSuperview()
//            make.left.equalToSuperview()
//        }
//
//        cancelBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_cancel_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xbabcc6), font: UIFont.systemFont(ofSize: 15), normalImage: nil, selectedImage: nil, backgroundColor: nil)
//
//        self.addSubview(determineBtn)
//        determineBtn.snp.makeConstraints { (make) in
//            make.width.equalTo(100)
//            make.height.equalTo(40)
//            make.bottom.equalToSuperview()
//            make.right.equalToSuperview()
//        }
//
//        determineBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0x424458), font: UIFont.systemFont(ofSize: 15), normalImage: nil, selectedImage: nil, backgroundColor: nil)
        
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnAction), for: UIControlEvents.touchUpInside)
        determineBtn.addTarget(self, action: #selector(self.determineBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Action
    @objc func cancelBtnAction() {
        
        if self.cancelBtnTapClosure != nil {
            self.cancelBtnTapClosure!()
        }
    }
    
    @objc func determineBtnAction() {
        
        if self.determineBtnTapClosure != nil {
            self.determineBtnTapClosure!(userNameTextField.text, "")
        }
    }
    
    
}
