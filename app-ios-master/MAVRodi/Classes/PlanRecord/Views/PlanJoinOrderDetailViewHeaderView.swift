//
//  PlanJoinOrderDetailViewHeaderView.swift
//  MAVRodi
//
//  Created by HJY on 2018/11/27.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class PlanJoinOrderDetailViewHeaderView: UITableViewCell {

    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var rewardTitleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var stepTitleLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var topETCLabel: UILabel!
    @IBOutlet weak var bottomETCLabel: UILabel!
    
    @IBOutlet weak var whiteView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        whiteView.layer.cornerRadius = 8
        whiteView.layer.masksToBounds = true
        
        leftConstraint.constant = 37 * theScaleToiPhone_6
        rightConstraint.constant = 37 * theScaleToiPhone_6
        
        configLocalizableTitle()
    }

    func configLocalizableTitle() {
        
        amountTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_amount_title_key)
        rewardTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_reward_title_key)
        dateTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_date_title_key)
        timeTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_time_title_key)
        stepTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_step_title_key)
        
    }
    
    func configCellWithJoinRecordListModel(model: PlanJoinRecordListModel) {
        
        configLocalizableTitle()
        
        amountLabel.text = String(format: "%.6f", model.amount)
        rewardLabel.text = String(format: "%.6f", model.reward)
        let addTime = Date(timeIntervalSince1970: model.add_time)
        let addTimeStr = addTime.dateStringFromDate(formatString: "YYYY/MM/dd")
        dateLabel.text = addTimeStr
        
//        timeLabel.text = Date(timeIntervalSince1970: model.add_time).dateStringFromDate(formatString: "HH\(h) mm\(m) ss\(s)")
        
        let curTime = Date().timeIntervalSince1970
        let distanceTime = curTime - model.add_time

        let days = distanceTime / (60 * 60 * 24)
        // 相差小时
        let levelTime1 = distanceTime.truncatingRemainder(dividingBy: (60 * 60 * 24))
        let hours = levelTime1 / (60 * 60)
        // 相差分钟
        let levelTime2 = levelTime1.truncatingRemainder(dividingBy: (60 * 60))
        let mins = levelTime2 / 60
        // 相差秒数
//        let levelTime3 = levelTime2.truncatingRemainder(dividingBy: 60)
//        let seccods = levelTime3

        let d = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_day_text_key)
        let h = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_hour_text_key)
        let m = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_minute_text_key)
//        let s = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_seccond_text_key)
        
        let timeText = String(format: "%d\(d) %02d\(h) %02d\(m)", Int(days), Int(hours), Int(mins))
        timeLabel.text = timeText
//        let addtimeText = addTime.dateStringFromTime(formatString: "HH:mm:ss")
//        timeLabel.text = addtimeText
        //当前状态
        /*
         PlanRecordHome_join_record_status_queuing_text_key = "排单"
         PlanRecordHome_join_record_status_wait_transfer_text_key = "转款"
         PlanRecordHome_join_record_status_wait_text_key = "等待"
         PlanRecordHome_join_record_status_finish_text_key = "收获"
         */
        // 参与状态
        //状态 1排队中、2待会员转款、3待管理员审核、4已完成、5审核失败、8可以收获 7确认收货灰色
        if model.joinStatusType == .queuing {//1排队中 排单
            stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_queuing_text_key)
        }
        else if model.joinStatusType == .waitTransfer { // 2转款
            stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_wait_transfer_text_key)
        }
        else if model.joinStatusType == .waitCheck{ // 3待审核
            stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_wait_text_key)
        }
        else if model.joinStatusType == .finished
            || model.joinStatusType == .waitHarvest {//4已完成 8可以收获
            let curTime = Date().timeIntervalSince1970
            let distanceTime = curTime - model.add_time
            let days = distanceTime / (60 * 60 * 24)
            if(Int(days)>=15 && model.is_packed)
            {
                stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_harvest_text_key)
            }
            else
            {
                stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_finish_text_key)
            }
            
        }
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//        let d = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_day_text_key)
//        let h = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_hour_text_key)
//        let m = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_minute_text_key)
//        let s = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_seccond_text_key)

//        let curTime = Date().timeIntervalSince1970
//        let distanceTime = curTime - model.add_time
//
//        let days = distanceTime / (60 * 60 * 24)
//        // 相差小时
//        let levelTime1 = distanceTime.truncatingRemainder(dividingBy: (60 * 60 * 24))
//        let hours = levelTime1 / (60 * 60)
//        // 相差分钟
//        let levelTime2 = levelTime1.truncatingRemainder(dividingBy: (60 * 60))
//        let mins = levelTime2 / 60
//        // 相差秒数
//        let levelTime3 = levelTime2.truncatingRemainder(dividingBy: 60)
//        let seccods = levelTime3
//
//        let timeText = String(format: "%d %@ %02d %@ %02d %@ %02d %@", Int(days), d, Int(hours), h, Int(mins), m, Int(seccods), s)
//
//
//        let attributeText = NSMutableAttributedString(string: timeText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)])
//        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: d))
//        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: h))
//        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: m))
//        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: s))
//
//        textField4.attributedText = attributeText
