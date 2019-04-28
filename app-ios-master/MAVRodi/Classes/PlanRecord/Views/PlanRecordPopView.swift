//
//  PlanRecordPopView.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/26.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

let kPlanRecordPopViewTag = 909090

class PlanRecordPopView: UIView {

    var leftBtn: UIButton = UIButton(type: UIButtonType.custom)
    var centerBtn: UIButton = UIButton(type: UIButtonType.custom)
    var rightBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    var buttonTapActionClosure:((Int) -> ())?
    var hiddenActionClosure:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        initConfigSubviews()
    }

    func initConfigSubviews() {
        
        let buttonSize = 64 * theScaleToiPhone_6
        
        leftBtn.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        leftBtn.setImage(UIImage(named: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordPage_join_title_key)), for: UIControlState.normal)
        self.addSubview(leftBtn)
        
        centerBtn.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        centerBtn.setImage(UIImage(named: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordPage_reward_title_key)), for: UIControlState.normal)
        self.addSubview(centerBtn)
        
        rightBtn.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        rightBtn.setImage(UIImage(named: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordPage_harvest_title_key)), for: UIControlState.normal)
        self.addSubview(rightBtn)
        
        let point = CGPoint(x: self.frame.width / 2, y: self.frame.height + buttonSize / 2.5)
        leftBtn.center = point
        centerBtn.center = point
        rightBtn.center = point
        
        leftBtn.addTarget(self, action: #selector(self.buttonTapAction(btn:)), for: UIControlEvents.touchUpInside)
        centerBtn.addTarget(self, action: #selector(self.buttonTapAction(btn:)), for: UIControlEvents.touchUpInside)
        rightBtn.addTarget(self, action: #selector(self.buttonTapAction(btn:)), for: UIControlEvents.touchUpInside)
        
        leftBtn.tag = 100
        centerBtn.tag = 200
        rightBtn.tag = 300
        
        startAnimate()
    }
    
    @objc func buttonTapAction(btn: UIButton) {
        self.hiddenAnimate()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if self.buttonTapActionClosure != nil {
                self.buttonTapActionClosure!(btn.tag)
            }
        }
        
    }
    
    
    func startAnimate() {
        
        let buttonSize = 64 * theScaleToiPhone_6
        let leftRightBtnCenterY = self.frame.height - buttonSize / 2 - 11
        let centerBtnCenterY = self.frame.height - buttonSize / 2 - 28

        UIView.animateKeyframes(withDuration: TimeInterval(0.15), delay: TimeInterval(0.0), options: UIViewKeyframeAnimationOptions.calculationModeLinear, animations: {
            
            self.leftBtn.center = CGPoint(x: self.frame.width / 2 - buttonSize, y: leftRightBtnCenterY)
            self.centerBtn.center = CGPoint(x: self.frame.width / 2, y: centerBtnCenterY)
            self.rightBtn.center = CGPoint(x: self.frame.width / 2 +  buttonSize, y: leftRightBtnCenterY)
        }) { (_) in
            
        }
        
    }
    
    func hiddenAnimate() {
        
        let point = CGPoint(x: self.frame.width / 2, y: self.frame.height + self.leftBtn.frame.height / 2.5)

        UIView.animateKeyframes(withDuration: TimeInterval(0.15), delay: TimeInterval(0.0), options: UIViewKeyframeAnimationOptions.calculationModeLinear, animations: {
            
            self.leftBtn.center = point
            self.centerBtn.center = point
            self.rightBtn.center = point
        }) { (_) in
//            if self.hiddenActionClosure != nil {
//                self.hiddenActionClosure!()
//            }
            self.removeFromSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hiddenAnimate()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if self.hiddenActionClosure != nil {
                self.hiddenActionClosure!()
            }
        }
    }
}

extension PlanRecordPopView {
    
    static func showPlanRecordPopView(superV: UIView, confirmTapClosure: @escaping ((_ index: Int) -> Void)) -> Void {
     
        let planView = PlanRecordPopView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: superV.bounds.height - Sys_Bottom_Bar_Height - Main_IndicatorBar_Height - 20))
        planView.tag = kPlanRecordPopViewTag
        superV.addSubview(planView)
        planView.backgroundColor = UIColor.clear
        planView.buttonTapActionClosure = { tag in
            confirmTapClosure(tag)
        }
        //隐藏tag : 9999
        planView.hiddenActionClosure = {
            confirmTapClosure(9999)
        }
    }
    
    static func hiddenPlanRecordPopView(superV: UIView, animate: Bool = false) {
        if let view = superV.viewWithTag(kPlanRecordPopViewTag) {
            if let planView = view as? PlanRecordPopView {
                if animate  {
                    planView.hiddenAnimate()
                }else {
                   planView.removeFromSuperview()
                }
            }
        }
    }
    
    
}
