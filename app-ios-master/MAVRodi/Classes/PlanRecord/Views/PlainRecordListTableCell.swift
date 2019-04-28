//
//  PlainRecordListTableCell.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/7.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

@objc protocol PlainRecordListTableCellDelegate: NSObjectProtocol {
    
    // 点击了环形进度条视图
    @objc func progressViewTouch(model:Any)
}

class PlainRecordListTableCell: UITableViewCell {

    @IBOutlet weak var leftLbl: UILabel!
    @IBOutlet weak var leftValueLbl: UILabel!
    @IBOutlet weak var middleValueLbl: UILabel!
    @IBOutlet weak var middleLbl: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var progressView: CircularProgressView!
    private var joinRecordModel: PlanJoinRecordListModel?
    private var harvestRecordModel: PlanHarvestRecordListModel?
    
    var cellType:Int = 1
    weak var delegate: PlainRecordListTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //绿色 #1ed2b0  红色#b20f03
        
    }
    
    
    func setProgressView(progress: CircularProgressView,progerssColor: UIColor) {
        
        progress.progerssBackgroundColor = UIColorFromRGB(hexRGB: 0xAAAAAA)
        progress.progerWidth = 2.5
        progress.progerssColor = progerssColor
        progress.progress = 0.5
        progress.cLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    // 配置参与详情
    func configCellWithGropJoinRecordListModel(joinRecordListModel: PlanJoinRecordListModel) {
        joinRecordModel = joinRecordListModel
        cellType = 1
        //为progressView添加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(progressViewClick))
        
        setProgressView(progress: progressView, progerssColor: UIColorFromRGB(hexRGB: 0x1ed2b0))
        
        let addTime = Date(timeIntervalSince1970: joinRecordListModel.add_time)
        let addTimeStr = addTime.dateStringFromDate(formatString: "yyyy-MM-dd")
        
        let timeText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_cell_left_text_key)
        
        leftLbl.text = timeText
        leftValueLbl.text = addTimeStr ?? ""
        leftValueLbl.adjustsFontSizeToFitWidth = true
        
        let middleTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_cell_middle_text_key)
        
        middleLbl.text = middleTitle
        middleValueLbl.adjustsFontSizeToFitWidth = true
        middleValueLbl.text = String(format: "%.6fETC", joinRecordListModel.amount)
        
        /*
         PlanRecordHome_join_record_status_queuing_text_key = "排单"
         PlanRecordHome_join_record_status_wait_transfer_text_key = "转款"
         PlanRecordHome_join_record_status_wait_text_key = "等待"
         PlanRecordHome_join_record_status_finish_text_key = "收获"
         */
        // 参与状态
        //状态 1排队中、2待会员转款、3待管理员审核、4已完成、5审核失败、8可以收获 7确认收货灰色 9抢单
        var statusText: String = ""
        var arcFinishColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
        var statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        if joinRecordListModel.joinStatusType == .waitTransfer { // 2转款
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_wait_transfer_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xb20f03)
            //            let differTime:Float = Float(joinRecordListModel.transferDeadline - joinRecordListModel.transferStart)
            //            let hour_72:Float = 72*3600
            
            //            let progress_temp = differTime/hour_72
            //            let str = String(format: "%.2f", Float(progress_temp)/1000)
            //            let progress = Float(str)!
            progressView.progress = 1.0
            //            if(progress != 0)
            //            {
            
            progressView?.addGestureRecognizer(singleTapGesture)
            progressView?.isUserInteractionEnabled = true
            statusTextColor = UIColorFromRGB(hexRGB: 0x111111)
            //            }
            //            else
            //            {
            //                progressView?.isUserInteractionEnabled = false
            //                statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
            //            }
            
        }
        else if joinRecordListModel.joinStatusType == .queuing { // 9抢单
            statusText = "抢单"
            //            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_wait_transfer_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
            progressView.progress = 1.0
            statusTextColor = UIColorFromRGB(hexRGB: 0x111111)
            
            
            progressView?.addGestureRecognizer(singleTapGesture)
            progressView?.isUserInteractionEnabled = true
            
            
        }
        else if joinRecordListModel.joinStatusType == .waitCheck{ // 3待审核
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_wait_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xb20f03)
            progressView.progress = 1.0
            statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        }
        else if  joinRecordListModel.joinStatusType == .finished{ // 4已完成
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_finish_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xeda231)
            progressView.progress = 1.0
            statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        }
        else if joinRecordListModel.joinStatusType == .checkFailure{ // 审核失败
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_failed_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xb20f03)
            progressView.progress = 1.0
            statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        }
        else if joinRecordListModel.joinStatusType == .waitHarvest {// 8可以收获
            
            arcFinishColor = UIColorFromRGB(hexRGB: 0xeda231)
            progressView.progress = 1.0
            //            let curTime = Date().timeIntervalSince1970
            //            let distanceTime = curTime - joinRecordListModel.add_time
            //            let days = distanceTime / (60 * 60 * 24)
            //            if(Int(days)>=15 && joinRecordListModel.is_packed)
            //            if(joinRecordListModel.is_packed)
            //            {
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_harvest_text_key)
            progressView?.addGestureRecognizer(singleTapGesture)
            progressView?.isUserInteractionEnabled = true
            statusTextColor = UIColorFromRGB(hexRGB: 0x111111)
            //            }
            //            else{
            //                statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_finish_text_key)
            //                progressView?.isUserInteractionEnabled = false
            //                statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
            //            }
            
        }
        
        progressView.cLabel?.text = statusText
        progressView.cLabel?.adjustsFontSizeToFitWidth=true
        progressView.cLabel?.textColor = statusTextColor
        progressView.progerssColor = arcFinishColor
    }
    
    // 配置参与详情
    func configCellWithJoinRecordListModel(joinRecordListModel: PlanJoinRecordListModel) {
        joinRecordModel = joinRecordListModel
        cellType = 1
        //为progressView添加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(progressViewClick))
        
        setProgressView(progress: progressView, progerssColor: UIColorFromRGB(hexRGB: 0x1ed2b0))
        
        let addTime = Date(timeIntervalSince1970: joinRecordListModel.add_time)
        let addTimeStr = addTime.dateStringFromDate(formatString: "yyyy-MM-dd")
        
        let timeText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_cell_left_text_key)
        
        leftLbl.text = timeText
        leftValueLbl.text = addTimeStr ?? ""
        leftValueLbl.adjustsFontSizeToFitWidth = true
        
        let middleTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_cell_middle_text_key)
        
        middleLbl.text = middleTitle
        middleValueLbl.adjustsFontSizeToFitWidth = true
        middleValueLbl.text = String(format: "%.6fETC", joinRecordListModel.amount)
        
        /*
         PlanRecordHome_join_record_status_queuing_text_key = "排单"
         PlanRecordHome_join_record_status_wait_transfer_text_key = "转款"
         PlanRecordHome_join_record_status_wait_text_key = "等待"
         PlanRecordHome_join_record_status_finish_text_key = "收获"
         */
        // 参与状态
        //状态 1排队中、2待会员转款、3待管理员审核、4已完成、5审核失败、8可以收获 7确认收货灰色 9抢单
        var statusText: String = ""
        var arcFinishColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
        var statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        if joinRecordListModel.joinStatusType == .queuing {//1排队中 排单
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_queuing_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
            progressView.progress = 1.0
            statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        }
        else if joinRecordListModel.joinStatusType == .waitTransfer { // 2转款
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_wait_transfer_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xb20f03)
//            let differTime:Float = Float(joinRecordListModel.transferDeadline - joinRecordListModel.transferStart)
//            let hour_72:Float = 72*3600
            
//            let progress_temp = differTime/hour_72
//            let str = String(format: "%.2f", Float(progress_temp)/1000)
//            let progress = Float(str)!
            progressView.progress = 1.0
//            if(progress != 0)
//            {
            
                progressView?.addGestureRecognizer(singleTapGesture)
                progressView?.isUserInteractionEnabled = true
                statusTextColor = UIColorFromRGB(hexRGB: 0x111111)
//            }
//            else
//            {
//                progressView?.isUserInteractionEnabled = false
//                statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
//            }
            
        }
        else if joinRecordListModel.joinStatusType == .waitCheck{ // 3待审核
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_wait_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xb20f03)
            progressView.progress = 1.0
            statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        }
        else if  joinRecordListModel.joinStatusType == .finished{ // 4已完成
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_finish_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xeda231)
            progressView.progress = 1.0
            statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        }
        else if joinRecordListModel.joinStatusType == .checkFailure{ // 审核失败
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_failed_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xb20f03)
            progressView.progress = 1.0
            statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        }
        else if joinRecordListModel.joinStatusType == .waitHarvest {// 8可以收获
            
            arcFinishColor = UIColorFromRGB(hexRGB: 0xeda231)
            progressView.progress = 1.0
//            let curTime = Date().timeIntervalSince1970
//            let distanceTime = curTime - joinRecordListModel.add_time
//            let days = distanceTime / (60 * 60 * 24)
//            if(Int(days)>=15 && joinRecordListModel.is_packed)
//            if(joinRecordListModel.is_packed)
//            {
                statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_harvest_text_key)
                progressView?.addGestureRecognizer(singleTapGesture)
                progressView?.isUserInteractionEnabled = true
                statusTextColor = UIColorFromRGB(hexRGB: 0x111111)
//            }
//            else{
//                statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_status_finish_text_key)
//                progressView?.isUserInteractionEnabled = false
//                statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
//            }
            
        }
        
        progressView.cLabel?.text = statusText
        progressView.cLabel?.adjustsFontSizeToFitWidth=true
        progressView.cLabel?.textColor = statusTextColor
        progressView.progerssColor = arcFinishColor
    }
    
    // 配置收获详情
    func configCellWithHarvestRecordListModel(recordListModel: PlanHarvestRecordListModel) {
        harvestRecordModel = recordListModel
        cellType = 2;
        //为progressView添加点击事件
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(progressViewClick))
        
        setProgressView(progress: progressView, progerssColor: UIColorFromRGB(hexRGB: 0x1ed2b0))
        
        let addTime = Date(timeIntervalSince1970: recordListModel.add_time)
        let addTimeStr = addTime.dateStringFromDate(formatString: "yyyy-MM-dd")

        let timeText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_cell_left_text_key)
        
        leftLbl.text = timeText
        leftValueLbl.text = addTimeStr ?? ""
        leftValueLbl.adjustsFontSizeToFitWidth = true
        
        let middleTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_cell_middle_text_key)
        
        middleLbl.text = middleTitle
        middleValueLbl.adjustsFontSizeToFitWidth = true
        middleValueLbl.text = String(format: "%.6fETC", recordListModel.amount)
        /*
         PlanRecordHome_harvest_record_status_queuing_text_key = "排单";
         PlanRecordHome_harvest_record_status_wait_confirm_text_key = "确定";
         PlanRecordHome_harvest_record_status_finish_text_key = "完成";
         PlanRecordHome_harvest_record_status_wait_text_key = "等待";
         */
        
        var statusText: String = ""
        var arcFinishColor: UIColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
        let statusTextColor = UIColorFromRGB(hexRGB: 0xaaaaaa)
        if recordListModel.harvestStatusType == .queuing {
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_queuing_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
            progressView.progress = 1.0
        }
        else if recordListModel.harvestStatusType == .waitConfirm {
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_wait_confirm_text_key)
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_wait_confirm_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xb20f03)
            
//            let differTime:Float = Float(recordListModel.transferDeadline - recordListModel.confirmStart)
//            let hour_72:Float = 72*3600
//
//            let progress_temp = differTime/hour_72
//            let str = String(format: "%.2f", Float(progress_temp)/1000)
//            let progress = Float(str)!
            progressView.progress = 0.0
            
            progressView?.addGestureRecognizer(singleTapGesture)
            progressView?.isUserInteractionEnabled = true
            
        }
        else if recordListModel.harvestStatusType == .wait {
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_wait_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xb20f03)
            progressView.progress = 1.0
        }
        else if recordListModel.harvestStatusType == .finished {
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_status_btn_wait_transfer_record_title_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xeda231)
            progressView.progress = 1.0
        }
        else if recordListModel.harvestStatusType == .newFinished {
            progressView?.isUserInteractionEnabled = false
            statusText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_status_finish_text_key)
            arcFinishColor = UIColorFromRGB(hexRGB: 0xeda231)
            progressView.progress = 1.0
        }
//        progressView.progress = 0.5
        progressView.cLabel?.text = statusText
        progressView.cLabel?.adjustsFontSizeToFitWidth=true
        progressView.cLabel?.textColor = statusTextColor
        progressView.progerssColor = arcFinishColor
    }
    
    //进度视图点击事件
    @objc func progressViewClick(){
        
        //区分是哪个记录信息
        if cellType == 1
        {
            //说明是参与记录joinRecordModel
            if self.delegate != nil && self.delegate!.responds(to: #selector(PlainRecordListTableCellDelegate.progressViewTouch(model: ))) {
                self.delegate!.progressViewTouch(model: joinRecordModel!)
            }
            print("参与记录进度视图点击事件")

        }
        if cellType == 2
        {
            //说明是收获记录harvestRecordModel
            if self.delegate != nil && self.delegate!.responds(to: #selector(PlainRecordListTableCellDelegate.progressViewTouch(model: ))) {
                self.delegate!.progressViewTouch(model: harvestRecordModel!)
            }
            print("收获记录进度视图点击事件")

        }
        
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
