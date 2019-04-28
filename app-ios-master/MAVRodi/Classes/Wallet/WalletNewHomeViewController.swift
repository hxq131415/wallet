//
//  WalletNewHomeViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/20.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  创建，导入 钱包页面

import UIKit

class WalletNewHomeViewController: MRBaseViewController {

    private var headImageView: UIImageView = {
        let imgVw = UIImageView(frame: CGRect.zero)
        return imgVw
    }()
    
    private var createBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    private var importBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    private var bottomLbl: UILabel = {
        let textLbl = UILabel(frame: CGRect.zero)
        return textLbl
    }()
    
    private var multiLbl: UILabel = {
        let textLbl = UILabel(frame: CGRect.zero)
        return textLbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.subViewInitialization()
    }

    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initialization
    func subViewInitialization() {
        
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xf6fafb)
        
        headImageView.contentMode = .scaleAspectFit
        self.view.addSubview(headImageView)
        headImageView.snp.makeConstraints { (make) in
            make.top.equalTo(80 * theScaleToiPhone_6)
            make.left.right.equalToSuperview()
        }
        
        headImageView.image = UIImage(named: "icon_wallet_new_header_img")
        
        self.view.addSubview(multiLbl)
        multiLbl.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView.snp.bottom).offset(28 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
        }
        
        multiLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: NewWalletHomePage_multi_lbl_text_key), numberOfLines: 0, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x111111), font: UIFont.systemFont(ofSize: 24))
        
        self.view.addSubview(bottomLbl)
        bottomLbl.snp.makeConstraints { (make) in
            make.top.equalTo(multiLbl.snp.bottom).offset(12 * theScaleToiPhone_6)
            make.width.equalTo(270 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
        }
        
        bottomLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: NewWalletHomePage_bottom_lbl_text_key), numberOfLines: 2, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0xaaaaaa), font: UIFont.systemFont(ofSize: 14))
        

        self.view.addSubview(createBtn)
        createBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLbl.snp.bottom).offset(40 * theScaleToiPhone_6)
            make.width.equalTo(300 * theScaleToiPhone_6)
            make.height.equalTo(48 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
        }
        
        createBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: NewWalletHomePage_create_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 16), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x2FBBA8))
        
        createBtn.layer.masksToBounds = true
        createBtn.layer.cornerRadius = 48 * theScaleToiPhone_6 / 2
        
        createBtn.addTarget(self, action: #selector(self.createWalletAction), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(importBtn)
        importBtn.snp.makeConstraints { (make) in
            make.width.equalTo(createBtn)
            make.height.equalTo(createBtn)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.createBtn.snp.bottom).offset(13)
        }
        
        importBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: NewWalletHomePage_export_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 16), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0xeda231))
        importBtn.layer.masksToBounds = true
        importBtn.layer.cornerRadius = 48 * theScaleToiPhone_6 / 2
        
        importBtn.addTarget(self, action: #selector(self.importWalletAction), for: UIControlEvents.touchUpInside)
        
        
        
    }
    
    // MARK: - Action
    @objc func createWalletAction() {
    
        let show = UserDefaults.standard.bool(forKey: isShowWalletServiceAlert())
        if show {
            
            let createWalletCtrl = CreateWalletViewController()
            self.navigationController?.pushViewController(createWalletCtrl, animated: true)
        }else {
            WalletServiceAgreementView.showWalletServiceAgreementView(superV: self.view) {
                
                saveUserDefaultsWithValue(value: true, key: isShowWalletServiceAlert())
                
                let createWalletCtrl = CreateWalletViewController()
                self.navigationController?.pushViewController(createWalletCtrl, animated: true)
            }
        }
        
    }
    
    @objc func importWalletAction() {
        
        let importWalletCtrl = ImportWalletViewController()
        importWalletCtrl.type = .mcoin_privateKey
        self.navigationController?.pushViewController(importWalletCtrl, animated: true)
    }
    
    // 语言切换
    override func appLanguageChanged(notifi: Notification) {
        
        createBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: NewWalletHomePage_create_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x2FBBA8))
        
        importBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: NewWalletHomePage_export_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0xeda231))
        
        multiLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: NewWalletHomePage_multi_lbl_text_key), numberOfLines: 0, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x111111), font: UIFont.systemFont(ofSize: 24))
        
        bottomLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: NewWalletHomePage_bottom_lbl_text_key), numberOfLines: 0, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 10))
    }
    
}
