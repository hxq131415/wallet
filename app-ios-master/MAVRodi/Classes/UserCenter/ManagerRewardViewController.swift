//
//  ManagerRewardViewController.swift
//  MAVRodi
//
//  Created by HJY on 2018/12/1.
//  Copyright © 2018年 是心作佛. All rights reserved.
//
// 改版---管理奖励

enum MRRewardType: Int {
    //邀请奖励
    case sharing  = 2
    //管理奖励
    case leadership = 3
}

import UIKit
import ObjectMapper
import XREasyRefresh


class ManagerRewardViewController: MRBaseViewController,CustomAlertDelegete {
    func btnindex(_ index: Int32, _ tag: Int32) {
        if (index == 2) {
            let str:String = String(format: "%d/%d/%d  ▼", Dpicker.year,Dpicker.month,Dpicker.day)
            contentView.selectDateBtn.setTitle(str, for: UIControlState.normal)
            let checkDate:String = String(format: "%d-%d-%d", Dpicker.year,Dpicker.month,Dpicker.day)
            contentView.selectDateBtn.setTitle(str, for: UIControlState.normal)
            requestForGetBonusRecordByDayList(isRefresh: true, isPullToRefresh: false, checkDate: checkDate)
            print("%d年%d月%d日",Dpicker.year,Dpicker.month,Dpicker.day)
        }
    }
    

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    private var contentView: ManagerRewardContentView!
    
    var rewardType: MRRewardType = .sharing
    
    let bgView = UIView(frame:CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    let bgView1 = UIView(frame:CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    
    
    
    var pickerAlertview: JXAlertview!
    var Dpicker: CustomDatePicker!;
    private var rewardModel: MyRewardModel?
    var model: WalletHomeListModel!
    var curPage: Int = 0
    
    private var recordList: [MyRewardListModel] = []
    
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subViewInitlzation()
        
        if rewardType == .sharing {//邀请奖励
            requestForGetInvitationRewardInfo()
        }else {
            requestForGetManagementRewardInfo()
        }
        
//        let date = NSDate()
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "yyyy-MM-dd"
//        let strNowTime = timeFormatter.string(from: date as Date) as String
        

        
        /*
         self.mainTableView.xr.addPullToRefreshHeader(refreshHeader: MRActivityRefreshHeader(), heightForHeader: 60, ignoreTopHeight: XRRefreshMarcos.xr_StatusBarHeight) { [weak self]() in
         if let weakSelf = self {
         requestForGetBonusRecordByDayList(isRefresh: true, isPullToRefresh: false, checkDate: strNowTime)
         }
         }
         */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        requestForGetBonusRecordByDayList(isRefresh: true, isPullToRefresh: false, checkDate: strNowTime)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Intialization
    func subViewInitlzation() {
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.bottomLine.isHidden = true
        navBarView.rightButtonImage = UIImage(named: "icon_wh")
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        navBarView.rightButtonClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.showAlertView()
            }
        }
        
        if rewardType == .sharing {
            navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_sharing_navigation_title_key)
        }
        else {
            navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_leadership_navigation_title_key)
        }
        contentView = Bundle.main.loadNibNamed("ManagerRewardContentView", owner: self, options: nil)?.last as? ManagerRewardContentView
        contentView.frame = self.view.bounds
        contentView.backgroundColor = UIColor.clear
        self.view.addSubview(contentView)
        self.view.sendSubview(toBack: contentView)
        contentView.rewardType = self.rewardType
        // 进入资金池
        contentView.selectDateBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                
                weakSelf.pickerAlertview = JXAlertview(frame: CGRect(x: 10, y: (weakSelf.view.frame.size.height-260)/2, width: weakSelf.view.frame.size.width-20, height: 260))
                weakSelf.pickerAlertview.delegate = self
                weakSelf.pickerAlertview.initwithtitle("请选择日期", andmessage: "", andcancelbtn: "取消", andotherbtn: "确定")
                
                weakSelf.Dpicker = CustomDatePicker(frame: CGRect(x: 0, y: 20, width: weakSelf.pickerAlertview.frame.size.width-20, height: 200))
                weakSelf.pickerAlertview.addSubview(weakSelf.Dpicker)
                weakSelf.pickerAlertview.cancelbtn.layer.cornerRadius = 15
                //        pickerAlertview.cancelbtn.backgroundColor = UIColorFromRGB(hexRGB: 0xf5f5f5)
                weakSelf.pickerAlertview.surebtn.layer.cornerRadius = 15
                weakSelf.pickerAlertview.surebtn.backgroundColor = UIColorFromRGB(hexRGB: 0x16A2Ac)
                weakSelf.pickerAlertview.show()
            }
        }
        
        var contentViewHeight:CGFloat = 0.0
        
        if rewardType == .sharing {//邀请奖励
            contentViewHeight = 400.0
        }else {
            contentViewHeight = 483.0
        }
        
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(contentViewHeight * theScaleToiPhone_6+Sys_Status_Bar_Height)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = MRColorManager.TableViewSeparatorLineDarkColor
        mainTableView.backgroundColor = MRColorManager.Table_Collection_ViewBackgroundColor
//        mainTableView.backgroundColor = UIColor.green

        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        let imageViewH = rewardType == .sharing ? mainTableView.frame.size.height/2 : mainTableView.frame.size.height/2 - 50
        let imageView = TableViewBgView(frame:CGRect.zero)
        imageView.addBgViewToSuperView(frame: CGRect(x: 0, y: imageViewH, width: Main_Screen_Width, height: Main_Screen_Height-487), tips:  MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_title_key), image: UIImage(named: "bgImage")!)
        bgView.addSubview(imageView)
        
        mainTableView.backgroundView=bgView
        
        
        
    }

    func showAlertView() {
        
        var title: String = ""
        var detail: String = ""
        if self.rewardType == .sharing {
            title = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagerReward_alertView_sharing_title_key)
            detail = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagerReward_alertView_sharing_detail_key)
        }
        else {
            title = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagerReward_alertView_leadership_title_key)
            detail = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagerReward_alertView_leadership_detail_key)
        }
        
        CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: detail) {
            
        }
    }
   
    // MARK: - Request
    func requestForGetInvitationRewardInfo() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_GET_INVITATION_REWARD_INFO, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        weakSelf.rewardModel = MyRewardModel(JSON: dict)
                    }
                    weakSelf.contentView.model = weakSelf.rewardModel
                    
                }
                else {
                    // 加载失败了
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showBottomMessage(errMsg)
                    }
                    else {
                        weakSelf.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_loading_faild_message))
                    }
                }
            }
        }
    }
    
    func requestForGetManagementRewardInfo() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_GET_MANAGEMENT_REWARD_INFO, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        weakSelf.rewardModel = MyRewardModel(JSON: dict)
                    }
                    weakSelf.contentView.model = weakSelf.rewardModel
                }
                else {
                    // 加载失败了
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showBottomMessage(errMsg)
                    }
                    else {
                        weakSelf.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_loading_faild_message))
                    }
                }
            }
        }
    }
    
    // MARK: - RequestgetBonusRecordByDay
    func requestForGetBonusRecordByDayList(isRefresh: Bool, isPullToRefresh: Bool, checkDate: String) {
        
        if MRCommonShared.shared.loginInfo == nil {
            return
        }
        if let userInfo = MRCommonShared.shared.userInfo{
            let userId = userInfo.user_id
            
            /*
             if isRefresh {
             curPage = 0
             }
             else {
             curPage = curPage + 1
             }
             */
            var params: [String: Any] = [:]
            params["id"] = userId
            params["BonusType"] = rewardType == .sharing ? "2":"3"
            params["QryDate"] = checkDate
            /*
             params["page"] = curPage
             params["limit"] = 10
             */
            if !isPullToRefresh {
                TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
            }
            
            TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_GET_BONUSRECORD_BYDAY_REWARD_INFO, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
                if let weakSelf = self {
                    TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                    if status == 0 {
                        
                        if let dict = data as? [String: Any] {
                            if let totalDic = dict["total_bonus"] as? [String: Any] {
                                if let total = totalDic["total_bonus"] as? String {
                                    weakSelf.contentView.todayInputLabel.text = "当日收益（ETC)："+total
                                }
                            }
                            
                            if let dataArr = dict["list"] as? [[String: Any]] {
                                if isRefresh {
                                    weakSelf.recordList.removeAll()
                                }
                                let recordList_ = Mapper<MyRewardListModel>().mapArray(JSONArray: dataArr)
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
}


// MAKR: - UITableViewDelegate & UITableViewDataSource
extension ManagerRewardViewController: UITableViewDelegate, UITableViewDataSource {
    
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
                cell?.textLabel?.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTradingRecordPage_transfer_out_title_key)
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
                let num = record.change_amount
                //                if model.name != "Mcoin" {// ETC  ETH
                //                    num = String.stringFormatMultiplyingByPowerOf10_18(str: record.num)
                //                }
                //                else {
                //                    num = String.stringFormatMultiplyingByPowerOf10_6(str: model.balance ?? "")
                //                }
                rightLbl.text = String(format: "%@", num)
            }
            else {
                rightLbl.textColor = UIColorFromRGB(hexRGB: 0x16a2ac)
                let num = record.change_amount
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
        
        return
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
