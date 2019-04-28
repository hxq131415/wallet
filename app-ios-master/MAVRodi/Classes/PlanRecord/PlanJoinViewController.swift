//
//  PlanJoinViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/10.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  参与排单

import UIKit
import ObjectMapper

class PlanJoinViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    lazy var contentView: PlanJoinContentView = PlanJoinContentView(frame: CGRect.zero)
    
    private var mcoinModel: WalletHomeListModel?
    
    private var joinBtn: UIButton = {
        let joinBtn_ = UIButton(type: UIButtonType.custom)
        return joinBtn_
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xF5F5F5)
        self.subViewInitlzation()
        self.requestForWalletList(isPullToRefresh: true)
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_navigation_title_key)
        
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
            make.top.equalTo(self.navBarView.snp.bottom).offset(10)
        }
        
        contentView.backgroundColor = UIColor.white
        contentView.cornerRadius = 8
        contentView.amountTextField.keyboardType = .numberPad
        
        contentView.minerView.configMinerViewWithMcoins()
        
        let balanceText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_balance_text_key) + "0.00"
        contentView.balanceLbl.text = balanceText
            
        contentView.joinBtnTapClosure = {
            
            self.joinBtnAction()
        }
        // 预约排单
        contentView.bottomLblTapClosure = {
            
            let planOrder = PlanOrderViewController()
            self.pushToViewController(viewCtrl: planOrder)
        }
        
        
    }
    
    // MARK: - Action
    @objc func joinBtnAction() {
        
        self.view.endEditing(true)
        
        guard let amount_ = self.contentView.amountTextField.text?.toDouble() else {
            self.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_input_amount_empty_prompt_key))
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
                weakSelf.requestForJoin(amout: amount_, pwd: pwd)
            }
        }
        
    }
    
    // MARK: - Request
    // 参与排单
    func requestForJoin(amout: Double, pwd: String) {
        
        var params: [String: Any] = [:]
        params["amount"] = amout
        params["payPassword"] = pwd
        params["gasPrice"] = contentView.minerView.gasPrice
        params["type"] = 2
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_TO_JOIN, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("参与成功")
                    }
                    
                    weakSelf.joinBtn.isEnabled = false
                    weakSelf.joinBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_wait_package_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e))
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, qos: DispatchQoS.default, flags: DispatchWorkItemFlags(rawValue: 0), execute: {
                        weakSelf.popWithAnimate()
                    })
                }
                else {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("参与失败")
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
