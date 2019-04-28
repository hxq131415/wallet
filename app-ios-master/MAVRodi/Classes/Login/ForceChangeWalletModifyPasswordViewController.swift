//
//  WalletModifyPasswordViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/7.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  修改密码

import UIKit

class ForceChangeWalletModifyPasswordViewController: MRBaseViewController {
    
    private lazy var mainTableView: UITableView =
        UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    private var contentView: WalletModifyPwdTableContentView!
    var loginModel: LoginInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.customNavigationBarBackgroundImageWithoutBottomLine()
        
        self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_navigation_title_key)
        
        self.initalizationSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isNavigationBarToHidden() {
            self.customLeftBackItemButtonWithImageName("icon_back_black")
            self.customNavigationTitleAttributes()
            self.customNavigationBarBackgroundImageWithoutBottomLine()
        }
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return false
    }
    
    //    override var preferredStatusBarStyle: UIStatusBarStyle {
    //        return .lightContent
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Overrides
    override func customNavigationTitleAttributes() {
        
        let paragphStyle = NSMutableParagraphStyle()
        paragphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.foregroundColor : UIColorFromRGB(hexRGB: 0x333333), NSAttributedStringKey.font : TE_NavigationTitle_Font, NSAttributedStringKey.paragraphStyle: paragphStyle]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    override func customNavigationBarBackgroundImageWithoutBottomLine() {
        
        let navBgImg = UIImage(color: MRColorManager.LightGrayBackgroundColor)
        self.navigationController?.navigationBar.setBackgroundImage(navBgImg, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Initialization
    func initalizationSubView() {
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.backgroundColor = UIColorFromRGB(hexRGB: 0xe0e1e2)
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    }
    
    // MARK: - Request
    func requestForModifyPassword() {
        
        guard let curPassword = contentView.curPwdTextField.text , !curPassword.isEmpty() else {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_current_pwd_empty_prompt_key))
            return
        }
        
        guard let password = contentView.pwdTextField.text , !password.isEmpty() else {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_new_pwd_empty_prompt_key))
            return
        }
        
        if !MRVerifyTools.verifyContainsNumberLetterAndSpecialChars(password) {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_pwd_lessthan_empty_prompt_key))
            return
        }
        
        if password.count < 8 {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_pwd_lessthan_empty_prompt_key))
            return
        }
        
        guard let rePwd = contentView.rePwdTextField.text , !rePwd.isEmpty() else {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_re_pwd_empty_prompt_key))
            return
        }
        
        if rePwd.count < 8 {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_pwd_lessthan_empty_prompt_key))
            return
        }
        
        if password != rePwd {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletModifyPasswordPage_pwd_differ_empty_prompt_key))
            return
        }
        
        var params: [String: Any] = [:]
        params["oldPassword"] = curPassword
        params["password"] = password
        params["confirmPassword"] = rePwd
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_WALLET_MODIFY_PASSWORD, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let msg = message , !msg.isEmpty() {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("密码修改成功")
                    }
                    if let model = self!.loginModel {
                        // 保存登录信息
                        saveUserDefaultsWithValue(value: model.token, key: UDKEY_LOGIN_TOKEN)
                        saveUserDefaultsWithValue(value: model.refresh_token, key: UDKEY_LOGIN_REFRESH_TOKEN)
                        saveUserDefaultsWithValue(value: model.toJSON(), key: UDKEY_USER_LOGIN_DATA)
                        // 记录上一次登录账号
                        saveUserDefaultsWithValue(value: model.userInfo?.account, key: UDKEY_LOGIN_USER_EMAIL)
                    }
                    
                    // 请求个人信息，判断是否已经创建钱包了
                    MRTools.requestForGetUserData(completeBlock: {
                        if let userInfo = MRCommonShared.shared.userInfo {
                            if userInfo.is_bind_wallet == 1 {
                                (UIApplication.shared.delegate as? MRAppDelegate)?.setupWalletTabBarController()
                            }
                            else {
                                (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                            }
                        }
                        else {
                            (UIApplication.shared.delegate as? MRAppDelegate)?.setupNewWalletTabBarController()
                        }
                        
                        weakSelf.navigationController?.dismiss(animated: true, completion: nil)
                    })
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty() {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage("密码修改失败")
                    }
                }
            }
        }
    }
    
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension ForceChangeWalletModifyPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = Bundle.main.loadNibNamed("WalletModifyPwdTableContentView", owner: nil, options: nil)?.first as? WalletModifyPwdTableContentView {
            
            headerView.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: Main_Screen_Height)
            contentView = headerView
            
            headerView.createBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    weakSelf.requestForModifyPassword()
                }
            }
            
            headerView.resetPwdBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    let importWalletCtrl = ImportWalletViewController()
                    importWalletCtrl.type = .resetPwd
                    weakSelf.navigationController?.pushViewController(importWalletCtrl, animated: true)
                }
            }
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return Main_Screen_Height
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
