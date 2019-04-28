//
//  ImportWalletViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  导入MCOIN私钥

import UIKit

enum ImportWalletType {
    case mcoin_privateKey // 导入钱包
    case resetPwd // 重置密码
}

class ImportWalletViewController: MRBaseViewController {

    private lazy var mainTableView: UITableView =
        UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    private var contentView: ImportPrivateKeyContentView!
    var type: ImportWalletType = .mcoin_privateKey
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.customNavigationBarBackgroundImageWithoutBottomLine()
        
        if type == .mcoin_privateKey {
            self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_navigation_title_key)
        }
        else {
            self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: ResetWalletPasswordPage_navigation_title_key)
        }
        
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
//        return UIStatusBarStyle.lightContent
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
    // 导入钱包
    func requestForExportWallet() {
        
        guard let ethPrivateKey = contentView.ethPrivateKeyTextView.text , !ethPrivateKey.isEmpty() else {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_eth_privatekey_empty_prompt_key))
            return
        }
        
        guard let etcPrivateKey = contentView.etcPrivateKeyTextView.text , !etcPrivateKey.isEmpty() else {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_etc_privatekey_empty_prompt_key))
            return
        }
        
        guard let password = contentView.setPwdTextField.text , !password.isEmpty() else {
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
        
        guard let rePwd = contentView.resetPwdTextField.text , !rePwd.isEmpty() else {
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
        params["ethPrivateKey"] = ethPrivateKey
        params["etcPrivateKey"] = etcPrivateKey
        params["password"] = password
        params["confirmPassword"] = rePwd
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_WALLET_IMPORT_BY_PRIVATEKEY, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    
                    if let msg = message , !msg.isEmpty() {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("钱包导入成功")
                    }
                    
                    // 更新会员信息，钱包绑定成功
                    let userInfo_ = MRCommonShared.shared.userInfo
                    userInfo_?.is_bind_wallet = 1
                    MRCommonShared.shared.userInfo = userInfo_
                    
                    (UIApplication.shared.delegate as? MRAppDelegate)?.refreshTabbarController()
                    
                    dispatch_after_in_main(1, block: {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NNKEY_NEED_TO_UPDATE_USERDATA_NOTIFICATION), object: nil)
                        MRTools.requestForGetUserData(completeBlock: {
                            
                        })
                    })
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty() {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage("钱包导入失败")
                    }
                }
            }
        }
    }
    
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension ImportWalletViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if let headerView = Bundle.main.loadNibNamed("ImportPrivateKeyContentView", owner: nil, options: nil)?.first as? ImportPrivateKeyContentView {
            headerView.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: Main_Screen_Height)
            
            contentView = headerView
            
            if type == .mcoin_privateKey {
                headerView.bottomBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportWalletPage_export_btn_title_key), for: UIControlState.normal)
            }
            else {
                headerView.bottomBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ResetWalletPasswordPage_bottom_btn_title_key), for: UIControlState.normal)
            }
            
            headerView.argreeBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    let walletProtocolCtrl = WalletProtocolViewController()
                    weakSelf.navigationController?.pushViewController(walletProtocolCtrl, animated: true)
                }
            }
            
            headerView.importBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    weakSelf.requestForExportWallet()
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


