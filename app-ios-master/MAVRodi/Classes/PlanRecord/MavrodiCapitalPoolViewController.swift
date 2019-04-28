//
//  MavrodiCapitalPoolViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/11.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  资金池

import UIKit

private let kRotationAnimationKey: String = "kRotationAnimationKey"
private let kRotationAnimationKeyPath: String = "transform.rotation"

class MavrodiCapitalPoolViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var confirmBtn: UIButton = {
        let confirmBtn_ = UIButton(type: UIButtonType.custom)
        return confirmBtn_
    }()
    
    private var introPlanBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    private var harvestBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    private var centerImgVw: UIImageView = {
        let imgVw = UIImageView(frame: CGRect.zero)
        return imgVw
    }()
    
    var digitalScrollView: XRDigitalScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer .masksToBounds = true
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x193745)
        self.subViewInitlzation()
        
        self.requestForCapitalPoolAmount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiCapitalPoolPage_navigation_title_key)
        navBarView.backButtonImage = UIImage(named: "icon_back_white")
        navBarView.titleLbl.textColor = UIColor.white
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        centerImgVw.contentMode = .scaleAspectFit
        self.view.addSubview(centerImgVw)
        centerImgVw.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBarView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        centerImgVw.image = UIImage(named: "icon_capital_center_img")
        
        navBarView.superview?.bringSubview(toFront: navBarView)
        centerImgVw.superview?.bringSubview(toFront: centerImgVw)
        
        confirmBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x33c6b3)
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(38 * theScaleToiPhone_6)
            make.right.equalTo(-38 * theScaleToiPhone_6)
            make.height.equalTo(48 * theScaleToiPhone_6)
            make.bottom.equalTo(-(70 * theScaleToiPhone_6 + Main_IndicatorBar_Height))
        }
        
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.cornerRadius = 48 * theScaleToiPhone_6 / 2
        
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiCapitalPoolPage_bottom_btn_title_key), for: UIControlState.normal)
        confirmBtn.addTarget(self, action: #selector(self.joinBtnAction), for: UIControlEvents.touchUpInside)
        
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
            make.top.equalTo(centerImgVw.snp.bottom).offset(20)
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
        
        let bottomLbl = UILabel(frame: CGRect.zero)
        self.view.addSubview(bottomLbl)
        bottomLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(digitalBottomLbl.snp.bottom).offset(30 * theScaleToiPhone_6)
        }
        
        bottomLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiCapitalPoolPage_reminder_text_key), numberOfLines: 2, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB:0x16a2ac), font: UIFont.systemFont(ofSize: 14))
        
        introPlan()
        
        harvest()
    }
    
    // 参与矿池
    func introPlan() {
        
        let introPlanBtnWidth: CGFloat = 108
        self.view.addSubview(introPlanBtn)
        introPlanBtn.snp.makeConstraints { (make) in
            make.width.equalTo(introPlanBtnWidth)
            make.height.equalTo(introPlanBtnWidth)
            make.bottom.equalTo(-172 * theScaleToiPhone_6)
            make.left.equalTo(-50)
        }
        
        introPlanBtn.layer.masksToBounds = true
        introPlanBtn.layer.cornerRadius = introPlanBtnWidth * 0.5
        introPlanBtn.layer.borderWidth = 3
        introPlanBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x1ed2b0).cgColor
        introPlanBtn.backgroundColor = UIColor.clear
        
        introPlanBtn.addTarget(self, action: #selector(self.introPlanBtnAction), for: UIControlEvents.touchUpInside)
        
        let halfCircleView = UIView(frame: CGRect.zero)
        introPlanBtn.addSubview(halfCircleView)
        halfCircleView.snp.makeConstraints { (make) in
            make.width.height.equalTo(92)
            make.center.equalToSuperview()
        }
        
        halfCircleView.backgroundColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
        halfCircleView.cornerRadius = 92 * 0.5
        
        let verticalText = MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiCapitalPoolPage_left_btn_title_key)
        let paraphStyle = NSMutableParagraphStyle()
        paraphStyle.lineSpacing = 0
        paraphStyle.alignment = .center
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paraphStyle]
        let attriText = NSMutableAttributedString(string: verticalText, attributes: attributes)
        
        let verticalTextView = UILabel(frame: CGRect.zero)
        verticalTextView.numberOfLines = 0
        verticalTextView.textAlignment = .center
        verticalTextView.attributedText = attriText
        halfCircleView.addSubview(verticalTextView)
        verticalTextView.snp.makeConstraints { (make) in
            make.left.equalTo(92 * 0.5)
            make.width.equalTo(92 * 0.5)
            make.height.equalTo(92)
            make.centerY.equalToSuperview()
        }
        
        halfCircleView.isUserInteractionEnabled = false
        verticalTextView.isUserInteractionEnabled = false
    }
    
    // 收获矿池
    func harvest() {
        
        let introPlanBtnWidth: CGFloat = 108
        self.view.addSubview(harvestBtn)
        harvestBtn.snp.makeConstraints { (make) in
            make.width.equalTo(introPlanBtnWidth)
            make.height.equalTo(introPlanBtnWidth)
            make.bottom.equalTo(-172 * theScaleToiPhone_6)
            make.right.equalTo(50)
        }
        
        harvestBtn.layer.masksToBounds = true
        harvestBtn.layer.cornerRadius = introPlanBtnWidth * 0.5
        harvestBtn.layer.borderWidth = 3
        harvestBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x109baa).cgColor
        harvestBtn.backgroundColor = UIColor.clear
        
        harvestBtn.addTarget(self, action: #selector(self.harvestBtnAction), for: UIControlEvents.touchUpInside)
        
        let halfCircleView = UIView(frame: CGRect.zero)
        harvestBtn.addSubview(halfCircleView)
        halfCircleView.snp.makeConstraints { (make) in
            make.width.height.equalTo(92)
            make.center.equalToSuperview()
        }
        
        halfCircleView.backgroundColor = UIColorFromRGB(hexRGB: 0x109baa)
        halfCircleView.cornerRadius = 92 * 0.5
        
        let verticalText = MRLocalizableStringManager.localizableStringFromTableHandle(key: MavrodiCapitalPoolPage_right_btn_title_key)
        let paraphStyle = NSMutableParagraphStyle()
        paraphStyle.lineSpacing = 0
        paraphStyle.alignment = .center
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paraphStyle]
        let attriText = NSMutableAttributedString(string: verticalText, attributes: attributes)
        
        let verticalTextView = UILabel(frame: CGRect.zero)
        verticalTextView.numberOfLines = 0
        verticalTextView.textAlignment = .center
        verticalTextView.attributedText = attriText
        
        halfCircleView.addSubview(verticalTextView)
        verticalTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(92 * 0.5)
            make.height.equalTo(92)
            make.centerY.equalToSuperview()
        }
        
        halfCircleView.isUserInteractionEnabled = false
        verticalTextView.isUserInteractionEnabled = false
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
        rotationAnima.beginTime = CACurrentMediaTime() + 0.3
        
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
    
    //  参与矿池
    @objc func introPlanBtnAction() {
        
        let planPoolViewCtrl = MavrodiPlanRowPoolViewController()
        self.navigationController?.pushViewController(planPoolViewCtrl, animated: true)
    }
    
    //  收获矿池
    @objc func harvestBtnAction() {
        
        let planPoolViewCtrl = HarvestpoolViewController()
        self.navigationController?.pushViewController(planPoolViewCtrl, animated: true)
    }
    
    // MARK: - Request
    func requestForCapitalPoolAmount() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_CAPITALPOOL_AMOUNT, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let amount = data as? String {
                        let _amount1 = String.stringFormatMultiplyingByPowerOf10_18(str: String(amount))
//                        let _amount:UInt64 = UInt64(amount)/100_0000_0000_0000_0000
//                        let _amount:Double = Double(amount)/100_0000_0000_0000_0000
                        
                        let _amount = String(format: "%d", Int(truncating: NSNumber(value: Double(_amount1) ?? 0)))
                        let digitalNumStr = "\(_amount)"
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
