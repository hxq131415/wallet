//
//  WalletTradingRecordHeaderView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MyRewardHeaderView: UIView {

    @IBOutlet weak var btnBackgroundVIew: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var leftTextLbl: UILabel!
    @IBOutlet weak var rightTextLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnBackgroundVIew.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        btnBackgroundVIew.layer.masksToBounds = false
        btnBackgroundVIew.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0.2), shadowOffset: CGSize(width: -1, height: -1), shadowRadius: 23)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        
        leftBtn.setTitle("My sharing", for: UIControlState.normal)
        leftBtn.setImage(UIImage(named: "icon_reward_sharing"), for: UIControlState.normal)
        
        rightBtn.setTitle("My team", for: UIControlState.normal)
        rightBtn.setImage(UIImage(named: "icon_reward_team"), for: UIControlState.normal)
        
        leftBtn.verticalCenterSetting(withSpace: 2)
        rightBtn.verticalCenterSetting(withSpace: 2)
        
        titleLbl.text = "My sharing reward (ETC)"
        bottomLbl.text = "Get a direct push to participate in the MAVRODI amount of 10% as a reward"
    }
    
    func configHeaderViewWithModel(rewardModel: MyRewardModel?, rewardType: MRRewardType) {
        
        leftBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_header_left_btn_title_key), for: UIControlState.normal)
        leftBtn.setImage(UIImage(named: "icon_reward_sharing"), for: UIControlState.normal)
        
        rightBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_header_right_btn_title_key), for: UIControlState.normal)
        rightBtn.setImage(UIImage(named: "icon_reward_team"), for: UIControlState.normal)
        
        leftBtn.verticalCenterSetting(withSpace: 2)
        rightBtn.verticalCenterSetting(withSpace: 2)
        
        if rewardType == .sharing {
            titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_sharing_header_top_lbl_title_key)
            bottomLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_sharing_header_gray_reminder_text_key)
        }
        else {
            titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_leadership_header_top_lbl_title_key)
            bottomLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_leadership_header_gray_reminder_text_key)
        }
        
//        if let model = rewardModel {
//            leftTextLbl.text = "\(model.sharing_num)"
//            rightTextLbl.text = "\(model.team_num)"
//            amountLbl.text = String(format: "%.6f", model.amount)
//        }
//        else {
//            leftTextLbl.text = "0"
//            rightTextLbl.text = "0"
//            amountLbl.text = "0.000000"
//        }
    }
    
}
