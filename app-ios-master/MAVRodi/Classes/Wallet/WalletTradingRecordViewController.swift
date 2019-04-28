//
//  WalletTradingRecordViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  钱包交易记录

import UIKit
import ObjectMapper
import XREasyRefresh

class WalletTradingRecordViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    var tableHeaderVw: WalletTradingRecordHeaderView!
    let bgView = UIView(frame:CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    let bgView1 = UIView(frame:CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    
    //是否显示强制备份弹窗
    private var isShowBackUpNowAlertView: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: isBucketPrivate())
        }
    }
    
    var navTitle: String?
    var model: WalletHomeListModel!
    var curPage: Int = 0
    
    private var recordList: [WalletTransferRecordListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = navTitle
        self.subViewInitalzations()
        /*
        self.mainTableView.xr.addPullToRefreshHeader(refreshHeader: MRActivityRefreshHeader(), heightForHeader: 60, ignoreTopHeight: XRRefreshMarcos.xr_StatusBarHeight) { [weak self]() in
            if let weakSelf = self {
                weakSelf.requestForTransferRecordList(isRefresh: true, isPullToRefresh: false)
            }
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.requestForTransferRecordList(isRefresh: true, isPullToRefresh: false)
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initlzations
    func subViewInitalzations() {
        
        
        let tableHeaderVw = Bundle.main.loadNibNamed("WalletTradingRecordHeaderView", owner: nil, options: nil)?.first as! WalletTradingRecordHeaderView
        tableHeaderVw.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 325 * theScaleToiPhone_6)
        
        tableHeaderVw.iconImgView.oss_ntSetImageWithURL(urlStr: model.logo ?? "", placeholderImage: nil)
        var balance = model.balance
        if model.name != "Mcoin" {// ETC  ETH
            balance = String.stringFormatMultiplyingByPowerOf10_18(str: model.balance ?? "")
        }
        else {
            if let douValue = balance!.toDouble(){
                balance = String(format: "%.6f", douValue)
            }
            //                balance = String.stringFormatMultiplyingByPowerOf10_6(str: model.balance ?? "")
        }
        tableHeaderVw.balanceLbl.text = balance
        tableHeaderVw.amoutLbl.text = String(format: "≈$%@", model.worth ?? "0.000")
        
        tableHeaderVw.receiptBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_receipt_btn_title_key), for: UIControlState.normal)
        tableHeaderVw.transferBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_trasfer_btn_title_key), for: UIControlState.normal)
        tableHeaderVw.bottomLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_transfer_record_lbl_text_key)
        tableHeaderVw.receiptBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                DispatchQueue.main.async {
                    if weakSelf.isShowBackUpNowAlertView {
                        //  未备份 强制弹窗备份
                        BackUpNowAlertView.showWalletBackUpNowAlertView(superV: weakSelf.view, confirmTapClosure: {
                            
                            weakSelf.showWalletEnterPasswordAlertController()
                        })
                    }else {
                        weakSelf.pushToReceiptViewCtrl()
                    }
                    
                }
            }
        }
        
        tableHeaderVw.transferBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                DispatchQueue.main.async {
                    let transferViewCtrl = WalletTransferViewController()
                    transferViewCtrl.model = weakSelf.model
                    weakSelf.navigationController?.pushViewController(transferViewCtrl, animated: true)
                }
            }
        }
        
        self.view.addSubview(tableHeaderVw)
        tableHeaderVw.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(Sys_Status_Bar_Height)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(325 * theScaleToiPhone_6+Sys_Status_Bar_Height)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = MRColorManager.TableViewSeparatorLineDarkColor
        mainTableView.backgroundColor = MRColorManager.Table_Collection_ViewBackgroundColor
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
            
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.statusBar.backgroundColor = MRColorManager.StatusBarBackgroundColor
        navBarView.bottomLine.isHidden = true
        navBarView.titleLbl.text = self.navTitle
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        let imageView = TableViewBgView(frame:CGRect.zero)
        imageView.addBgViewToSuperView(frame: CGRect(x: 0, y: 325, width: Main_Screen_Width, height: Main_Screen_Height-487), tips:  MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_title_key), image: UIImage(named: "bgImage")!)
        bgView.addSubview(imageView)
        
        mainTableView.backgroundView=bgView
        
    }
    // App语言切换
    override func appLanguageChanged(notifi: Notification) {
        
        self.mainTableView.reloadData()
        let imageView = TableViewBgView(frame:CGRect.zero)
        imageView.addBgViewToSuperView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: Main_Screen_Height-420), tips: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_title_key), image: UIImage(named: "bgImage")!)
        bgView.removeAllSubviews()
        bgView.addSubview(imageView)
    }
    // MARK: - Request
    func requestForTransferRecordList(isRefresh: Bool, isPullToRefresh: Bool) {
        
        if MRCommonShared.shared.loginInfo == nil {
            return
        }
        /*
        if isRefresh {
            curPage = 0
        }
        else {
            curPage = curPage + 1
        }
        */
        var params: [String: Any] = [:]
        params["id"] = model.id
        /*
        params["page"] = curPage
        params["limit"] = 10
        */
        if !isPullToRefresh {
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        }
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_WALLET_TRANSFER_RECORDLIST, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dataList = data as? [[String: Any]] {
                        if isRefresh {
                            weakSelf.recordList.removeAll()
                        }
                        
                        let recordList_ = Mapper<WalletTransferRecordListModel>().mapArray(JSONArray: dataList)
                        weakSelf.recordList.append(contentsOf: recordList_)
                        /*
                        if dataList.count > 0 {
                            weakSelf.mainTableView.xr.addPullToRefreshFooter(refreshFooter: MRActivityRefreshFooter(), heightForFooter: 60, ignoreBottomHeight: XRRefreshMarcos.xr_BottomIndicatorHeight, refreshingClosure: {
                                weakSelf.requestForTransferRecordList(isRefresh: false, isPullToRefresh: true)
                            })
                        }
                        else {
                            weakSelf.mainTableView.xr.endFooterRefreshingWithNoMoreData()
                        }
                        */
                    }
                    
                    weakSelf.mainTableView.reloadData()
                    /*
                    weakSelf.mainTableView.xr.endHeaderRefreshing()
                    weakSelf.mainTableView.xr.endFooterRefreshing()
                    */
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_loading_faild_message))
                    }
                    /*
                    weakSelf.mainTableView.xr.endHeaderRefreshing()
                    weakSelf.mainTableView.xr.endFooterRefreshing()
                    */
                }
            }
        }
    }
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension WalletTradingRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(recordList.count != 0)
        {
            mainTableView.backgroundView=bgView1
        }
        else
        {
            mainTableView.backgroundView=bgView
        }
        return recordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < recordList.count {
            var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellForWalletHomeList")
            
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "UITableViewCellForWalletHomeList")
            }
            cell?.imageView?.image = UIImage(named: "icon_zhuanchu")
            
            cell?.selectionStyle = .default
            
            let record = recordList[indexPath.row]
            
            cell?.textLabel?.textColor = MRColorManager.GrayTextColor
            cell?.textLabel?.textAlignment = .left
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            if record.type == 1 {// 类型 1转出 2转入
                
                cell?.imageView?.image = UIImage(named: "icon_zhuanchu")
                // 转出
                if record.status == 1 {
                    // 打包中
                    cell?.textLabel?.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_wait_package_title_key)
                }
                else {
                    cell?.textLabel?.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_transfer_out_title_key)
                }
            }
            else {
                cell?.imageView?.image = UIImage(named: "icon_zhuanru")
                cell?.textLabel?.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_income_title_key)
            }
            
            cell?.detailTextLabel?.textColor = MRColorManager.GrayTextColor
            cell?.detailTextLabel?.textAlignment = .left
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
            cell?.detailTextLabel?.text = record.add_time
            
            cell?.accessoryType = .none
            
            let rightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            
            rightLbl.textAlignment = .right
            rightLbl.font = UIFont.systemFont(ofSize: 18)
            
            if record.type == 1 {
                // 转出
                rightLbl.textColor = UIColorFromRGB(hexRGB: 0xaa0202)
                let num = record.num
//                if model.name != "Mcoin" {// ETC  ETH
//                    num = String.stringFormatMultiplyingByPowerOf10_18(str: record.num)
//                }
//                else {
//                    num = String.stringFormatMultiplyingByPowerOf10_6(str: model.balance ?? "")
//                }
                rightLbl.text = String(format: "-%@", num)
            }
            else {
                rightLbl.textColor = UIColorFromRGB(hexRGB: 0x16a2ac)
                let num = record.num
//                if model.name != "Mcoin" {// ETC  ETH
//                    num = String.stringFormatMultiplyingByPowerOf10_18(str: record.num)
//                }
//                else {
//                    num = String.stringFormatMultiplyingByPowerOf10_6(str: model.balance ?? "")
//                }
                rightLbl.text = String(format: "+%@", num)
            }
            
            rightLbl.sizeToFit()
            
            cell?.accessoryView = rightLbl
            
            return cell!
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < recordList.count {
            let record = recordList[indexPath.row]
            
            let detailCtrl = WalletTransferResultViewController()
            detailCtrl.mcoinName = model.name
            detailCtrl.detailModel = record
            
            if record.status == 1 || record.status == 2 {
                detailCtrl.isSuccess = true
                detailCtrl.detailModel = record
            }
            else {
                detailCtrl.isSuccess = false
            }
            
            self.navigationController?.pushViewController(detailCtrl, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /**
        if section == 0 {
            let tableHeaderVw = Bundle.main.loadNibNamed("WalletTradingRecordHeaderView", owner: nil, options: nil)?.first as! WalletTradingRecordHeaderView
            tableHeaderVw.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 325 * theScaleToiPhone_6)
            
            tableHeaderVw.iconImgView.oss_ntSetImageWithURL(urlStr: model.logo ?? "", placeholderImage: nil)
            var balance = model.balance
            if model.name != "Mcoin" {// ETC  ETH
                balance = String.stringFormatMultiplyingByPowerOf10_18(str: model.balance ?? "")
            }
            else {
                if let douValue = balance!.toDouble(){
                    balance = String(format: "%.6f", douValue)
                }
//                balance = String.stringFormatMultiplyingByPowerOf10_6(str: model.balance ?? "")
            }
            tableHeaderVw.balanceLbl.text = balance
            tableHeaderVw.amoutLbl.text = String(format: "≈$%@", model.worth ?? "0.000")
            
            tableHeaderVw.receiptBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_receipt_btn_title_key), for: UIControlState.normal)
            tableHeaderVw.transferBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_trasfer_btn_title_key), for: UIControlState.normal)
            tableHeaderVw.bottomLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_transfer_record_lbl_text_key)
            tableHeaderVw.receiptBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    DispatchQueue.main.async {
                        if weakSelf.isShowBackUpNowAlertView {
                            //  未备份 强制弹窗备份
                            BackUpNowAlertView.showWalletBackUpNowAlertView(superV: weakSelf.view, confirmTapClosure: {
                                
                                weakSelf.showWalletEnterPasswordAlertController()
                            })
                        }else {
                            weakSelf.pushToReceiptViewCtrl()
                        }
                        
                    }
                }
            }
            
            tableHeaderVw.transferBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    DispatchQueue.main.async {
                        let transferViewCtrl = WalletTransferViewController()
                        transferViewCtrl.model = weakSelf.model
                        weakSelf.navigationController?.pushViewController(transferViewCtrl, animated: true)
                    }
                }
            }
            
            return tableHeaderVw
        }
        **/
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return  325 * theScaleToiPhone_6
//        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}


// MAKR: - 私钥备份
extension WalletTradingRecordViewController {
    
    // 收款页面
    func pushToReceiptViewCtrl() {
        
        let receiptViewCtrl = WalletReceiptViewController()
        receiptViewCtrl.model = self.model
        self.navigationController?.pushViewController(receiptViewCtrl, animated: true)
    }
    
    func showWalletEnterPasswordAlertController() {
        
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

