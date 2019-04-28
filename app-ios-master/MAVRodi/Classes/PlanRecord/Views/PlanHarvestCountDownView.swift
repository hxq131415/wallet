//
//  PlanHarvestCountDownView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/12.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class PlanHarvestCountDownView: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var hourUnitLbl: UILabel!
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var minUnitLbl: UILabel!
    @IBOutlet weak var secondsLbl: UILabel!
    @IBOutlet weak var secondsUnitLbl: UILabel!
    
    @IBOutlet weak var progressBackVw: UIView!
    @IBOutlet weak var progressBackViewWidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var progressForeVw: UIView!
    
    @IBOutlet weak var progressForeViewLeadingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.text = "确认倒计时"
        
        hourLbl.layer.masksToBounds = true
        hourLbl.layer.cornerRadius = 2
        
        minLbl.layer.masksToBounds = true
        minLbl.layer.cornerRadius = 2
        
        secondsLbl.layer.masksToBounds = true
        secondsLbl.layer.cornerRadius = 2
        
        progressBackVw.layer.masksToBounds = true
        progressBackVw.layer.cornerRadius = 2
        
        hourLbl.text = String(format: "%02d", Int(0))
        minLbl.text = String(format: "%02d", Int(0))
        secondsLbl.text = String(format: "%02d", Int(0))
        
        progressBackViewWidthConstaint.constant = 310 * theScaleToiPhone_6
        
        progressForeViewLeadingConstraint.constant = 310 * theScaleToiPhone_6 * 0.0
        UIView.animate(withDuration: MR_AnimateTimeInterval) {
            self.progressForeVw.superview?.layoutIfNeeded()
        }
    }
    
    func configCountDownView(confirmStartTime: TimeInterval, transferTime: TimeInterval) {
        
        let curTime = Date().timeIntervalSince1970
        // 当前时间距离结束时间的差值
        let distanceTime = transferTime - curTime
        // 当前时间距离开始的时间差值
        let startedTime = curTime - confirmStartTime
        
        if distanceTime > 0 {
            // 相差小时
            
            let hours = distanceTime / 60 / 60
            // 相差分钟
            
            let mins = (distanceTime / 60).truncatingRemainder(dividingBy: 60)
            // 相差秒数
            
            let seccods = distanceTime.truncatingRemainder(dividingBy: 60)
            
            hourLbl.text = String(format: "%02d", Int(hours))
            minLbl.text = String(format: "%02d", Int(mins))
            secondsLbl.text = String(format: "%02d", Int(seccods))
        }
        else {
            hourLbl.text = String(format: "%02d", Int(0))
            minLbl.text = String(format: "%02d", Int(0))
            secondsLbl.text = String(format: "%02d", Int(0))
        }
        
        var percent = startedTime / (transferTime - confirmStartTime)
        percent = percent > 1 ? 1 : percent
        percent = percent <= 0 ? 0 : percent
        progressForeViewLeadingConstraint.constant = 310 * theScaleToiPhone_6 * CGFloat(percent)
        UIView.animate(withDuration: MR_AnimateTimeInterval) {
            self.progressForeVw.superview?.layoutIfNeeded()
        }
    }
    
}
