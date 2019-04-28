//
//  MavrodiPlanBillsViewController.swift
//  MAVRodi
//
//  Created by pan on 2019/2/17.
//  Copyright © 2019 是心作佛. All rights reserved.
//

import UIKit

class MavrodiPlanBillsViewController: MRBaseViewController {
    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var billsVw: MPlanBillsView = {
        let billsVw_ = Bundle.main.loadNibNamed("MPlanBillsView", owner: nil, options: nil)?.first as! MPlanBillsView
        return billsVw_
    }()
    var resetModel: PlanPersonalResetModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xF6FAFB)
        self.subViewInitalzations()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestForGetResetInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.statusBar.backgroundColor = MRColorManager.StatusBarBackgroundColor
        navBarView.bottomLine.isHidden = true
        navBarView.rightButtonImage = UIImage(named: "icon_wh")

//        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_navigation_title_key)
        navBarView.titleLbl.text = "兑换"

        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        // 参与规则
        navBarView.rightButtonClosure = {
#if DEBUG
            self.requestForGetClearReset()
//            if let weakSelf = self {
//                weakSelf.requestForGetClearReset()
//            }
#else
            let title = "保本兑换规则"
            let msg = "根据用户亏损金额，兑换等价的Mcoin，用于保障用户的切身利益\n用户点击兑换重启则所有排单数据清除，可收获资金归零"
            CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: msg) {
                
            }
#endif
        }
        
        
        billsVw.frame = CGRect(x: 19, y:navBarView.frame.maxY, width: Main_Screen_Width-38, height: 435*theScaleToiPhone_6)
        self.view.addSubview(billsVw)
        
        billsVw.getCompensationBtnClosure = { [weak self] in
            //点击兑换
            
            if let weakSelf = self {
                HarvestConfirmAlertView.showHarvestConfirmAlertViewWithDetail(superV: ShareDelegate.window ?? weakSelf.view, title:"量化兑换", detail:"量化兑换，系统会将兑换的Mcoin自动转入个人钱包，然后清除所有投资记录实现量化兑换")
                {
                    weakSelf.requestForGetReset()
                }
                
            }
        }
        
        billsVw.checkExPcoolCallBackClosure = { [weak self] in
            //点击兑换
            
            if let weakSelf = self {
                
                let poolViewCtrl = PlanExchangePoolViewController()
                weakSelf.navigationController?.pushViewController(poolViewCtrl, animated: true)
                
            }
        }
    }
    
    //刷新界面
    func reloadData()
    {
        if(resetModel!.loss_amount <= 0)
        {
            billsVw.frame = CGRect(x: 19, y:navBarView.frame.maxY, width: Main_Screen_Width-38, height: 435*theScaleToiPhone_6)
        }
        else
        {
            billsVw.frame = CGRect(x: 19, y:navBarView.frame.maxY, width: Main_Screen_Width-38, height: 538*theScaleToiPhone_6)

        }
        billsVw.configViewWithModel(model:self.resetModel!)
    }
    
    // MARK: - Request
    // 获取个人重启信息
    func requestForGetResetInfo() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_RESETINFO, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        weakSelf.resetModel = PlanPersonalResetModel(JSON: dict)
                        weakSelf.reloadData()
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
    // 触发兑换
    func requestForGetReset() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_POST_RESET, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    //兑换成功
                    let title = "兑换成功"
                    let msg = "兑换成功，系统将于24小时内将兑换金额拨到个人账户，请稍候。"
                    CustomAlertView.showCustomAlertView(superV: weakSelf.view, title: title, detail: msg) {
                        weakSelf.billsVw.getCompensationBtn.isEnabled = false
                        weakSelf.billsVw.getCompensationBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x2ABBB0), for: UIControl.State.normal)
                        weakSelf.billsVw.getCompensationBtn.setTitle("已兑换", for: UIControl.State.normal)
                        weakSelf.billsVw.getCompensationBtn.backgroundColor = UIColor.white
                        //边框宽度
                        weakSelf.billsVw.getCompensationBtn.layer.borderWidth = 1
                        weakSelf.billsVw.getCompensationBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x2ABBB0).cgColor
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
    // 清空重启记录
    func requestForGetClearReset() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_POST_CLEARRESET, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    //兑换成功
                    let title = "清除兑换成功"
                    let msg = "清除兑换成功，系统将于24小时内回退，请稍候。"
                    CustomAlertView.showCustomAlertView(superV: weakSelf.view, title: title, detail: msg) {
                        weakSelf.billsVw.getCompensationBtn.isEnabled = false
                        weakSelf.billsVw.getCompensationBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x2ABBB0), for: UIControl.State.normal)
                        weakSelf.billsVw.getCompensationBtn.setTitle("已兑换", for: UIControl.State.normal)
                        weakSelf.billsVw.getCompensationBtn.backgroundColor = UIColor.white
                        //边框宽度
                        weakSelf.billsVw.getCompensationBtn.layer.borderWidth = 1
                        weakSelf.billsVw.getCompensationBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x2ABBB0).cgColor
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
