//
//  WalletSettingsViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/6.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  钱包设置

import UIKit

class WalletSettingsViewController: MRBaseViewController {

    private lazy var mainTableView: UITableView =
        UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    private lazy var dataArray: [(String, String)] = []
    var totalAmount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.customNavigationBarBackgroundImageWithoutBottomLine()
        
        self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletSettingsPage_navigation_title_key)
        
        dataArray.append(("icon_password_light_blue", MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletSettingsPage_item_modify_pwd_title_key)))
        dataArray.append(("icon_wallet_key", MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletSettingsPage_item_bucket_privatekey_title_key)))
        dataArray.append(("icon_link_light_blue", MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletSettingsPage_item_export_publickey_title_key)))
        
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
        
        let headerVw = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 140))
        
        let contentBackVw = UIView(frame: CGRect(x: 18, y: 22, width: Main_Screen_Width - 36, height: 96))
        headerVw.addSubview(contentBackVw)
        contentBackVw.backgroundColor = UIColor.white
        contentBackVw.cornerRadius = 8
        
        let amountLbl = UILabel(frame: CGRect.zero)
        amountLbl.configLabel(text: String(format: "≈%@%@", MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletSettingsPage_amount_uint_text_key), totalAmount ?? "0.000"), numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
        contentBackVw.addSubview(amountLbl)
        amountLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(10)
        }
        
        mainTableView.tableHeaderView = headerVw
        
        let footerVw = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 140))
        
        let deleteBtn = UIButton(type: UIButtonType.custom)
        deleteBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletSettingsPage_delete_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x33C6B3))
        deleteBtn.cornerRadius = 4
        
        footerVw.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.width.equalTo(295 * theScaleToiPhone_6)
            make.height.equalTo(45)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
        }
        
        deleteBtn.addTarget(self, action: #selector(self.deleteWalletAction), for: UIControlEvents.touchUpInside)
        
        let detailLbl = UILabel(frame: CGRect.zero)
        detailLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletSettingsPage_bottom_infoLbl_text_key), numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x7e7e7e), font: UIFont.systemFont(ofSize: 10))
        footerVw.addSubview(detailLbl)
        detailLbl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(deleteBtn.snp.bottom).offset(24)
            make.height.greaterThanOrEqualTo(10)
        }
        
        mainTableView.tableFooterView = footerVw
    }
    
    // MARK: - Action
    @objc func deleteWalletAction() {
        
        let enterPwdCtrl = WalletEnterPasswordAlertController()
        enterPwdCtrl.modalPresentationStyle = .overFullScreen
        
//        enterPwdCtrl.isDeleteWallet = true//更改逻辑，删除钱包不用输入用户密码，只需要输入钱包密码即可
        enterPwdCtrl.isDeleteWallet = false
        self.present(enterPwdCtrl, animated: false) {
            enterPwdCtrl.showAlert()
        }
        
        enterPwdCtrl.hideAlertViewClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.resetStatusBarBackgroundColor()
            }
        }
        
        enterPwdCtrl.enterPwdFinishClosure = { [weak self](pwd) in
            if let weakSelf = self {
                weakSelf.requestForDeleteWallet(pwd: pwd)
            }
        }
    }
    
    // MARK: - Request
    func requestForDeleteWallet(pwd: String) {
        
        var params: [String: Any] = [:]
        params["payPassword"] = pwd
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_WALLET_DELETE, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    
                    let userInfo_ = MRCommonShared.shared.userInfo
                    userInfo_?.is_bind_wallet = 0
                    MRCommonShared.shared.userInfo = userInfo_
                    
                    (UIApplication.shared.delegate as? MRAppDelegate)?.refreshTabbarController()
                    
                    // 更新会员信息，钱包绑定成功
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
                        weakSelf.showMessage("删除钱包失败")
                    }
                }
            }
        }
    }
    
    // 导出私钥
    func requestForExportPrivateKey(pwd: String) {
        
        var params: [String: Any] = [:]
        params["password"] = pwd
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_WALLET_EXPORT_PRIVATEKEY, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let privateKeyDic = data as? [String: Any] {
                        if let privateKeyModel = CreateWalletPrivateKeyModel(JSON: privateKeyDic) {
                            let bucketPrivateKeyCtrl = BucketPrivateKeyViewController()
                            bucketPrivateKeyCtrl.privateKeyModel = privateKeyModel
                            weakSelf.navigationController?.pushViewController(bucketPrivateKeyCtrl, animated: true)
                        }
                    }
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty() {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage("私钥导出失败")
                    }
                }
            }
        }
    }
    
    // 导出公钥
    func requestForExportPublicKey(pwd: String) {
        
        var params: [String: Any] = [:]
        params["password"] = pwd
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_WALLET_EXPORT_PUBLICKEY, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let publicKeyDic = data as? [String: Any] {
                        if let publicKeyModel = CreateWalletPrivateKeyModel(JSON: publicKeyDic) {
                            let exportPublicKeyCtrl = WalletExportPublicKeyViewController()
                            exportPublicKeyCtrl.publicKeyModel = publicKeyModel
                            weakSelf.navigationController?.pushViewController(exportPublicKeyCtrl, animated: true)
                        }
                    }
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty() {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage("公钥导出失败")
                    }
                }
            }
        }
    }
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension WalletSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellForWalletSettings")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCellForWalletSettings")
        }
        
        let item = dataArray[indexPath.row]
        cell?.imageView?.image = UIImage(named: item.0)
        
        cell?.textLabel?.textColor = UIColorFromRGB(hexRGB: 0x2e2922)
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.text = item.1
        
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .default
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let modifyPwdCtrl = WalletModifyPasswordViewController()
            self.navigationController?.pushViewController(modifyPwdCtrl, animated: true)
        }
        else if indexPath.row == 1 {
            let enterPwdCtrl = WalletEnterPasswordAlertController()
            enterPwdCtrl.modalPresentationStyle = .overFullScreen
            self.present(enterPwdCtrl, animated: false) {
                enterPwdCtrl.showAlert()
            }
            
            enterPwdCtrl.hideAlertViewClosure = { [weak self] in
                if let weakSelf = self {
                    weakSelf.resetStatusBarBackgroundColor()
                }
            }
            
            enterPwdCtrl.enterPwdFinishClosure = { [weak self](pwd) in
                if let weakSelf = self {
                    weakSelf.requestForExportPrivateKey(pwd: pwd)
                }
            }
        }
        else if indexPath.row == 2 {
            let enterPwdCtrl = WalletEnterPasswordAlertController()
            enterPwdCtrl.modalPresentationStyle = .overFullScreen
            self.present(enterPwdCtrl, animated: false) {
                enterPwdCtrl.showAlert()
            }
            
            enterPwdCtrl.hideAlertViewClosure = { [weak self] in
                if let weakSelf = self {
                    weakSelf.resetStatusBarBackgroundColor()
                }
            }
            
            enterPwdCtrl.enterPwdFinishClosure = { [weak self](pwd) in
                if let weakSelf = self {
                    weakSelf.requestForExportPublicKey(pwd: pwd)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}




