//
//  PlanConfirmHarvestViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/17.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  收获排单

import UIKit
import ObjectMapper

class PlanConfirmHarvestViewController: MRBaseViewController , PlanJoinContentViewDelegate {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    lazy var contentView: PlanJoinContentView = PlanJoinContentView(frame: CGRect.zero)
    
    var selectReward: HarvestAmountModel!
    private var mcoinModel: WalletHomeListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestForWalletList(isPullToRefresh: false)
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xF5F5F5)
        self.subViewInitlzation()
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanConfirmHarvest_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(332 * theScaleToiPhone_6)
            make.height.equalTo(455 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.navBarView.snp.bottom).offset(25)
        }
        
        
        contentView.amountLeftLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanConfirmHarvest_amount_left_lblinput_max_amou_text_key)
        contentView.backgroundColor = UIColor.white
        contentView.cornerRadius = 8
        contentView.delegate = self
        
        let maxTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanConfirmHarvest_input_max_amout_title_key)
        contentView.amountTextField.placeholder = "\(maxTitle)\(selectReward.availableQuantity)"
        contentView.minerView.configMinerViewWithMcoins()
        
        contentView.joinBtnTapClosure = {
            self.joinBtnAction()
        }
        
        contentView.joinBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanConfirmHarvest_bottom_btn_title_key), for: UIControlState.normal)
        contentView.joinBtn.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0x33c6b3)), for: UIControlState.normal)
        //PlanJoinRecordDetailsPage_wait_package_bottom_btn_title_key 等待打包
        contentView.joinBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanConfirmHarvest_bottom_btn_title_key), for: UIControlState.disabled)
        contentView.joinBtn.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0x7e7e7e)), for: UIControlState.disabled)
        contentView.joinBtn.isEnabled = false
        
        contentView.bottomLbl.isHidden = true
    }
    
    // MARK: - Action
    @objc func joinBtnAction() {
        
        guard let amount_ = contentView.amountTextField.text?.toDouble() else {
            self.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_input_amount_empty_prompt_key))
            return
        }
        //密码页面
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
                weakSelf.requestForHevest(pwd: pwd, amount: amount_)
            }
        }
        
    }
    
    // MARK: - Request
    func requestForHevest(pwd: String, amount: Double) {
        
        var params: [String: Any] = [:]
        params["type"] = selectReward.type
        params["amount"] = amount
        params["payPassword"] = pwd
        params["gasPrice"] = contentView.minerView.gasPrice
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_TO_HEARVEST, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("确认收获成功")
                    }
                    //PlanJoinRecordDetailsPage_wait_package_bottom_btn_title_key 等待打包
                    weakSelf.contentView.joinBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_wait_package_bottom_btn_title_key), for: UIControlState.disabled)
                    weakSelf.contentView.joinBtn.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0x7e7e7e)), for: UIControlState.disabled)
                    weakSelf.contentView.joinBtn.isEnabled = false
                    
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
    
    // MARK: - PlanJoinContentViewDelegate
    func amoutInputChanged(text: String?) {

        if let amout = text?.toDouble() {
            if amout > 0 && amout <= selectReward.availableQuantity {
                contentView.joinBtn.isEnabled = true
            }
            else {
                contentView.joinBtn.isEnabled = false
            }
        }
        else {
            contentView.joinBtn.isEnabled = false
        }
    }
    
    //MARK: - 获取余额
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
                        
                        if let dataArr = dict["list"] as? [[String: Any]] {
                            let dataList = Mapper<WalletHomeListModel>().mapArray(JSONArray: dataArr)
                            let mcoinList = dataList.filter({ (model) -> Bool in
                                return model.name == "Mcoin"
                            })
                            if mcoinList.count > 0 {
                                weakSelf.mcoinModel = mcoinList.first
                                let balanceText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_balance_text_key) + (weakSelf.mcoinModel?.balance ?? "0")
                                weakSelf.contentView.balanceLbl.text = balanceText
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
