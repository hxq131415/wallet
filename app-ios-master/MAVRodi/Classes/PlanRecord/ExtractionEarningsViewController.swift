//
//  ExtractionEarningsViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/26.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  提取收益

import UIKit

class ExtractionEarningsViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    lazy var contentView: ExtractEarningsContentView = ExtractEarningsContentView(frame: CGRect.zero)
    
    private var joinBtn: UIButton = {
        let joinBtn_ = UIButton(type: UIButtonType.custom)
        return joinBtn_
    }()
    
    // 需要提取的收益
    var selectReward: HarvestAmountModel!
    
    private var amount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x061c69)
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExtractionEanringsPage_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        let bottomBackImgVw = UIImageView(frame: CGRect.zero)
        self.view.addSubview(bottomBackImgVw)
        bottomBackImgVw.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(Main_Screen_Width / 765.0 * 629.0)
        }
        
        bottomBackImgVw.image = UIImage(named: "icon_pool_bg")
        
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(317 * theScaleToiPhone_6)
            make.height.equalTo(297)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.navBarView.snp.bottom).offset(25)
        }
        
        contentView.backgroundColor = UIColor.white
        contentView.cornerRadius = 8
        
        contentView.amountTextField.text = String(format: "%.4f", selectReward.amount)
        
        contentView.amountInputFinishClosure = { [weak self](amount) in
            if let weakSelf = self {
                weakSelf.amount = amount
                
            }
        }
        
        self.view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints { (make) in
            make.width.equalTo(317 * theScaleToiPhone_6)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.contentView.snp.bottom).offset(40 * theScaleToiPhone_6)
        }
        
        joinBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: ExtractionEanringsPage_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xffffff), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x365ad8))
        joinBtn.layer.masksToBounds = true
        joinBtn.layer.cornerRadius = 8
        
        joinBtn.addTarget(self, action: #selector(self.joinBtnAction), for: UIControlEvents.touchUpInside)
        
        let bottomLbl = UILabel(frame: CGRect.zero)
        self.view.addSubview(bottomLbl)
        bottomLbl.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(10)
            make.height.greaterThanOrEqualTo(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30 - Main_IndicatorBar_Height)
        }
        
        bottomLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_bottom_investment_text_key), textAlignment: .center, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
    }
    
    // MARK: - Action
    // 提取收益
    @objc func joinBtnAction() {
        
        self.view.endEditing(true)
        
        guard let amount_ = self.contentView.amountTextField.text?.toDouble() else {
            self.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExtractionEanringsPage_amount_empty_prompt_text_key))
            return
        }
        
        guard let pwd = contentView.passwordTextField.text, !pwd.isEmpty else {
            self.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_input_paypwd_empty_prompt_key))
            return
        }
        
        self.requestForHarvest(amount: amount_, pwd: pwd)
    }
    
    // 提取
    func requestForHarvest(amount: Double, pwd: String) {
        
        var params: [String: Any] = [:]
        params["type"] = selectReward.type
        params["amount"] = amount
        params["payPassword"] = pwd
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_TO_HEARVEST, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("提取成功")
                    }
                    
                    if let strongSelf = self {
                        dispatch_after_in_main(1, block: {
                            strongSelf.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
                else {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("提取失败")
                    }
                }
            }
        }
    }

}
