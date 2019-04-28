//
//  PlanJoinOrderDetailCell2.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/27.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class PlanJoinOrderDetailCell2: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var greenDotViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var greenDotView: UIView!
    @IBOutlet weak var greenLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        greenDotView.cornerRadius = greenDotView.height() / 2
    }

    func configCellWithJoinRecordListModel(model: PlanJoinRecordListModel,row:Int) {
        
        switch row {
        case 0:
            let addTime = Date(timeIntervalSince1970: model.add_time)
            let addtimeText = addTime.dateStringFromTime(formatString: "HH:mm:ss")
            timeLabel.text = String(format: "%@\n%@", model.joinDateStr!,addtimeText!)
            priceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_consume_text_key)+String(format: ":%.2fMcoin", model.commission)
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_join_record_key)
        case 1:
//            if(model.transferStart == 0)
//            {
                timeLabel.text = ""
//            }
//            else
//            {
//                let transferStartTime = Date(timeIntervalSince1970: model.transferStart)
//                let transferStartDateStr = transferStartTime.dateStringFromDate(formatString: "yyyy-MM-dd")
//                let transferStartTimeText = transferStartTime.dateStringFromTime(formatString: "HH:mm:ss")
//                timeLabel.text = String(format: "%@\n%@", transferStartDateStr!,transferStartTimeText!)
//            }
            priceLabel.text = ""
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_wait_transfer_key)
        case 2:
            if(model.transferDeadline == 0)
            {
                timeLabel.text = ""
            }
            else
            {
                let transferDeadlineTime = Date(timeIntervalSince1970: model.transferDeadline)
                let transferDeadlineDateStr = transferDeadlineTime.dateStringFromDate(formatString: "yyyy-MM-dd")
                let transferDeadlineTimeText = transferDeadlineTime.dateStringFromTime(formatString: "HH:mm:ss")
                timeLabel.text = String(format: "%@\n%@", transferDeadlineDateStr!,transferDeadlineTimeText!)
            }
            priceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_Transfer_text_key)+String(format: ":%.2fETC", model.amount)
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_join_transfer_key)
        case 3:
            if(model.transferConfirmTime == 0)
            {
                timeLabel.text = ""
            }
            else
            {
                let transferConfirmTime = Date(timeIntervalSince1970: model.transferConfirmTime)
                let transferConfirmTimeText = transferConfirmTime.dateStringFromTime(formatString: "HH:mm:ss")
                timeLabel.text = String(format: "%@\n%@", model.transferConfirmDateStr!,transferConfirmTimeText!)
            }
            
            priceLabel.text = ""
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_transfer_confirm_key)
        case 4:
            if(model.tq_ime == 0)
            {
                timeLabel.text = ""
            }
            else
            {
                let tqTime = Date(timeIntervalSince1970: model.tq_ime)
                let tqTimeText = tqTime.dateStringFromTime(formatString: "HH:mm:ss")
                timeLabel.text = String(format: "%@\n%@", model.tqTimeDateStr!,tqTimeText!)
            }
            
            priceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanConfirmHarvest_amount_left_lblinput_max_amou_text_key)+String(format: ":%.2fETC", model.reward)
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_harvest_confirm_key)
        default:
            //
            timeLabel.text = ""
            priceLabel.text = ""
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_join_record_key)
        }
        
//        dateLabel.text = Date(timeIntervalSince1970: model.add_time).dateStringFromDate(formatString: "yyyy/MM/dd")
       
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
//        let d = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_day_text_key)
//        let h = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_hour_text_key)
//        let m = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_minute_text_key)
//        let s = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_seccond_text_key)
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
        
    }
    
    func configCellWithHarvestRecordListModel(model: PlanHarvestRecordListModel,row:Int) {
        
        switch row {
        case 0:
            let addTime = Date(timeIntervalSince1970: model.add_time)
            let addtimeText = addTime.dateStringFromTime(formatString: "HH:mm:ss")
            timeLabel.text = String(format: "%@\n%@", model.dateStr!,addtimeText!)
            priceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_consume_text_key)+String(format: ":%.2fMcoin", model.commission)
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_harvest_record_key)
        case 1:
//            let h = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_hour_text_key)
//            let m = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_minute_text_key)
//            let s = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_seccond_text_key)
//            timeLabel.text = Date(timeIntervalSince1970: model.add_time).dateStringFromDate(formatString: "HH\(h) mm\(m) ss\(s)")
//            timeLabel.font = UIFont.systemFont(ofSize: 15)
//            timeLabel.textColor = UIColor.red
//            if(model.confirm_time == 0)
//            {
//                timeLabel.text = ""
//            }
//            else
//            {
//                let transferStartTime = Date(timeIntervalSince1970: model.confirm_time)
//                let transferStartDateStr = transferStartTime.dateStringFromDate(formatString: "yyyy-MM-dd")
//                let transferStartTimeText = transferStartTime.dateStringFromTime(formatString: "HH:mm:ss")
//                timeLabel.text = String(format: "%@\n%@", transferStartDateStr!,transferStartTimeText!)
//            }
            timeLabel.text = ""
            priceLabel.text = ""
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_wait_confirm_key)
        case 111:
            if(model.transferDeadline == 0)
            {
                timeLabel.text = ""
            }
            else
            {
                let transferDeadlineTime = Date(timeIntervalSince1970: model.transferDeadline)
                let transferDeadlineDateStr = transferDeadlineTime.dateStringFromDate(formatString: "yyyy-MM-dd")
                let transferDeadlineTimeText = transferDeadlineTime.dateStringFromTime(formatString: "HH:mm:ss")
                timeLabel.text = String(format: "%@\n%@", transferDeadlineDateStr!,transferDeadlineTimeText!)
            }
            priceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_Transfer_text_key)+String(format: ":%.2fETC", model.amount)
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_join_transfer_key)
        case 3:
            if(model.confirmStart == 0)
            {
                timeLabel.text = ""
            }
            else
            {
                let transferConfirmTime = Date(timeIntervalSince1970: model.confirmStart)
                let transferConfirmTimeText = transferConfirmTime.dateStringFromTime(formatString: "HH:mm:ss")
                timeLabel.text = String(format: "%@\n%@", model.confirmDateStr!,transferConfirmTimeText!)
            }
            
            priceLabel.text = ""
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_harvest_confirm_key)
        case 2:
            if(model.wallet_tq_time == 0)
            {
                timeLabel.text = ""
            }
            else
            {
                let tqTime = Date(timeIntervalSince1970: model.wallet_tq_time)
                let tqTimeText = tqTime.dateStringFromTime(formatString: "HH:mm:ss")
                timeLabel.text = String(format: "%@\n%@", model.wallet_tqDateStr!,tqTimeText!)
            }
            
//            priceLabel.text = "收获:"+String(format: "%.2fETC", model.reward)
            priceLabel.text = ""
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_harvest_account_key)
        default:
            //
            timeLabel.text = ""
            priceLabel.text = ""
            statusLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_harvest_record_key)
        }
        
        //        dateLabel.text = Date(timeIntervalSince1970: model.add_time).dateStringFromDate(formatString: "yyyy/MM/dd")
        
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
        //        let d = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_day_text_key)
        //        let h = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_hour_text_key)
        //        let m = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_minute_text_key)
        //        let s = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_seccond_text_key)
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
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
