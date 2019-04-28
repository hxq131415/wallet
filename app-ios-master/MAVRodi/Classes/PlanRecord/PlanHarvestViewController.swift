//
//  PlanRewardViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/10.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  收获

import UIKit

class PlanHarvestViewController: MRBaseViewController,PlanHarvestViewCellDelegate,PlanHarvestAmountViewCellDelegate, UITableViewDelegate,UITableViewDataSource {
    
    func applyTipClick(indexPath: IndexPath) {
        CustomTipAlertView.showCustomTipAlertView(superV: self.view) {
        }
    }
    
    func applyButtonClick(indexPath: IndexPath) {
        guard let rewardModel = harvestRewardModel else {
            return
        }
        if indexPath.section == 0 {
            if rewardModel.gameReward != nil {
                if(harvestRewardModel?.gameReward?.amount == 0){
//                    let message = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_UserCenter_developing_prompt_text_key)
                    self.showBottomMessage("没有可提现额度！")
                }
                else
                {
                    confirmHarvestBtnAction(reward: rewardModel.gameReward!)
                }
                
            }
        }
        else if indexPath.section == 1 {
            if rewardModel.shareReward != nil {
                
                if(harvestRewardModel?.shareReward?.amount == 0){
//                    let message = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_UserCenter_developing_prompt_text_key)
                    self.showBottomMessage("没有可提现额度！")
                }
                else
                {
                    confirmHarvestBtnAction(reward: rewardModel.shareReward!)
                }
            }
        }
        else if indexPath.section == 2 {
            if rewardModel.teamReward != nil {
                if(harvestRewardModel?.teamReward?.amount == 0){
//                    let message = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_UserCenter_developing_prompt_text_key)
                    self.showBottomMessage("没有可提现额度！")
                }
                else
                {
                    requestForGetLeaderBonusStatus()
                }
                
//                confirmHarvestBtnAction(reward: rewardModel.teamReward!)
            }
        }else if indexPath.section == 3 {
            if rewardModel.teamReward != nil {
                if(harvestRewardModel?.quantifiedRewards?.amount == 0){
                    //                    let message = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_UserCenter_developing_prompt_text_key)
                    self.showBottomMessage("没有可提现额度！")
                }
                else
                {
                    requestForGetLeaderBonusStatus()
                }
                
                //                confirmHarvestBtnAction(reward: rewardModel.teamReward!)
            }
        }
        else {
            if rewardModel.sysReward != nil {
                confirmHarvestBtnAction(reward: rewardModel.sysReward!)
            }
        }
    }
    func applyButton2Click(indexPath: IndexPath) {
#if DEBUG
        if(frozenBonus == 0)
        {
//                    let message = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_UserCenter_developing_prompt_text_key)
            self.showBottomMessage("没有可赎回额度！")
        }
        else
        {
            let unfreezeViewCtrl = PlanUnfreezeJoinViewController()
            self.navigationController?.pushViewController(unfreezeViewCtrl, animated: true)
        }
        

#else
        let message = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_UserCenter_developing_prompt_text_key)
        self.showBottomMessage(message)
#endif
        
        
    }

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    lazy var bottomLbl: UILabel = UILabel(frame: CGRect.zero)
    
    var harvestRewardModel: PlanHarvestAmountModel?
    var leaderBonusModel:PlanHarvestLeaderBonusModel?
    var frozenBonus:Double = 0.0
    private var selectReward: HarvestAmountModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xF5F5F5)
        self.subViewInitlzation()
        
//        self.requestForGetHarvestAmount()
//        self.requestForGetFrozenBonuses()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestForGetHarvestAmount()
//        self.requestForGetFrozenBonuses()
     
    }
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.black
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(navBarView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = UIColor.clear
        mainTableView.backgroundColor = UIColorFromRGB(hexRGB: 0xF5F5F5)
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        mainTableView.register(UINib(nibName: "PlanHarvestViewCell", bundle: nil), forCellReuseIdentifier: "PlanHarvestViewCell")
        mainTableView.register(UINib.init(nibName: "PlanHarvestAmountViewCell", bundle: nil), forCellReuseIdentifier: "PlanHarvestAmountViewCell")

        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        bottomLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_footer_view_text_key)
        bottomLbl.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width - 40, height: 30)
        bottomLbl.textColor = UIColorFromRGB(hexRGB: 0xAAAAAA)
        bottomLbl.font = UIFont.systemFont(ofSize: 10)
        bottomLbl.numberOfLines = 0
        let footeView = UIView(frame: CGRect(x: 20, y: 0, width: Main_Screen_Width - 40, height: 30))
        
        let string = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_footer_view_text_key)
        
        let dic = NSDictionary(object: bottomLbl.font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let size = string.boundingRect(with: CGSize(width: bottomLbl.frame.width, height: 8000), options: .usesLineFragmentOrigin, attributes:  dic as? [NSAttributedStringKey : AnyObject], context: nil)
        var autoRect = bottomLbl.frame
        autoRect.size.height = size.height
        bottomLbl.frame = autoRect
        
        footeView.addSubview(bottomLbl)
        self.mainTableView.tableFooterView = footeView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PlanHarvestViewCell", for: indexPath) as? PlanHarvestViewCell {
                
                cell.delegate = self
                if indexPath.section == 0 {
                    
                    if let amount = harvestRewardModel?.gameReward?.amount {
                        
                        cell.configCell(price: String(format: "%.6f", amount), indexPath: indexPath, model: harvestRewardModel!)
                    }
                }
                else if indexPath.section == 1 {
                    //                if(frozenBonus == 0){
                    //                    if let amount = harvestRewardModel?.shareReward?.amount {
                    //
                    //                        cell.configCell(price: String(format: "%.6f", amount), indexPath: indexPath, model: harvestRewardModel!)
                    //                    }
                    //                }
                    //                else
                    //                {
                    if let amount = harvestRewardModel?.shareReward?.amount {
                        cell.configCellForFrozen(price: String(format: "%.6f", amount), indexPath: indexPath, model: harvestRewardModel!, frozenBonus:String(format: "%.6f", frozenBonus))
                    }
                    //                }
                    
                }
                else if indexPath.section == 2 {
                    if let amount = harvestRewardModel?.teamReward?.amount {
                        
                        cell.configCell(price: String(format: "%.6f", amount), indexPath: indexPath, model: harvestRewardModel!)
                    }
                }
                else {
                    
                    if let amount = harvestRewardModel?.shareReward?.amount {
                        cell.configCellForFrozen(price: String(format: "%.6f", amount), indexPath: indexPath, model: harvestRewardModel!, frozenBonus:String(format: "%.6f", frozenBonus))
                    }
                    
                }
                cell.selectionStyle = .none
                
                return cell
            }
            
        }else if indexPath.section == 3 {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "PlanHarvestAmountViewCell", for: indexPath)) as! PlanHarvestAmountViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            if let amount = harvestRewardModel?.quantifiedRewards?.amount {
                let available = harvestRewardModel?.quantifiedRewards?.availableQuantity
                cell.configCell(price: String(format: "%.6f", amount),available: String(format: "%.6f",available!), indexPath: indexPath, model: harvestRewardModel!)
            }
            
            return cell
            
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        return
//        guard let rewardModel = harvestRewardModel else {
//            return
//        }
//        if indexPath.section == 0 {
//            if rewardModel.gameReward != nil {
//                confirmHarvestBtnAction(reward: rewardModel.gameReward!)
//            }
//        }
//        else if indexPath.section == 1 {
//            if rewardModel.shareReward != nil {
//                confirmHarvestBtnAction(reward: rewardModel.shareReward!)
//            }
//        }
//        else if indexPath.section == 2 {
//            if rewardModel.teamReward != nil {
//                confirmHarvestBtnAction(reward: rewardModel.teamReward!)
//            }
//        }
//        else {
//            if rewardModel.sysReward != nil {
//                confirmHarvestBtnAction(reward: rewardModel.sysReward!)
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 140
        }
        return 93
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        }
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 {
            return 22
        }
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: - Action
    // 确认收获
    @objc func confirmHarvestBtnAction(reward: HarvestAmountModel) {
        
        let harvestViewCtrl = PlanConfirmHarvestViewController()
        harvestViewCtrl.selectReward = reward
        self.navigationController?.pushViewController(harvestViewCtrl, animated: true)
    }
    
    // MARK: - Request
    // 获取金额信息
    func requestForGetHarvestAmount() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_HARVEST_AMOUNT, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
//                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                weakSelf.requestForGetFrozenBonuses()
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        weakSelf.harvestRewardModel = PlanHarvestAmountModel(JSON: dict)
                    }
//                    weakSelf.mainTableView.reloadData()
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
    // MARK: - Request
    // 获取冻结金额信息
    func requestForGetFrozenBonuses() {
        if let userInfo = MRCommonShared.shared.userInfo{
            let userId = userInfo.user_id
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
            var params: [String: Any] = [:]
            params["id"] = userId
            TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_FROZEN_BONUSES, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
                if let weakSelf = self {
                    TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                    if status == 0 {
                        if let dict = data as? String {
                            weakSelf.frozenBonus = Double(dict)!
                            print("冻结金额：%.4f",weakSelf.frozenBonus)
                        }
                        weakSelf.mainTableView.reloadData()
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
    }
    
    // MARK: - Request
    // 检查是否允许收获领导奖金信息getLeaderBonusStatus
    func requestForGetLeaderBonusStatus() {
        
        if let userInfo = MRCommonShared.shared.userInfo{
            let userId = userInfo.user_id
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
            var params: [String: Any] = [:]
            params["id"] = userId
            TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_LEADER_BONUSES_STATUS, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
                if let weakSelf = self {
                    TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                    if status == 0 {
                        if let dict = data as? [String: Any] {
                            weakSelf.leaderBonusModel = PlanHarvestLeaderBonusModel(JSON: dict)
                            if(!(weakSelf.leaderBonusModel?.is_Permitted)!)
                            {
                                guard let rewardModel = weakSelf.harvestRewardModel else {
                                    return
                                }
                                weakSelf.confirmHarvestBtnAction(reward: rewardModel.teamReward!)
                            }
                            else
                            {
                                //弹框提示禁止收获
                                let last_time = Date(timeIntervalSince1970: (weakSelf.leaderBonusModel?.last_time)!)
                                let last_timeDateStr = last_time.dateStringFromDate(formatString: "MM-dd")
                                let last_timeText = last_time.dateStringFromTime(formatString: "HH:mm")
                                
                                let next_time = Date(timeIntervalSince1970: (weakSelf.leaderBonusModel?.next_time)!)
                                let next_timeDateStr = next_time.dateStringFromDate(formatString: "MM-dd")
                                let next_timeText = next_time.dateStringFromTime(formatString: "HH:mm")
                                
                                CustomAlertView1.showCustomAlertView1(superV: weakSelf.view, lastTime: last_timeDateStr!+" "+last_timeText!, nextTime: next_timeDateStr!+" "+next_timeText!) {
                                    
                                }
                            }
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
    }
}
