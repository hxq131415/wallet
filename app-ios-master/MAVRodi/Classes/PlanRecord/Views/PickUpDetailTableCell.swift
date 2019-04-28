//
//  PlainRecordListTableCell.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/7.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

@objc protocol PickUpDetailTableCellDelegate: NSObjectProtocol {
    
    // 点击了环形进度条视图
    @objc func progressViewTouch(model:Any)
}

class PickUpDetailTableCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var stateLbl : UILabel!
    
    @IBOutlet weak var bgView: UIView!
    private var joinRecordModel: PlanJoinRecordListModel?
    private var harvestRecordModel: PlanHarvestRecordListModel?
  
    weak var delegate: PickUpDetailTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //绿色 #1ed2b0  红色#b20f03
        
    }
    
    // 配置参与详情
    func configCellWithListModel(joinRecordListModel: PlanJoinRecordListModel) {
        joinRecordModel = joinRecordListModel
 
        let addTime = Date(timeIntervalSince1970: joinRecordListModel.add_time)
        let addTimeStr = addTime.dateStringFromDate(formatString: "yyyy-MM-dd")
        
        let timeText = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_cell_left_text_key)
        
        timeLbl.text = timeText
        timeLbl.text = addTimeStr ?? ""
        timeLbl.adjustsFontSizeToFitWidth = true
        
        let middleTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_cell_middle_text_key)
        
        amountLbl.text = middleTitle
        amountLbl.adjustsFontSizeToFitWidth = true
        amountLbl.text = String(format: "%.6fETC", joinRecordListModel.amount)
        
        stateLbl.text = middleTitle
        stateLbl.adjustsFontSizeToFitWidth = true
        stateLbl.text = String(format: "%.6fETC", joinRecordListModel.amount)
        
        }
    
    
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
