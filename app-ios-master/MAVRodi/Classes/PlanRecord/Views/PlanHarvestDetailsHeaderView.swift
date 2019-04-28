//
//  PlanHarvestDetailsHeaderView.swift
//  MAVRodi
//
//  Created by HJY on 2018/11/28.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class PlanHarvestDetailsHeaderView: UITableViewCell {

    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountTitleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var stepTitleLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var ETCLabel: UILabel!
    
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
        dateTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_date_title_key)
        timeTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_time_title_key)
        stepTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_step_title_key)
        
    }

    // 配置收获确认详情
    func configCellWithHarvestRecordListModel(model: PlanHarvestRecordListModel) {
        
        amountLabel.text = String(format: "%.6f", model.amount)
        dateLabel.text = Date(timeIntervalSince1970: model.add_time).dateStringFromDate(formatString: "yyyy/MM/dd")
        
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
//        timeLabel.text = Date(timeIntervalSince1970: model.add_time).dateStringFromDate(formatString: "HH\(h) mm\(m) ss\(s)")
        let timeText = String(format: "%d\(d) %02d\(h) %02d\(m)", Int(days), Int(hours), Int(mins))
        timeLabel.text = timeText
        
        //当前状态
        /*
         PlanRecordHome_harvest_record_status_queuing_text_key = "排单";
         PlanRecordHome_harvest_record_status_wait_confirm_text_key = "确定";
         PlanRecordHome_harvest_record_status_finish_text_key = "完成";
         PlanRecordHome_harvest_record_status_wait_text_key = "等待";
         */
        // 参与状态
        //状态 1排队中、2待会员转款、3待管理员审核、4已完成、5审核失败、8可以收获 7确认收货灰色
        if model.harvestStatusType == .queuing {//1排队中 排单
            stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_queuing_text_key)
        }
        else if model.harvestStatusType == .waitConfirm { // 2确定
            stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_wait_confirm_text_key)
        }
        else if model.harvestStatusType == .wait { // 3等待
            stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_wait_text_key)
        }
        else if model.harvestStatusType == .newFinished {//4已完成
            stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_finish_text_key)
        }
        else if model.harvestStatusType == .finished {//3待打款
            stepLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_status_btn_wait_transfer_record_title_key)
        }
        
        
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
//        let attributeText = NSMutableAttributedString(string: timeText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)])
//        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: d))
//        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: h))
//        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: m))
//        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: s))
//
//        textField4.attributedText = attributeText
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
