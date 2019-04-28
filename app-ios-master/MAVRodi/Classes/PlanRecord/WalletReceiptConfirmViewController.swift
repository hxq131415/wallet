//
//  WalletReceiptConfirmViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/12.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  收获确认

import UIKit

private let defaultTradingFee: Double = 0.01

class WalletReceiptConfirmViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var contentView: WalletReceiptConfirmContentView = {
        let contentView_ = WalletReceiptConfirmContentView(frame: CGRect.zero)
        return contentView_
    }()
    
    // 收获记录
    var harvestRecordModel: PlanHarvestRecordListModel?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = MRColorManager.ViewControllerLightGrayBackgroundColor
        
        self.subViewInitialization()
    }
    
    override func popWithAnimate() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override var statusBarBackgroundColor: UIColor? {
        return MRColorManager.StatusBarBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Intialization
    func subViewInitialization() {
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.bottomLine.isHidden = true
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptConfirm_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(332 * theScaleToiPhone_6)
            make.height.equalTo(455 * theScaleToiPhone_6)
            make.top.equalTo(self.navBarView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
//        let title1 = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptConfirm_total_amout_left_title_key)
        
        contentView.amountTextField.text = String(format: "%.6f", self.harvestRecordModel?.amount ?? 0)
        self.calculateMCOIN()
        
        
//        let title2 = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptConfirm_trading_fee_left_title_key)
//        contentView.tradingFeeLbl.text = String(format: "%@      %.2fETC", title2, defaultTradingFee)
        
//        let realAmount: Double = harvestRecordModel!.amount - defaultTradingFee
//        contentView.constTextField.text = String(format: "%.6f ETC", realAmount)
        
        contentView.confirmBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.requestForConfirmReceipt(record: weakSelf.harvestRecordModel!)
            }
        }
    }
    
    func calculateMCOIN(){
        if let amout = contentView.amountTextField.text?.toDouble() {
            // 计算消耗的MCOIN
            if let entryFee = MRCommonShared.shared.config?.entryFee {
                var costAmount = amout * entryFee / 100.0
                
                if costAmount < 1 {
                    costAmount = 1.0
                }
                
                let decimal = NSDecimalNumber.roundingDoubleValueWithScale(scale: 0, doubleValue: costAmount)
                
                contentView.constTextField.text = String(format: "%d", Int(decimal))
            }
            else {
                contentView.constTextField.text = String(format: "%d", 0)
            }
        }
        else {
            contentView.constTextField.text = String(format: "%d", 0)
        }
    }
    // 确认收获(进场)
    func requestForConfirmReceipt(record: PlanHarvestRecordListModel) {
        
        var params: [String: Any] = [:]
        params["id"] = record.id
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
//        MR_REQ_CODE_PLAN_CONFIRM_HARVEST目前没确定？
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_CONFIRM_RECEIPT, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("收款成功")
                    }
                    weakSelf.popWithAnimate()
//                    let receiptConfirmCtrl = WalletReceiptConfirmViewController()
//                    receiptConfirmCtrl.harvestRecordModel = record
//                    weakSelf.navigationController?.pushViewController(receiptConfirmCtrl, animated: true)
                }
                else {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("收款失败")
                    }
                }
            }
        }
    }
}
