//
//  WalletTransferConfirmViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/11.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  转款确认

import UIKit

class WalletTransferConfirmViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var contentView: WalletTradingConfirmContentView = {
        let contentView_ = WalletTradingConfirmContentView(frame: CGRect.zero)
        return contentView_
    }()
    
    // 参与记录
    var joinRecordModel: PlanJoinRecordListModel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xe9eaeb)
        
        self.subViewInitialization()
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferConfirm_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        let bottomImageVw = UIImageView(frame: CGRect.zero)
        self.view.addSubview(bottomImageVw)
        bottomImageVw.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(Main_Screen_Width / 765.0 * 475.0)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        bottomImageVw.image = UIImage(named: "icon_trading_bg")
        
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(317 * theScaleToiPhone_6)
            make.height.equalTo(418)
            make.top.equalTo(self.navBarView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        contentView.titleLbl1.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferConfirm_left_transfer_amount_text_key)
        contentView.titleLbl2.isHidden = false
        contentView.titleLbl2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferConfirm_reminder_text_key)
        contentView.constTextField.text = String(format: "%.6f ETC", self.joinRecordModel?.amount ?? 0)
        contentView.confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferConfirm_bottom_btn_title_key), for: UIControlState.normal)
        
        
        if joinRecordModel.joinStatusType == .waitCheck {
            contentView.confirmBtn.isEnabled = false
            contentView.confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_wait_package_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e))
        }
        else {
            contentView.confirmBtn.isEnabled = true
            contentView.confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferConfirm_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 18), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x365ad8))
        }
        
        // ETC 矿工费
        contentView.minerFeeView.configMinerViewWithETC()
        
        contentView.confirmBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                let enterPwdCtrl = WalletEnterPasswordAlertController()
                enterPwdCtrl.modalPresentationStyle = .overFullScreen
                
                weakSelf.present(enterPwdCtrl, animated: false) {
                    enterPwdCtrl.showAlert()
                }
                
                enterPwdCtrl.hideAlertViewClosure = { [weak self] in
                    if let weakSelf = self {
                        weakSelf.resetStatusBarBackgroundColor()
                    }
                }
                
                enterPwdCtrl.enterPwdFinishClosure = { [weak self](pwd) in
                    if let weakSelf = self {
                        weakSelf.resetStatusBarBackgroundColor()
                        weakSelf.requestForConfirmTransfer(pwd: pwd)
                    }
                }
            }
        }
    }
    
    // MARK: - Request
    // 确认转款
    func requestForConfirmTransfer(pwd: String) {
        
        var params: [String: Any] = [:]
        params["id"] = self.joinRecordModel?.id
        params["payPassword"] = pwd
        
        params["gasPrice"] = contentView.minerFeeView.gasPrice
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_CONFIRM_TRANSFER, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("转款成功")
                    }
                    
                    weakSelf.contentView.confirmBtn.isEnabled = false
                    weakSelf.contentView.confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_wait_package_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e))
                    
                    dispatch_after_in_main(1, block: {
                        self?.navigationController?.popToRootViewController(animated: true)
                    })
                }
                else {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("转款失败")
                    }
                }
            }
        }
        
    }
    
}
