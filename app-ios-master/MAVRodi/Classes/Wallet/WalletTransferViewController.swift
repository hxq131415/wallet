//
//  WalletTransferViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  转账

import UIKit

class WalletTransferViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var transferView: WalletTransferContentView = {
        let transferView_ = Bundle.main.loadNibNamed("WalletTransferContentView", owner: nil, options: nil)?.first as! WalletTransferContentView
        return transferView_
    }()
    
    var model: WalletHomeListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xe9eaeb)
        
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
        navBarView.titleLbl.text = model.name! +  MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_navigation_title_key)
        
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
        
        transferView.bottomDescripLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_bottom_info_lbl_text_key)
        
        if model.name == "Mcoin" {
            let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
            constRightLbl.configLabel(text: "MCOIN", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
            constRightLbl.sizeToFit()
            transferView.numTextField.rightView = constRightLbl
            transferView.numTextField.rightViewMode = .always
            transferView.numTextField.keyboardType = .numberPad
            transferView.minerView.configMinerViewWithMcoins()
            transferView.balanceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_balance_text_key) + "\(model.balance ?? "0")"
        }
        else if model.name == "ETC" {
            let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
            constRightLbl.configLabel(text: "ETC", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
            constRightLbl.sizeToFit()
            transferView.numTextField.rightView = constRightLbl
            transferView.numTextField.rightViewMode = .always
            transferView.numTextField.keyboardType = .decimalPad
            transferView.minerView.configMinerViewWithETC()
            transferView.balanceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_balance_text_key) + "\(String.stringFormatMultiplyingByPowerOf10_18(str: model.balance ?? "") )"
        }
        else if model.name == "ETH" {
            let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
            constRightLbl.configLabel(text: "ETH", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
            constRightLbl.sizeToFit()
            transferView.numTextField.rightView = constRightLbl
            transferView.numTextField.rightViewMode = .always
            transferView.numTextField.keyboardType = .decimalPad
            transferView.minerView.configMinerViewWithETH()
            transferView.balanceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_balance_text_key) + "\(String.stringFormatMultiplyingByPowerOf10_18(str: model.balance ?? "") )"
        }
        
        transferView.qrCodeScanBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                let scanViewCtrl = WBQRCodeVC()
                scanViewCtrl.navTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: MRQRCodeScanPage_navigation_title_key)
                scanViewCtrl.startingPrompt = MRLocalizableStringManager.localizableStringFromTableHandle(key: MRQRCodeScanPage_camora_starting_prompt_key)
                weakSelf.navigationController?.pushViewController(scanViewCtrl, animated: true)
                
                scanViewCtrl.regizerFinishCallBack = { (result) in
                    scanViewCtrl.navigationController?.popViewController(animated: true)
                    weakSelf.transferView.addressTextField.text = result
                }
            }
        }
        
        transferView.confirmBtnTapClosure = {
            self.transferBtnAction()
        }
    }

    // MARK: - Action
    // 转账
    @objc func transferBtnAction() {
        
        guard let address = transferView.addressTextField.text , !address.isEmpty else {
            self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_send_address_empty_prompt_key))
            return
        }

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
                weakSelf.requestForTransfer(pwd: pwd, address: address, amount: amout)
            }
        }
    }
    
    // MARK: - Request
    func requestForTransfer(pwd: String, address: String, amount: String) {
        
        debugPrint("##########原始数据###############")
        debugPrint("gasPrice:\(transferView.minerView.gasPrice)")
        debugPrint("amount:\(amount)")
        debugPrint("pwd:\(pwd)")
        debugPrint("address:\(address)")
        debugPrint("##########END#################")
        
        var params: [String: Any] = [:]
        params["id"] = model.id
        
        if model.name == "Mcoin" {
            params["amount"] = amount
        }
        else {
            let amout_ = NSDecimalNumber(string: amount)
            let newAmount_ = amout_.multiplying(byPowerOf10: 18)
            params["amount"] = newAmount_.stringValue
        }
        params["toAddress"] = address
        params["walletPassword"] = pwd
        
        params["gasPrice"] = transferView.minerView.gasPrice
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_WALLET_TRANSFER, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
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
    
}
