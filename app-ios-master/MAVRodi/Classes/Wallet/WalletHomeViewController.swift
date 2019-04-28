//
//  WalletHomeViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/31.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  钱包首页

import UIKit
import ObjectMapper
import XREasyRefresh

class WalletHomeViewController: MRBaseViewController {
    
    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    var tableHeaderVw: WalletHomeTableHeaderView!
    private var settingsBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    // 是否显示备份弹窗
    var isShowReminder: Bool = true
    
    private var dataList: [WalletHomeListModel] = []
    private var totalAssets: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.subViewInitalzations()
        self.requestForWalletList(isPullToRefresh: false)
        
        self.mainTableView.xr.addPullToRefreshHeader(refreshHeader: MRActivityRefreshHeader(), heightForHeader: 60, ignoreTopHeight: XRRefreshMarcos.xr_StatusBarHeight) { [weak self]() in
            if let weakSelf = self {
                weakSelf.requestForWalletList(isPullToRefresh: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isShowReminder = !UserDefaults.standard.bool(forKey: isBucketPrivate())
        self.requestForWalletList(isPullToRefresh: true)
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initlzations
    func subViewInitalzations() {
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = UIColor.clear
        mainTableView.backgroundColor = UIColorFromRGB(hexRGB: 0xf5f5f5)
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        mainTableView.register(UINib(nibName: "WalletHomeListCell", bundle: nil), forCellReuseIdentifier: "WalletHomeListCell")
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        mainTableView.register(UINib(nibName: "WalletHomeToolCell", bundle: nil), forCellReuseIdentifier: "WalletHomeToolCell")
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 35))
        
        
        // setting
        self.view.addSubview(settingsBtn)
        settingsBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Sys_Status_Bar_Height + 15)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(40)
        }
        
        settingsBtn.setImage(UIImage(named: "icon_wallet_home_settings"), for: UIControlState.normal)
        settingsBtn.addTarget(self, action: #selector(self.settingsBtnAction), for: UIControlEvents.touchUpInside)
        
    }
    
    // MARK: - Action
    @objc func settingsBtnAction() {
        
        let settingsViewCtrl = WalletSettingsViewController()
        settingsViewCtrl.totalAmount = totalAssets
        self.navigationController?.pushViewController(settingsViewCtrl, animated: true)
    }
    
    override func appLanguageChanged(notifi: Notification) {
        
        self.mainTableView.reloadData()
        
    }
    
    // MARK: - Request
    func requestForWalletList(isPullToRefresh: Bool) {
        
        if !isPullToRefresh {
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        }
        
        var params: [String: Any] = [:]
        params["refresh"] = true
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_WALLET_GET_LIST, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        if let total = dict["totalAssets"] as? String {
                            weakSelf.totalAssets = total
                        }
                        
                        if let dataArr = dict["list"] as? [[String: Any]] {
                            weakSelf.dataList = Mapper<WalletHomeListModel>().mapArray(JSONArray: dataArr)
                        }
                    }
                    
                    weakSelf.mainTableView.reloadData()
                    weakSelf.mainTableView.xr.endHeaderRefreshing()
                }
                else {
                    if let errMsg = message, !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_Send_Faild_Key))
                    }
//                    weakSelf.mainTableView.reloadData()
//                    weakSelf.mainTableView.xr.endHeaderRefreshing()
                }
            }
        }
    }
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension WalletHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataList.count == 0 {
            return 0
        }
        return dataList.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WalletHomeToolCell", for: indexPath) as! WalletHomeToolCell
            
            cell.reminderLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_remindder_text_key)
            cell.detailLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_remindder_detail_text_key)
            
            cell.laterBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_later_btn_title_key), for: UIControlState.normal)
            cell.backUpNowBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_back_up_now_btn_title_key), for: UIControlState.normal)
            
            cell.laterBtnTapActionClosure = {
                self.isShowReminder = false
                self.mainTableView.reloadData()
            }
            cell.backUpNowBtnTapActionClosure = {
                
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
            cell.selectionStyle = .none
            return cell
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WalletHomeListCell", for: indexPath) as! WalletHomeListCell
            
            cell.selectionStyle = .none
            
            let model = dataList[indexPath.section - 1]
            cell.configCellWithModel(model: model)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section != 0 {
            if indexPath.section <= self.dataList.count {
                let model = self.dataList[indexPath.section - 1]
                let tradingRecordViewCtrl = WalletTradingRecordViewController()
                tradingRecordViewCtrl.navTitle = model.name
                tradingRecordViewCtrl.model = model
                self.navigationController?.pushViewController(tradingRecordViewCtrl, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            tableHeaderVw = Bundle.main.loadNibNamed("WalletHomeTableHeaderView", owner: nil, options: nil)?.first as? WalletHomeTableHeaderView
            tableHeaderVw.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 213 * theScaleToiPhone_6)
            tableHeaderVw.valueTextLbl.text = "≈$"+totalAssets!
            tableHeaderVw.topTitleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_total_assets_title_key)
            return tableHeaderVw
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if isShowReminder {
                return 151
            }
            return CGFloat.leastNormalMagnitude
        }
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 213 * theScaleToiPhone_6
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    
}

//MARK: - 导出私钥
extension WalletHomeViewController {
    
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
}

