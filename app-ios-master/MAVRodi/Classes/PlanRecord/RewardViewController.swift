//
//  RewardViewController.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/26.
//  Copyright © 2018年 是心作佛. All rights reserved.
//
//  奖励池

import UIKit

class RewardViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    lazy var headerImgView: UIImageView = UIImageView(frame: .zero)
    
    lazy var roundLineView: UIView = UIView(frame: .zero)
    
    lazy var logoImgView: UIImageView = UIImageView(frame: .zero)
    
    lazy var joinBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    lazy var invitationRewardLbl: UILabel = UILabel(frame: .zero)
    lazy var leadershipRewardLbl: UILabel = UILabel(frame: .zero)
    
    var digitalScrollView: XRDigitalScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subViewInitlzation()
        
//        self.requestForCapitalPoolAmount()
//        self.requestForRewardInfoAllAmount()
        
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Intialization
    func subViewInitlzation() {
        
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x193643)
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.bottomLine.isHidden = true
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: RecordPage_navigation_title_key)
        navBarView.backButtonImage = UIImage(named: "icon_back_white")
        navBarView.titleLbl.textColor = UIColor.white
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        headerImgView.image = UIImage(named: "icon_reward_head")
        headerImgView.contentMode = .scaleAspectFit
        self.view.addSubview(headerImgView)
        headerImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(90 * theScaleToiPhone_6)
            make.width.height.equalTo(250 * theScaleToiPhone_6)
        }
        
        roundLineView.frame = CGRect(x: 0, y: 0, width: 175 * theScaleToiPhone_6, height: 175 * theScaleToiPhone_6)
        roundLineView.backgroundColor = UIColor.clear
        roundLineView.layer.cornerRadius = roundLineView.height() / 2
        roundLineView.layer.masksToBounds = true
        roundLineView.layer.borderColor = UIColorFromRGB(hexRGB: 0x30c2b2).cgColor
        roundLineView.layer.borderWidth = 2
        self.view.addSubview(roundLineView)
        roundLineView.snp.makeConstraints { (make) in
            make.width.height.equalTo(175 * theScaleToiPhone_6)
            make.center.equalTo(headerImgView.snp.center)
        }
        
        logoImgView.image = UIImage(named: "iocn_reward_logo")
        logoImgView.contentMode = .scaleAspectFit
        self.view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { (make) in
            make.center.equalTo(headerImgView.snp.center)
            make.width.height.equalTo(140 * theScaleToiPhone_6)
        }
        
        joinBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x33c6b3)
        self.view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints { (make) in
            make.left.equalTo(38 * theScaleToiPhone_6)
            make.right.equalTo(-38 * theScaleToiPhone_6)
            make.height.equalTo(48 * theScaleToiPhone_6)
            make.bottom.equalTo(-(70 * theScaleToiPhone_6 + Main_IndicatorBar_Height))
        }
        
        joinBtn.layer.masksToBounds = true
        joinBtn.layer.cornerRadius = 48 * theScaleToiPhone_6 / 2
        
        joinBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiCapitalPoolPage_bottom_btn_title_key), for: UIControlState.normal)
        joinBtn.addTarget(self, action: #selector(self.joinBtnAction), for: UIControlEvents.touchUpInside)
        
        let MPlanRewardPoolLabel = UILabel()
        MPlanRewardPoolLabel.configLabel(text: "", numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x16a2ac), font: UIFont.systemFont(ofSize: 16))
        self.view.addSubview(MPlanRewardPoolLabel)
        MPlanRewardPoolLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(joinBtn.snp.top).offset(-27)
        }
        MPlanRewardPoolLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: RecordPage_bottom_lbl_text_key)
        
        
        leadershipRewardLbl.configLabel(text: "", numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x16a2ac), font: UIFont.systemFont(ofSize: 16))
        self.view.addSubview(leadershipRewardLbl)
        leadershipRewardLbl.snp.makeConstraints { (make) in
            make.left.equalTo(26 * theScaleToiPhone_6)
            make.right.equalTo(-26 * theScaleToiPhone_6)
            make.bottom.equalTo(MPlanRewardPoolLabel.snp.top).offset(-27)
        }
        
        leadershipRewardLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: RecordPage_leadership_lbl_text_key) + "\(0.000)ETC"
        
        invitationRewardLbl.configLabel(text: "", numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x16a2ac), font: UIFont.systemFont(ofSize: 16))
        self.view.addSubview(invitationRewardLbl)
        invitationRewardLbl.snp.makeConstraints { (make) in
            make.left.equalTo(26 * theScaleToiPhone_6)
            make.right.equalTo(-26 * theScaleToiPhone_6)
            make.bottom.equalTo(leadershipRewardLbl.snp.top).offset(-5)
        }
        
        invitationRewardLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: RecordPage_invitation_lbl_text_key) + "\(0.000)ETC"
        
        let digitalNumStr = "0"
        var digitalWidth: CGFloat = CGFloat(digitalNumStr.count) * 25.0
        var digitalHeight: CGFloat = 40
        digitalScrollView = XRDigitalScrollView(frame: CGRect(x: 0, y: 0, width: digitalWidth, height: 40))
        self.view.addSubview(digitalScrollView)
        
        digitalScrollView.backgroundColor = UIColor.clear
        
        let fitSize = digitalScrollView.setDigitalNumWithNumString(digitalNumStr, textColor: UIColorFromRGB(hexRGB: 0xffffff), textFont: UIFont.boldSystemFont(ofSize: 38))
        digitalWidth = fitSize.width * CGFloat(digitalNumStr.count)
        digitalHeight = fitSize.height
        
        digitalScrollView.snp.makeConstraints { (make) in
            make.width.equalTo(digitalWidth)
            make.height.equalTo(digitalHeight)
            make.top.equalTo(headerImgView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        // layout digitalView 初始化frame
        digitalScrollView.setNeedsLayout()
        digitalScrollView.layoutIfNeeded()
        
        let digitalBottomLbl = UILabel(frame: CGRect.zero)
        self.view.addSubview(digitalBottomLbl)
        digitalBottomLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.digitalScrollView.snp.bottom).offset(10)
            make.centerX.equalTo(self.digitalScrollView)
        }
        
        digitalBottomLbl.configLabel(text: "ETC", numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 16))
        
        if let userInfo = MRCommonShared.shared.userInfo {
            leadershipRewardLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: RecordPage_leadership_lbl_text_key) + "\(userInfo.management_reward)ETC"
            invitationRewardLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: RecordPage_invitation_lbl_text_key) + "\(userInfo.invitation_reward)ETC"
            let totalReward = userInfo.management_reward + userInfo.invitation_reward
            let totalReward_ = String(format: "%d", Int(totalReward))
            let digitalNumStr = "\(totalReward_)"
            var digitalWidth: CGFloat = CGFloat(digitalNumStr.count) * 25.0
            var digitalHeight: CGFloat = 40
            
            let fitSize = self.digitalScrollView.setDigitalNumWithNumString(digitalNumStr, textColor: UIColorFromRGB(hexRGB: 0xffffff), textFont: UIFont.boldSystemFont(ofSize: 38))
            digitalWidth = fitSize.width * CGFloat(digitalNumStr.count)
            digitalHeight = fitSize.height
            
            self.digitalScrollView.frame = CGRect(x: 0, y: 0, width: digitalWidth, height: 40)
            
            self.digitalScrollView.snp.updateConstraints { (make) in
                make.width.equalTo(digitalWidth)
                make.height.equalTo(digitalHeight)
            }
            
            // layout digitalView 初始化frame
            self.digitalScrollView.setNeedsLayout()
            self.digitalScrollView.layoutIfNeeded()
            
            dispatch_after_in_main(0.2, block: {
                // 开始数字滚动
                self.digitalScrollView.beginAnimation()
            })
            
            
        }
    }

    // MARK: - Action
    @objc func joinBtnAction() {
        
        let joinViewCtrl = PlanJoinViewController()
        self.navigationController?.pushViewController(joinViewCtrl, animated: true)
    }
    
    // MARK: - Request
    func requestForCapitalPoolAmount() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_CAPITALPOOL_AMOUNT, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let amount = data as? Int {
//                        let _amount = String.stringFormatMultiplyingByPowerOf10_18(str: String(amount))
//                        let _amount:UInt64 = UInt64(amount)!/100_0000_0000_0000_0000
//                        let _amount:Double = Double(amount)/100_0000_0000_0000_0000
//                        let digitalNumStr = "\(_amount)"
                        let digitalNumStr = "\(amount)"
                        var digitalWidth: CGFloat = CGFloat(digitalNumStr.count) * 25.0
                        var digitalHeight: CGFloat = 40
                        
                        let fitSize = weakSelf.digitalScrollView.setDigitalNumWithNumString(digitalNumStr, textColor: UIColorFromRGB(hexRGB: 0xffffff), textFont: UIFont.boldSystemFont(ofSize: 38))
                        digitalWidth = fitSize.width * CGFloat(digitalNumStr.count)
                        digitalHeight = fitSize.height
                        
                        weakSelf.digitalScrollView.frame = CGRect(x: 0, y: 0, width: digitalWidth, height: 40)
                        
                        weakSelf.digitalScrollView.snp.updateConstraints { (make) in
                            make.width.equalTo(digitalWidth)
                            make.height.equalTo(digitalHeight)
                        }
                        
                        // layout digitalView 初始化frame
                        weakSelf.digitalScrollView.setNeedsLayout()
                        weakSelf.digitalScrollView.layoutIfNeeded()
                        
                        dispatch_after_in_main(0.2, block: {
                            // 开始数字滚动
                            weakSelf.digitalScrollView.beginAnimation()
                        })
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
    func requestForRewardInfoAllAmount() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_REWARDRECORDFOALL_AMOUNT, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    //此处有问题，暂时弃用
                    if let amount = data as? Int {
                        
                        let digitalNumStr = "\(amount)"
                        var digitalWidth: CGFloat = CGFloat(digitalNumStr.count) * 25.0
                        var digitalHeight: CGFloat = 40
                        
                        let fitSize = weakSelf.digitalScrollView.setDigitalNumWithNumString(digitalNumStr, textColor: UIColorFromRGB(hexRGB: 0xffffff), textFont: UIFont.boldSystemFont(ofSize: 38))
                        digitalWidth = fitSize.width * CGFloat(digitalNumStr.count)
                        digitalHeight = fitSize.height
                        
                        weakSelf.digitalScrollView.frame = CGRect(x: 0, y: 0, width: digitalWidth, height: 40)
                        
                        weakSelf.digitalScrollView.snp.updateConstraints { (make) in
                            make.width.equalTo(digitalWidth)
                            make.height.equalTo(digitalHeight)
                        }
                        
                        // layout digitalView 初始化frame
                        weakSelf.digitalScrollView.setNeedsLayout()
                        weakSelf.digitalScrollView.layoutIfNeeded()
                        
                        dispatch_after_in_main(0.2, block: {
                            // 开始数字滚动
                            weakSelf.digitalScrollView.beginAnimation()
                        })
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
