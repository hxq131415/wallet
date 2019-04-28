//
//  PlanRecordViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/8/31.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
import ObjectMapper
import XREasyRefresh

// 参与状态
//状态 1排队中、2待会员转款、3待管理员审核、4已完成、5审核失败、8可以收获 7确认收货灰色
enum PlanRecordJoinStatus: Int {
    case all = 0 // 所有的
    case queuing = 1 // 排单期
    case waitTransfer = 2 // 待转款
    case waitCheck = 3 // 待审核
//    case waitHarvest = 8 // 可以收获
//    case finished  = 4 // 已完成
//    case checkFailure = 5 // 审核失败
    
    case finished  = 4 // 已完成
    case checkFailure = 5 // 审核失败
    case unaviableHarvest = 7 // 确认收货灰色
    case waitHarvest = 8 // 可以收获
    case grapQueuing = 9 // 抢单
}

// 收获状态
enum PlanRecordHarvestStatus: Int {
    case all = 0 // 所有的
    case queuing = 1 // 排单期
    case waitConfirm = 4 // 待确认--取消此状态
    case finished = 3 // 已完成
    case newFinished = 5 // 新已完成
    case wait = 2 // 等待
}

enum PlanRecordListType {
    case join    // 参与记录
    case harvest // 收获记录
    case finished // 已完成
}


enum PlanNotificationType {
    case join    // 参与
    case reward  // 奖励
    case harvest // 收获
}

class PlanRecordViewController: MRBaseViewController,PlainRecordListTableCellDelegate,PlainRecordListTableViewDelegate {
    func remainingCountReset() {
        requestForGrapStatus(isShowLoading: false)
    }
    
    func progressViewTouch(model: Any) {
        if model is PlanJoinRecordListModel{
            //参与
            let joinRecordModel = model as? PlanJoinRecordListModel
            if joinRecordModel?.joinStatusType == .waitHarvest {
                
                //参与--收获弹窗
                // 请求个人信息，判断是否已经被锁定
                TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
                MRTools.requestForGetUserData(completeBlock: {
                    TEActingLoadingView.hideActingLoadingViewInSuperView(superView: self.view)
                    if let userInfo = MRCommonShared.shared.userInfo {
                        if !userInfo.pd_lock {
                            HarvestConfirmAlertView.showHarvestConfirmAlertView(superV: ShareDelegate.window ?? self.view) {
                                
                                ///确认收获请求
                                self.requestForConfirmHarvest(record: joinRecordModel!)
                            }
                        }
                        else {
                            //弹框提示用户超过72小时未转款，该用户已被锁定。请联系管理员解锁后进行转账操作
                            let title = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirm_key)
                            let msg = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirmTips_key)
                            CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: msg) {
                                
                            }
                        }
                    }
                    
                    
                })
                
            }
            else if joinRecordModel?.joinStatusType == .waitTransfer {//3转款
                // 请求个人信息，判断是否已经被锁定
                TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
                MRTools.requestForGetUserData(completeBlock: {
                    TEActingLoadingView.hideActingLoadingViewInSuperView(superView: self.view)
                    if let userInfo = MRCommonShared.shared.userInfo {
                        if !userInfo.pd_lock {
                            let transferDetailCtrl = InvestmentTransferViewController()
                            let model = WalletHomeListModel()
                            model.name = "ETC"
                            model.balance = String(format: "%.6f", joinRecordModel!.amount)
                            model.id = joinRecordModel!.id
                            transferDetailCtrl.model = model
//                            transferDetailCtrl.transferType = .grapQueuing
                        self.navigationController?.pushViewController(transferDetailCtrl, animated: true)
                            
                        }
                        else {
                            //弹框提示用户超过72小时未转款，该用户已被锁定。请联系管理员解锁后进行转账操作
                            let title = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirm_key)
                            let msg = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirmTips_key)
                            CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: msg) {
                                
                            }
                        }
                    }
                    
                })
                
            }
            else if joinRecordModel?.joinStatusType == .queuing//抢单
            {
                requestForGrapQueuing(isShowLoading: true,model: joinRecordModel!)
            }
            
            return
        }

        if model is PlanHarvestRecordListModel{
            //收获
            // 请求个人信息，判断是否已经被锁定
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
            MRTools.requestForGetUserData(completeBlock: {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: self.view)
                if let userInfo = MRCommonShared.shared.userInfo {
                    if !userInfo.pd_lock {
                        // 收获确认
                        let receiptConfirmCtrl = WalletReceiptConfirmViewController()
                        receiptConfirmCtrl.harvestRecordModel = model as? PlanHarvestRecordListModel
                        self.navigationController?.pushViewController(receiptConfirmCtrl, animated: true)
                        return
                        
                    }
                    else {
                        //弹框提示用户超过72小时未转款，该用户已被锁定。请联系管理员解锁后进行转账操作
                        let title = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirm_key)
                        let msg = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirmTips_key)
                        CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: msg) {
                            
                        }
                    }
                }
            })
        }
    }
    

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    let bgView = UIView(frame:CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    let bgView1 = UIView(frame:CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))

    var tableHeaderVw: PlanRecordTableHeaderView!
    
    var recordListType: PlanRecordListType = .join
    
    var joinStatus: PlanRecordJoinStatus = .all
    // 投资收益
    private var profitInfoModel: ProfitInfoListModel?
    var joinCurPage: Int = 0
    var harvestCurPage: Int = 0
    // 参与记录
    var joinRecordList: [PlanJoinRecordListModel] = []
    // 筛选参与记录
//    var filterJoinRecordList: [PlanJoinRecordListModel] = []
    private var grapStatusModel: PlanJoinGrapStatusModel?
    // 收获记录
    var harvestStatus: PlanRecordHarvestStatus = .all
    var harvestRecordList: [PlanHarvestRecordListModel] = []
    // 筛选收获记录
//    var filterHarvestRecordList: [PlanHarvestRecordListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.requestForProfitInfoList()
        self.requestForJoinList(isShowLoading: false, isRefresh: true, isPullToRefresh: false)
        self.requestForHarvestRecordList(isShowLoading: false, isRefresh: true, isPullToRefresh: false)
        self.requestForGrapStatus(isShowLoading: true)
        self.subViewInitalzations()
        
        self.addNotification()
        
        /*
        self.mainTableView.xr.addPullToRefreshHeader(refreshHeader: MRActivityRefreshHeader(), heightForHeader: 60, ignoreTopHeight: XRRefreshMarcos.xr_StatusBarHeight) { [weak self]() in
            if let weakSelf = self {
                if(weakSelf.recordListType == .join)
                {
                    weakSelf.requestForJoinList(isShowLoading: false, isRefresh: true, isPullToRefresh: false)
                }
                else if(weakSelf.recordListType == .harvest)
                {
                    weakSelf.requestForHarvestRecordList(isShowLoading: false, isRefresh: true, isPullToRefresh: false)
                }
                
            }
        }
        */
    }
    override func viewWillDisappear(_ animated: Bool) {
//        tableHeaderVw.cancelTimer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestForProfitInfoList(isShowLoading: true)
        self.requestForJoinList(isShowLoading: true, isRefresh: true, isPullToRefresh: false)
        self.requestForHarvestRecordList(isShowLoading: true, isRefresh: true, isPullToRefresh: false)
        
        MRTools.requestForGetUserData(completeBlock: {
            if let userInfo = MRCommonShared.shared.userInfo {
                
                if userInfo.pd_lock && (userInfo.unlock_status == -1 || userInfo.unlock_status == 0){
                    //弹框提示用户该用户已被锁定。请联系管理员解锁后进行转账操作
                    PlanBackUpNowAlertView.showPlanBackUpNowAlertView(superV: self.view, confirmTapClosure: {
                        let unfreezeAccountViewCtrl = PlanUnfreezeAccountViewController()
                        self.navigationController?.pushViewController(unfreezeAccountViewCtrl, animated: true)
                    })
                }
            }
        })
        
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
        
        tableHeaderVw = (Bundle.main.loadNibNamed("PlanRecordTableHeaderView", owner: nil, options: nil)?.first as! PlanRecordTableHeaderView)
        tableHeaderVw.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 300*theScaleToiPhone_6)
        
        tableHeaderVw.selectRecordListTypeBtnWithType(recordListType: self.recordListType)
        tableHeaderVw.model = self.profitInfoModel
        // 进入资金池
        tableHeaderVw.introBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                
                let poolViewCtrl = MavrodiCapitalPoolViewController()
                weakSelf.navigationController?.pushViewController(poolViewCtrl, animated: true)
            }
        }
        
        tableHeaderVw.recordBtnChangedClosure = { [weak self](type) in
            if let weakSelf = self {
                weakSelf.recordListType = type
                weakSelf.mainTableView.reloadData()
                if(weakSelf.recordListType == .join)
                {
                    if(weakSelf.joinRecordList.count > 0)
                    {
                        //weakSelf.mainTableView.xr.addPullToRefreshFooter(refreshFooter: MRActivityRefreshFooter(), heightForFooter: 60, ignoreBottomHeight: XRRefreshMarcos.xr_BottomIndicatorHeight, refreshingClosure: {
                            if(weakSelf.recordListType == .join)
                            {
                                weakSelf.requestForJoinList(isShowLoading: false, isRefresh: true, isPullToRefresh: true)
                            }
                            else if(weakSelf.recordListType == .harvest)
                            {
                                weakSelf.requestForHarvestRecordList(isShowLoading: false, isRefresh: true, isPullToRefresh: true)
                            }
                        //})
                    }
                    else{
                        weakSelf.mainTableView.xr.endFooterRefreshingWithRemoveLoadingMoreView()
                    }
                }
                else if(weakSelf.recordListType == .harvest)
                {
                    if(weakSelf.harvestRecordList.count > 0)
                    {
                          //weakSelf.mainTableView.xr.addPullToRefreshFooter(refreshFooter: MRActivityRefreshFooter(), heightForFooter: 60, ignoreBottomHeight: XRRefreshMarcos.xr_BottomIndicatorHeight, refreshingClosure: {
                            if(weakSelf.recordListType == .join)
                            {
                                weakSelf.requestForJoinList(isShowLoading: false, isRefresh: true, isPullToRefresh: true)
                            }
                            else if(weakSelf.recordListType == .harvest)
                            {
                                weakSelf.requestForHarvestRecordList(isShowLoading: false, isRefresh: true, isPullToRefresh: true)
                            }
                        //})
                    }
                    else{
                        weakSelf.mainTableView.xr.endFooterRefreshingWithRemoveLoadingMoreView()
                    }
                }
                
            }
        }
        
        
//        tableHeaderVw.recordBtnChangedClosure = { [weak self](type) in
//            if let weakSelf = self {
////                weakSelf.recordListType = type
////                if(type == .join)
////                {
////                    weakSelf.tableHeaderVw.configGrapTipsLabel(tipsStr: "长沙市克里斯邓丽君")
////
////                }
////                else
////                {
////                    weakSelf.tableHeaderVw.configGrapTipsLabel(tipsStr: "抢单中")
////
////                }
//                weakSelf.mainTableView.reloadData()
//            }
//        }
        
        self.view.addSubview(tableHeaderVw)
        tableHeaderVw.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        
        
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(280*theScaleToiPhone_6)
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
        
        mainTableView.register(UINib(nibName: "PlainRecordListTableCell", bundle: nil), forCellReuseIdentifier: "PlainRecordListTableCell")
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        let imageView = TableViewBgView(frame:CGRect.zero)
        imageView.addBgViewToSuperView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: Main_Screen_Height-420), tips: MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_title_key), image: UIImage(named: "bgImage")!)
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
        tableHeaderVw.joinRecordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_segment_title_key), for: UIControlState.normal)
        tableHeaderVw.joinRecordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_segment_title_key), for: UIControlState.selected)
        
        tableHeaderVw.getRecordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_segment_title_key), for: UIControlState.normal)
        tableHeaderVw.getRecordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_segment_title_key), for: UIControlState.selected)
        //投资本金
        //总收益资产(ETC)
        //总收益(ETC)
        //总回报率
        tableHeaderVw.titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title_key)
        tableHeaderVw.titleLabel2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title2_key)
        tableHeaderVw.titleLabel3.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title3_key)
        
        tableHeaderVw.CapitalinLabel.text =  MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_capitalin_text_key)
        tableHeaderVw.CapitaloutLabel.text =  MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_capitalout_text_key)
        
        
    }
    
    // MARK: - Request
    // 获取投资收益信息
    func requestForProfitInfoList(isShowLoading: Bool = true) {
        
        if isShowLoading {
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        }
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_PROFIT_INFO, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        weakSelf.profitInfoModel = ProfitInfoListModel(JSON: dict)
                        weakSelf.tableHeaderVw.model = ProfitInfoListModel(JSON: dict)
                    }
                }
                else {
                    if let errMsg = message, !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_Send_Faild_Key))
                    }
                }
                
            }
        }
    }
    // 获取参与记录
    func requestForJoinList(isShowLoading: Bool,isRefresh: Bool, isPullToRefresh: Bool) {
        /*
        if isRefresh {
            joinCurPage = 0
        }
        else {
            joinCurPage = joinCurPage + 1
        }
        
        var params: [String: Any] = [:]
        params["page"] = joinCurPage
        params["limit"] = 10
        */
        
        if isShowLoading {
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        }
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_JOIN_LIhST, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dataArr = data as? [[String: Any]] {
                        
                        if isRefresh {
                            weakSelf.joinRecordList.removeAll()
                        }
                        
                        let joinRecordArr = Mapper<PlanJoinRecordListModel>().mapArray(JSONArray: dataArr)
                        weakSelf.joinRecordList.append(contentsOf: joinRecordArr)
                        
                        /*
                        if dataArr.count > 0 {
                            weakSelf.mainTableView.xr.addPullToRefreshFooter(refreshFooter: MRActivityRefreshFooter(), heightForFooter: 60, ignoreBottomHeight: XRRefreshMarcos.xr_BottomIndicatorHeight, refreshingClosure: {
                                if(weakSelf.recordListType == .join)
                                {
                                    weakSelf.requestForJoinList(isShowLoading: false, isRefresh: false, isPullToRefresh: true)
                                }
                                else if(weakSelf.recordListType == .harvest)
                                {
                                    weakSelf.requestForHarvestRecordList(isShowLoading: false, isRefresh: false, isPullToRefresh: true)
                                }
                            })
                        }
                        else {
                            if(weakSelf.joinRecordList.count > 0)
                            {
                                weakSelf.mainTableView.xr.endFooterRefreshingWithNoMoreData()
                            }
                            else{
                                weakSelf.mainTableView.xr.endFooterRefreshingWithRemoveLoadingMoreView()
                            }
                        }
                        */
                        
                        
                        
//                        let joinRecordArr = Mapper<PlanJoinRecordListModel>().mapArray(JSONArray: dataArr)
//                        weakSelf.joinRecordList.removeAll()
//                        weakSelf.joinRecordList.append(contentsOf: joinRecordArr)
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
    
    // 获取收获记录列表
    func requestForHarvestRecordList(isShowLoading: Bool,isRefresh: Bool, isPullToRefresh: Bool) {
        /*
        if isRefresh {
            harvestCurPage = 0
        }
        else {
            harvestCurPage = harvestCurPage + 1
        }
        
        var params: [String: Any] = [:]
        params["page"] = harvestCurPage
        params["limit"] = 10
        */
        if isShowLoading {
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        }
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_HEARVEST_LIST, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dataArr = data as? [[String: Any]] {
                        if isRefresh {
                            weakSelf.harvestRecordList.removeAll()
                        }
                        
                        let joinRecordArr = Mapper<PlanHarvestRecordListModel>().mapArray(JSONArray: dataArr)
                        weakSelf.harvestRecordList.append(contentsOf: joinRecordArr)
                        /*
                        if dataArr.count > 0 {
                            weakSelf.mainTableView.xr.addPullToRefreshFooter(refreshFooter: MRActivityRefreshFooter(), heightForFooter: 60, ignoreBottomHeight: XRRefreshMarcos.xr_BottomIndicatorHeight, refreshingClosure: {
                                if(weakSelf.recordListType == .join)
                                {
                                    weakSelf.requestForJoinList(isShowLoading: false, isRefresh: false, isPullToRefresh: true)
                                }
                                else if(weakSelf.recordListType == .harvest)
                                {
                                    weakSelf.requestForHarvestRecordList(isShowLoading: false, isRefresh: false, isPullToRefresh: true)
                                }
                            })
                        }
                        else {
                            if(weakSelf.harvestRecordList.count > 0)
                            {
                                weakSelf.mainTableView.xr.endFooterRefreshingWithNoMoreData()
                            }
                            else{
                                weakSelf.mainTableView.xr.endFooterRefreshingWithRemoveLoadingMoreView()
                            }
                        }
                        */
                        
//                        let harvestRecordArr = Mapper<PlanHarvestRecordListModel>().mapArray(JSONArray: dataArr)
//                        weakSelf.harvestRecordList.removeAll()
//                        weakSelf.harvestRecordList.append(contentsOf: harvestRecordArr)
                    }
                    
                    
                    weakSelf.mainTableView.reloadData()
                    weakSelf.mainTableView.xr.endFooterRefreshingWithRemoveLoadingMoreView()
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
    
    // MARK: - 获取确认收获(进场)
    func requestForConfirmHarvest(record: PlanJoinRecordListModel) {
        
        var params: [String: Any] = [:]
        params["id"] = record.id
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_CONFIRM_HARVEST, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("确认收获成功")
                    }
                    let harvest = PlanHarvestViewController()
                    weakSelf.pushToViewController(viewCtrl: harvest)
                }
                else {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("确认收获失败")
                    }
                }
            }
        }
    }
    
    // 获取抢单状态
    func requestForGrapStatus(isShowLoading: Bool) {
        
        if isShowLoading {
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        }
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_GRAPSTATUS, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    
                    if let dict = data as? [String: Any] {
                        
                        weakSelf.grapStatusModel = PlanJoinGrapStatusModel(JSON: dict)
                        weakSelf.tableHeaderVw.configGrapTipsLabel(grapStatusModel: weakSelf.grapStatusModel!)
                        if(!isShowLoading)
                        {
                            weakSelf.mainTableView.reloadData()
                        }
                        
                    }
                  
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_loading_faild_message))
                    }
                    
                }
            }
        }
    }
    //抢单
    func requestForGrapQueuing(isShowLoading: Bool, model: PlanJoinRecordListModel) {
        var params: [String: Any] = [:]
        params["id"] = model.id
        if isShowLoading {
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        }
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_GRAPJOIN, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    
                    weakSelf.dumpToTransferDetailCtrl(model: model)
                    
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_loading_faild_message))
                    }
                    
                }
            }
        }
    }
    //抢单转账
    func dumpToTransferDetailCtrl(model: PlanJoinRecordListModel){
        // 请求个人信息，判断是否已经被锁定
        let transferDetailCtrl = InvestmentTransferViewController()
        let model1 = WalletHomeListModel()
        model1.name = "ETC"
        model1.balance = String(format: "%.6f", model.amount)
        model1.id = model.id
        transferDetailCtrl.model = model1
        transferDetailCtrl.transferType = .grapQueuing
        self.navigationController?.pushViewController(transferDetailCtrl, animated: true)
        
    }
    
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension PlanRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recordListType == .join {
            if(joinRecordList.count != 0)
            {
                mainTableView.backgroundView=bgView1
            }
            else
            {
                mainTableView.backgroundView=bgView
            }
            return joinRecordList.count
        }
        else if recordListType == .harvest {
            if(harvestRecordList.count != 0)
            {
                mainTableView.backgroundView=bgView1
            }
            else
            {
                mainTableView.backgroundView=bgView
            }
            return harvestRecordList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PlainRecordListTableCell", for: indexPath) as? PlainRecordListTableCell {
            
            cell.selectionStyle = .none
            cell.delegate = self
            if recordListType == .join {
                if indexPath.row < joinRecordList.count {
                    let joinRecord = joinRecordList[indexPath.row]
                    if(self.grapStatusModel!.status != 1)
                    {
                        cell.configCellWithJoinRecordListModel(joinRecordListModel: joinRecord)

                    }
                    else
                    {
                        cell.configCellWithGropJoinRecordListModel(joinRecordListModel: joinRecord)

                    }
                }
            }
            else if recordListType == .harvest {
                if indexPath.row < harvestRecordList.count {
                    let record = harvestRecordList[indexPath.row]
                    cell.configCellWithHarvestRecordListModel(recordListModel: record)
                }
            }
            else {
                
            }
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if recordListType == .join {
            if indexPath.row < joinRecordList.count {
                let joinRecord = joinRecordList[indexPath.row]
                if joinRecord.joinStatusType == .queuing {//1排队中 排单
                    //参与--排单详情
                    let detailViewCtrl = PlanJoinOrderDetailViewController()
                    detailViewCtrl.joinRecord = joinRecord
                    self.navigationController?.pushViewController(detailViewCtrl, animated: true)
                }
                else if joinRecord.joinStatusType == .waitTransfer { // 2转款
                    //参与--投资转账
                    let detailViewCtrl = PlanJoinOrderDetailViewController()
                    detailViewCtrl.joinRecord = joinRecord
                    self.navigationController?.pushViewController(detailViewCtrl, animated: true)
                }
                else if joinRecord.joinStatusType == .waitCheck{ // 3待审核
                    let detailViewCtrl = PlanJoinOrderDetailViewController()
                    detailViewCtrl.joinRecord = joinRecord
                    self.navigationController?.pushViewController(detailViewCtrl, animated: true)
                }
                else if joinRecord.joinStatusType == .finished
                    || joinRecord.joinStatusType == .waitHarvest {//5已完成 4可以收获
                    //参与--收获详情
                    let detailViewCtrl = PlanJoinOrderDetailViewController()
                    detailViewCtrl.joinRecord = joinRecord
                    self.navigationController?.pushViewController(detailViewCtrl, animated: true)
                }
                
            }
        }
        else if recordListType == .harvest {
            if indexPath.row < harvestRecordList.count {
                let harvestRecord = harvestRecordList[indexPath.row]
                if harvestRecord.harvestStatusType == .queuing{//1排队中 排单
                    //收获--排单详情
                    let harvestDetailViewCtrl = PlanHarvestDetailsViewController()
                    harvestDetailViewCtrl.harvestList = [harvestRecord]
                    harvestDetailViewCtrl.harvestRecord = harvestRecord
                    self.navigationController?.pushViewController(harvestDetailViewCtrl, animated: true)
                }
                else if harvestRecord.harvestStatusType == .wait{//收获--等待
                    let harvestDetailViewCtrl = PlanHarvestDetailsViewController()
                    harvestDetailViewCtrl.harvestList = [harvestRecord]
                    harvestDetailViewCtrl.harvestRecord = harvestRecord
                    self.navigationController?.pushViewController(harvestDetailViewCtrl, animated: true)
                }
                else if harvestRecord.harvestStatusType == .waitConfirm {//收获--收获确认
                    
                    let harvestDetailViewCtrl = PlanHarvestDetailsViewController()
                    harvestDetailViewCtrl.harvestList = [harvestRecord]
                    harvestDetailViewCtrl.harvestRecord = harvestRecord
                    self.navigationController?.pushViewController(harvestDetailViewCtrl, animated: true)
                    
                }
                else if harvestRecord.harvestStatusType == .finished {//收获--完成
                    // 收获确认
                    let harvestDetailViewCtrl = PlanHarvestDetailsViewController()
                    harvestDetailViewCtrl.harvestList = [harvestRecord]
                    harvestDetailViewCtrl.harvestRecord = harvestRecord
                    self.navigationController?.pushViewController(harvestDetailViewCtrl, animated: true)
                }
                else if harvestRecord.harvestStatusType == .newFinished {//收获--完成
                    // 收获确认
                    let harvestDetailViewCtrl = PlanHarvestDetailsViewController()
                    harvestDetailViewCtrl.harvestList = [harvestRecord]
                    harvestDetailViewCtrl.harvestRecord = harvestRecord
                    self.navigationController?.pushViewController(harvestDetailViewCtrl, animated: true)
                }
                
            }
            
//            if indexPath.row < harvestRecordList.count {
//                let record = harvestRecordList[indexPath.row]
//                // 收获详情
//                let harvestDetailViewCtrl = PlanHarvestDetailsViewController()
//                harvestDetailViewCtrl.harvestList = [record]
//                self.navigationController?.pushViewController(harvestDetailViewCtrl, animated: true)
                  // 收获确认
//                let receiptConfirmCtrl = WalletReceiptConfirmViewController()
//                receiptConfirmCtrl.harvestRecordModel = model
//                self.navigationController?.pushViewController(receiptConfirmCtrl, animated: true)
//            }
        }
        else {
            
        }
        
        

        
        
        
        
        
        
//        if recordListType == .join {
//            // 参与
//            if indexPath.row < joinRecordList.count {
//                let record = joinRecordList[indexPath.row]
//
//                if record.joinStatusType == .queuing {//
//                    let detailViewCtrl = PlanJoinOrderDetailViewController()
//                    detailViewCtrl.joinRecordList = [record]
//                    self.navigationController?.pushViewController(detailViewCtrl, animated: true)
//                }
//                else if record.joinStatusType == .waitTransfer { // 转款
//                    let transferDetailCtrl = PlanTransferDetailsViewController()
//                    transferDetailCtrl.joinRecordList = [record]
//                    self.navigationController?.pushViewController(transferDetailCtrl, animated: true)
//                }
//                else if record.joinStatusType == .waitCheck { // 等待
//
//                }
//                else if record.joinStatusType == .finished
//                    || record.joinStatusType == .waitHarvest ||
//                    record.joinStatusType == .unaviableHarvest {//收获
//                    // 完成详情
//                    let finishDetailViewCtrl = PlanJoinFinishDetailViewController()
//                    finishDetailViewCtrl.joinRecordList = [record]
//                    self.navigationController?.pushViewController(finishDetailViewCtrl, animated: true)
//                }
//            }
//        }
//        else if recordListType == .harvest {
//            // 收获
//            if indexPath.row < harvestRecordList.count {
//                let record = harvestRecordList[indexPath.row]
//                // 收获详情
//                let harvestDetailViewCtrl = PlanHarvestDetailsViewController()
//                harvestDetailViewCtrl.harvestList = [record]
//                self.navigationController?.pushViewController(harvestDetailViewCtrl, animated: true)
//            }
//        }
//        else {
//            // 完成
//
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /**
        if section == 0 {
            let tableHeaderVw = Bundle.main.loadNibNamed("PlanRecordTableHeaderView", owner: nil, options: nil)?.first as! PlanRecordTableHeaderView
            tableHeaderVw.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 280)
            
            tableHeaderVw.selectRecordListTypeBtnWithType(recordListType: self.recordListType)
            tableHeaderVw.model = self.profitInfoModel
            // 进入资金池
            tableHeaderVw.introBtnTapClosure = { [weak self] in
                if let weakSelf = self {
                    
                    let poolViewCtrl = MavrodiCapitalPoolViewController()
                    weakSelf.navigationController?.pushViewController(poolViewCtrl, animated: true)
                }
            }
            
            tableHeaderVw.recordBtnChangedClosure = { [weak self](type) in
                if let weakSelf = self {
                    weakSelf.recordListType = type
                    weakSelf.mainTableView.reloadData()
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
//            return 280
//        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

extension PlanRecordViewController {
    
    func addNotification() {
        
        NotificationCenter.addObserver(observer: self, selector: #selector(self.listenNotification(not:)), name: NNKEY_PLAN_RECORD_NOTIFICATION, object: nil)
    }
    
    @objc func listenNotification(not: Notification) {
        debugPrint(not.object ?? "")
        if let type = not.object as? PlanNotificationType {
            if type == .join {
                
                let joinViewCtrl = PlanJoinViewController()
                self.navigationController?.pushViewController(joinViewCtrl, animated: true)
            }else if type == .reward {
                
                let rewardViewCtrl = RewardViewController()
                self.navigationController?.pushViewController(rewardViewCtrl, animated: true)
            }else {
                
                let harvestViewCtrl = PlanHarvestViewController()
                self.navigationController?.pushViewController(harvestViewCtrl, animated: true)
            }
        }
    }
    
}

//            tableHeaderVw.selectRecordStatusBtnWithRecordStatus(status: self.joinStatus, harvestStatus: self.harvestStatus)

//            //跳转参与页面
//            tableHeaderVw.joinBtnTapClosure = { [weak self] in
//                if let weakSelf = self {
//
//                    let joinViewCtrl = PlanJoinViewController()
//                    weakSelf.navigationController?.pushViewController(joinViewCtrl, animated: true)
//                }
//            }

//            //跳转收获页面
//            tableHeaderVw.getBtnTapClosure = { [weak self] in
//                if let weakSelf = self {
//
//                    let rewardViewCtrl = PlanHarvestViewController()
//                    weakSelf.navigationController?.pushViewController(rewardViewCtrl, animated: true)
//                }
//            }

//            tableHeaderVw.recordStatusBtnTapClosure = { [weak self](status, harvestStatus) in
//                if let weakSelf = self {
//                    if weakSelf.recordListType == .join {
//                        weakSelf.joinStatus = status
//                        weakSelf.filterJoinRecordListAndReload()
//                    }
//                    else if weakSelf.recordListType == .finished {
//                        weakSelf.joinStatus = status
//                        weakSelf.filterJoinRecordListAndReload()
//                    }
//                    else {
//                        weakSelf.harvestStatus = harvestStatus
//                        weakSelf.filterHarvestRecordListAndReload()
//                    }
//                }
//            }


// MARK: - Methods
//    func filterJoinRecordListAndReload() {
//
//        if self.joinStatus == .all {
//            self.filterJoinRecordList.removeAll()
//            self.filterJoinRecordList.append(contentsOf: self.joinRecordList)
//        }
//        else {
//            let filterArr = self.joinRecordList.filter({ (model) -> Bool in
//                return model.status == self.joinStatus.rawValue
//            })
//
//            self.filterJoinRecordList.removeAll()
//            self.filterJoinRecordList.append(contentsOf: filterArr)
//
//            if self.joinStatus == .finished { // status = 8 是可以收获状态，也是完成状态
//                let filterList = self.joinRecordList.filter({ (model) -> Bool in
//                    return model.status == PlanRecordJoinStatus.waitHarvest.rawValue
//                })
//                self.filterJoinRecordList.append(contentsOf: filterList)
//            }
//        }
//
//        self.mainTableView.reloadData()
//    }
//
//    func filterHarvestRecordListAndReload() {
//
//        if self.harvestStatus == .all {
//            self.filterHarvestRecordList.removeAll()
//            self.filterHarvestRecordList.append(contentsOf: self.harvestRecordList)
//        }
//        else {
//            let filterArr = self.harvestRecordList.filter({ (model) -> Bool in
//                return model.status == self.harvestStatus.rawValue
//            })
//
//            self.filterHarvestRecordList.removeAll()
//            self.filterHarvestRecordList.append(contentsOf: filterArr)
//        }
//
//        self.mainTableView.reloadData()
//    }
