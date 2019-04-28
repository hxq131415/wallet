//
//  MavrodiPlanRowPoolViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/14.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  排单池--参与矿池

import UIKit

private let kRotationAnimationKey: String = "kRotationAnimationKey"
private let kRotationAnimationKeyPath: String = "transform.rotation"

class MavrodiPlanRowPoolViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var joinBtn: UIButton = {
        let joinBtn_ = UIButton(type: UIButtonType.custom)
        return joinBtn_
    }()
    
    private var introPlanBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    private var centerImgVw: UIImageView = {
        let imgVw = UIImageView(frame: CGRect.zero)
        return imgVw
    }()
    
    var waveView: XRWaveView!
    var digitalScrollView: XRDigitalScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x193745)
        self.subViewInitlzation()
        self.requestForRowPoolAmount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addRotationAnimationToView(targetView: centerImgVw)
        waveView.beginWave()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeRotationAnimation(targetView: centerImgVw)
        waveView.endWave()
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiPlanRowPoolPage_navigation_title_key)
        navBarView.backButtonImage = UIImage(named: "icon_back_white")
        navBarView.titleLbl.textColor = UIColor.white
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        centerImgVw = UIImageView(frame: CGRect.zero)
        self.view.addSubview(centerImgVw)
        centerImgVw.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp.bottom).offset(48 * theScaleToiPhone_6)
            make.width.height.equalTo(279 * theScaleToiPhone_6)
            make.centerX.equalToSuperview()
        }
        
        centerImgVw.backgroundColor = UIColor.clear
        centerImgVw.image = UIImage(named: "icon_plan_pool_rotation")
        
        waveView = XRWaveView(frame: CGRect.zero)
        self.view.addSubview(waveView)
        waveView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.centerImgVw.snp.centerX).offset(0)
            make.centerY.equalTo(self.centerImgVw.snp.centerY).offset(0)
            make.height.width.equalTo(175 * theScaleToiPhone_6)
        }
        
        waveView.backWaveColor = UIColorFromRGB(hexRGB: 0x18a4ac)
        waveView.foreWaveColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
        
        waveView.isNeedRise = true
        waveView.wavePercent = 0.1
        
        waveView.backgroundColor = self.view.backgroundColor
        waveView.layer.masksToBounds = true
        waveView.layer.cornerRadius = 175 * theScaleToiPhone_6 * 0.5
        waveView.layer.borderColor = UIColorFromRGB(hexRGB: 0x18a4ac).cgColor
        waveView.layer.borderWidth = 2.0;
    
        navBarView.superview?.bringSubview(toFront: navBarView)
        centerImgVw.superview?.bringSubview(toFront: centerImgVw)
        waveView.superview?.bringSubview(toFront: waveView)
        
        self.view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints { (make) in
            make.left.equalTo(38 * theScaleToiPhone_6)
            make.right.equalTo(-38 * theScaleToiPhone_6)
            make.height.equalTo(48 * theScaleToiPhone_6)
            make.bottom.equalTo(-71 * theScaleToiPhone_6)
        }
        
        joinBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x2abbb0)
        joinBtn.layer.masksToBounds = true
        joinBtn.layer.cornerRadius = 48 * theScaleToiPhone_6 / 2
         joinBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiPlanRowPoolPage_bottom_btn_title_key), for: UIControlState.normal)
        joinBtn.addTarget(self, action: #selector(self.joinBtnAction), for: UIControlEvents.touchUpInside)
        
        let digitalNumStr = "0"
        var digitalWidth: CGFloat = CGFloat(digitalNumStr.count) * 25.0
        var digitalHeight: CGFloat = 38
        digitalScrollView = XRDigitalScrollView(frame: CGRect(x: 0, y: 0, width: digitalWidth, height: 40))
        self.view.addSubview(digitalScrollView)
        
        digitalScrollView.backgroundColor = UIColor.clear
        
        let fitSize = digitalScrollView.setDigitalNumWithNumString(digitalNumStr, textColor: UIColorFromRGB(hexRGB: 0xf52045), textFont: UIFont.boldSystemFont(ofSize: 24))
        digitalWidth = fitSize.width * CGFloat(digitalNumStr.count)
        digitalHeight = fitSize.height
        
        digitalScrollView.snp.makeConstraints { (make) in
            make.width.equalTo(digitalWidth)
            make.height.equalTo(digitalHeight)
            make.centerY.equalTo(self.waveView.snp.centerY).offset(0)
            make.centerX.equalToSuperview().offset(0)
        }
        
        // layout digitalView 初始化frame
        digitalScrollView.setNeedsLayout()
        digitalScrollView.layoutIfNeeded()
        
        let rightLbl = UILabel(frame: CGRect.zero)
        self.view.addSubview(rightLbl)
        rightLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.digitalScrollView.snp.centerX).offset(0)
            make.top.equalTo(self.digitalScrollView.snp.bottom).offset(10)
            make.width.greaterThanOrEqualTo(10)
            make.height.greaterThanOrEqualTo(10)
        }
        
        rightLbl.configLabel(text: "Mcoin", numberOfLines: 1, textAlignment: NSTextAlignment.center, textColor: UIColor.white, font: UIFont.systemFont(ofSize: 16))
        
        let bottomLbl = UILabel(frame: CGRect.zero)
        self.view.addSubview(bottomLbl)
        bottomLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.centerImgVw.snp.bottom).offset(27 * theScaleToiPhone_6)
        }
        
        bottomLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiPlanRowPoolPage_game_reminder_text_key), numberOfLines: 0, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0x16a2ac), font: UIFont.systemFont(ofSize: 14))
        
    }
    
    // 添加旋转动画
    func addRotationAnimationToView(targetView: UIView) {
        
        targetView.layer.removeAnimation(forKey: kRotationAnimationKey)
        
        // add animation
        let rotationAnima = CABasicAnimation(keyPath: kRotationAnimationKeyPath)
        
        rotationAnima.fromValue = 0
        rotationAnima.toValue = Float(-Double.pi * 2)
        rotationAnima.duration = 2.5
        rotationAnima.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotationAnima.repeatCount = HUGE
        rotationAnima.autoreverses = false
        rotationAnima.isRemovedOnCompletion = false
        rotationAnima.fillMode = kCAFillModeForwards
        rotationAnima.beginTime = CACurrentMediaTime()
        
        targetView.layer.add(rotationAnima, forKey: kRotationAnimationKey)
    }
    
    // 移除旋转动画
    func removeRotationAnimation(targetView: UIView) {
        
        targetView.layer.removeAnimation(forKey: kRotationAnimationKey)
    }
    
    // MARK: - Action
    @objc func joinBtnAction() {
        
        let joinViewCtrl = PlanJoinViewController()
        self.navigationController?.pushViewController(joinViewCtrl, animated: true)
    }
    
    // MARK: - Request
    func requestForRowPoolAmount() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_ROWPOOL_AMOUNT, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        if let amount = dict["tg_amount"] as? Double ,
                            let totalAmount = dict["tg_totalAmount"] as? Double {
                            
                            let digitalNumStr = String(format: "%d", Int(amount))
                            var digitalWidth: CGFloat = CGFloat(digitalNumStr.count) * 25.0
                            var digitalHeight: CGFloat = 40
                            
                            let fitSize = weakSelf.digitalScrollView.setDigitalNumWithNumString(digitalNumStr, textColor: UIColorFromRGB(hexRGB: 0xffffff), textFont: UIFont.boldSystemFont(ofSize: 24))
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
                            
                            weakSelf.waveView.isNeedRise = true
                            weakSelf.waveView.wavePercent = CGFloat(amount / totalAmount)
                            
                            dispatch_after_in_main(0.2, block: {
                                // 开始数字滚动
                                weakSelf.digitalScrollView.beginAnimation()
                                weakSelf.waveView.beginWave()
                            })
                            
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
