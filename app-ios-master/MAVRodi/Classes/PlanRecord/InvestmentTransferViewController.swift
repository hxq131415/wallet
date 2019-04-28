//
//  InvestmentTransferViewController.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/27.
//  Copyright © 2018年 是心作佛. All rights reserved.
//
//  投资转账页面

import UIKit
import ObjectMapper

class InvestmentTransferViewController: MRBaseViewController {
    
    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var transferView: InvestmentTransferContentView = {
        let transferView_ = Bundle.main.loadNibNamed("InvestmentTransferContentView", owner: nil, options: nil)?.first as! InvestmentTransferContentView
        return transferView_
    }()
    
    var model: WalletHomeListModel!
    var amountTodaymodel: PlanArrivalAmountTodaytModel!
    var transferType:PlanRecordJoinStatus = .waitTransfer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xe9eaeb)
        
        self.requestForWalletList(isPullToRefresh: true)
        self.requestForGetArrivalAmountToday()
        self.subViewInitialization()
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Intialization
    func subViewInitialization() {
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.statusBar.backgroundColor = MRColorManager.StatusBarBackgroundColor
        navBarView.bottomLine.isHidden = true

        if(transferType == .waitTransfer)
        {
            navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: InvestmentTransferPage_navigation_title_key)

        }
        else
        {
            navBarView.titleLbl.text = "抢单转账"
            navBarView.rightButtonImage = UIImage(named: "icon_wh")
            // 参与规则
            navBarView.rightButtonClosure = {
                
                let title = "抢单规则"
                let msg = "所有处理排单的订单可以参与抢单，一个用户一次只能抢一单，抢单成功即为待转款状态，可立即发起转账支付。"
                CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: msg) {
                    
                }
                
            }

        }
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        self.view.addSubview(transferView)
        transferView.snp.makeConstraints { (make) in
            make.width.equalTo(332 * theScaleToiPhone_6)
            make.height.equalTo(455 * theScaleToiPhone_6)
            make.top.equalTo(self.navBarView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        if model.name == "Mcoin" {
            let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
            constRightLbl.configLabel(text: "MCOIN", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
            constRightLbl.sizeToFit()
            transferView.numTextField.rightView = constRightLbl
            transferView.numTextField.rightViewMode = .always
            transferView.numTextField.keyboardType = .numberPad
            transferView.minerView.configMinerViewWithMcoins()
        }
        else if model.name == "ETC" {
            let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
            constRightLbl.configLabel(text: "ETC", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
            constRightLbl.sizeToFit()
//            let str:String = transferView.balanceLabel.text!
//            transferView.balanceLabel.text = str+model.balance!
            transferView.numTextField.text = model.balance
            transferView.numTextField.isUserInteractionEnabled = false
            transferView.numTextField.rightView = constRightLbl
            transferView.numTextField.rightViewMode = .always
            transferView.numTextField.keyboardType = .decimalPad
            transferView.minerView.configMinerViewWithETC()
            
        }
        else if model.name == "ETH" {
            let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
            constRightLbl.configLabel(text: "ETH", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
            constRightLbl.sizeToFit()
            transferView.numTextField.rightView = constRightLbl
            transferView.numTextField.rightViewMode = .always
            transferView.numTextField.keyboardType = .decimalPad
//            transferView.minerView.configMinerViewWithETH()
            transferView.minerView.configMinerViewWithETC()
        }
        
        transferView.confirmBtnTapClosure = {
            self.transferBtnAction()
        }
    }
    
    // MARK: - Action
    // 转账
    @objc func transferBtnAction() {
        
        guard let amout = transferView.numTextField.text , !amout.isEmpty else {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_trs_amount_empty_prompt_key))
            return
        }
        
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
                weakSelf.requestForTransfer(pwd: pwd, amount: amout)
            }
        }
    }
    
    // MARK: - Request
    func requestForTransfer(pwd: String, amount: String) {
        
        var params: [String: Any] = [:]
        params["id"] = model.id
        
//        if model.name == "Mcoin" {
//            params["amount"] = amount
//        }
//        else {
//            let amout_ = NSDecimalNumber(string: amount)
//            let newAmount_ = amout_.multiplying(byPowerOf10: 18)
//            params["amount"] = newAmount_.stringValue
//        }
        params["payPassword"] = pwd
        
        params["gasPrice"] = transferView.minerView.gasPrice
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_CONFIRM_TRANSFER, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage("转账成功")
                    }
                    
                    dispatch_after_in_main(1, block: {
                        weakSelf.popWithAnimate()
                    })
                }
                else {
                    if let errMsg = message , !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage("转账失败")
                    }
                }
            }
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
                            let ETCList = dataList.filter({ (model) -> Bool in
                                return model.name == "ETC"
                            })
                            if ETCList.count > 0 {
//                                weakSelf.model = ETCList.first
                                var tempmodel = WalletHomeListModel()
                                tempmodel = ETCList.first!
                                let str:String = weakSelf.transferView.balanceLabel.text!
                                let balance = String.stringFormatMultiplyingByPowerOf10_18(str: tempmodel.balance ?? "")
                                weakSelf.transferView.balanceLabel.text = str+balance
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
    // MARK: - Request
    // 获取每日入场限额和当日平台入场资金总额
    func requestForGetArrivalAmountToday() {
        if let userInfo = MRCommonShared.shared.userInfo{
            let userId = userInfo.user_id
            TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
            var params: [String: Any] = [:]
            params["id"] = userId
            TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_ARRIVAL_AMOUNT_TODAY, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
                if let weakSelf = self {
                    TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                    if status == 0 {
                        if let dict = data as? [String: Any] {
                            weakSelf.amountTodaymodel = PlanArrivalAmountTodaytModel(JSON: dict)
                            weakSelf.transferView.todayTopLabel.text = "今日金额上限："+weakSelf.amountTodaymodel.todayTop!+"ETC"
                            weakSelf.transferView.todayInputLabel.text = "今日进场金额："+weakSelf.amountTodaymodel.todayInput!+"ETC"
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
