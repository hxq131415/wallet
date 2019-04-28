//
//  PlanJoinOrderDetailCell.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/11.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class PlanHarvestDetailsCell: UICollectionViewCell {

    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var sepertorLineVw1: UIView!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var sepertorLineVw2: UIView!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var sepertorLineVw3: UIView!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField1ToTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if Main_Screen_Width < 375 {
            textField1ToTopConstraint.constant = 25
        }
        else {
            textField1ToTopConstraint.constant = 45
        }
        
        backgroundVw.cornerRadius = 8
        
        self.configTextField(textField: textField1)
        self.setLeftView(textField: textField1, text: "参与金额")
        
        self.configTextField(textField: textField2)
        self.setLeftView(textField: textField2, text: "游戏奖励")
        
        self.configTextField(textField: textField3)
        self.setLeftView(textField: textField3, text: "排单日期")
        
        self.configTextField(textField: textField4, textColor: UIColorFromRGB(hexRGB: 0x365ad8))
        self.setLeftView(textField: textField4, text: "排单时间")
        
    }
    
    func configTextField(textField: UITextField, textColor: UIColor? = MRColorManager.DarkBlackTextColor) {
        
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.textColor = textColor
        if Main_Screen_Width < 375 {
            textField.font = UIFont.systemFont(ofSize: 16)
        }
        else {
            textField.font = UIFont.systemFont(ofSize: 18)
        }
        
        textField.isEnabled = false
    }
    
    func setLeftView(textField: UITextField, text: String, textColor: UIColor? = UIColorFromRGB(hexRGB: 0x7e7e7e)) {
        
        let leftLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 78, height: 35))
        leftLbl.configLabel(text: text, numberOfLines: 0, textAlignment: NSTextAlignment.left, textColor: textColor, font: UIFont.systemFont(ofSize: 13))
        textField.leftView = leftLbl
        textField.leftViewMode = .always
    }
    
    // 配置参与 转款详情
    func configCellWithJoinRecordListModel(model: PlanJoinRecordListModel) {
        
        self.setLeftView(textField: textField1, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_join_amount_title_key))
        
        self.setLeftView(textField: textField2, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_game_reward_title_key))
        
        self.setLeftView(textField: textField3, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_order_date_title_key))
        
        self.setLeftView(textField: textField4, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_order_time_title_key))
        
        textField1.text = String(format: "%.6f ETC", model.amount)
        textField2.text = String(format: "%.6f ETC", model.reward)
        textField3.text = model.joinDateStr
        
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
        let levelTime3 = levelTime2.truncatingRemainder(dividingBy: 60)
        let seccods = levelTime3
        
        let d = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_day_text_key)
        let h = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_hour_text_key)
        let m = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_minute_text_key)
        let s = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_seccond_text_key)
        
        let timeText = String(format: "%d %@ %02d %@ %02d %@ %02d %@", Int(days), d, Int(hours), h, Int(mins), m, Int(seccods), s)
        let attributeText = NSMutableAttributedString(string: timeText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)])
        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: d))
        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: h))
        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: m))
        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: s))
        
        textField4.attributedText = attributeText
    }
    
    // 配置收获确认详情
    func configCellWithHarvestRecordListModel(model: PlanHarvestRecordListModel) {
        
        textField1.text = String(format: "%.6f ETC", model.amount)
        
        if model.harvestStatusType == .queuing || model.harvestStatusType == .waitConfirm {
            textField2.text = model.dateStr
            textField3.isHidden = true
            sepertorLineVw2.isHidden = true
            textField4.isHidden = false
            sepertorLineVw3.isHidden = false
            self.setLeftView(textField: textField1, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_harvest_amount_title_key))
            self.setLeftView(textField: textField2, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_order_date_title_key))
            self.setLeftView(textField: textField4, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_order_time_title_key))
        }
        else if model.harvestStatusType == .finished
            || model.harvestStatusType == .newFinished {
            
            self.setLeftView(textField: textField1, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_harvest_amount_title_key))
            self.setLeftView(textField: textField2, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_order_time_title_key))
            self.setLeftView(textField: textField3, text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_harvest_date_title_key))
            
            textField2.text = model.dateStr
            textField3.text = model.confirmDateStr
            textField4.isHidden = true
            sepertorLineVw2.isHidden = false
            sepertorLineVw3.isHidden = true
        }
        
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
        let levelTime3 = levelTime2.truncatingRemainder(dividingBy: 60)
        let seccods = levelTime3
        
        let d = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_day_text_key)
        let h = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_hour_text_key)
        let m = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_minute_text_key)
        let s = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_seccond_text_key)
        
        let timeText = String(format: "%d %@ %02d %@ %02d %@ %02d %@", Int(days), d, Int(hours), h, Int(mins), m, Int(seccods), s)
        let attributeText = NSMutableAttributedString(string: timeText, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)])
        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: d))
        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: h))
        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: m))
        attributeText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x365ad8)], range: (timeText as NSString).range(of: s))
        
        textField4.attributedText = attributeText
    }
    
}
