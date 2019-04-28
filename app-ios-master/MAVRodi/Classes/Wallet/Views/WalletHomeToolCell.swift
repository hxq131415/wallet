//
//  WalletHomeToolCell.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/25.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class WalletHomeToolCell: UITableViewCell {

    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var laterBtn: UIButton!
    @IBOutlet weak var backUpNowBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    var laterBtnTapActionClosure:(() -> ())?
    var backUpNowBtnTapActionClosure:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.clipsToBounds = true
        
        reminderLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_remindder_text_key)
        detailLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_remindder_detail_text_key)
        
        laterBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_later_btn_title_key), for: UIControlState.normal)
        backUpNowBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_back_up_now_btn_title_key), for: UIControlState.normal)
        
        laterBtn.layer.cornerRadius = laterBtn.height() / 2
        laterBtn.layer.masksToBounds = true
        backUpNowBtn.layer.cornerRadius = laterBtn.height() / 2
        backUpNowBtn.layer.masksToBounds = true
        
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        bgView.layer.borderColor = MRColorManager.LightGrayBorderColor.cgColor
        bgView.layer.borderWidth = 0.5
    }

    @IBAction func laterAction(_ sender: UIButton) {
        if laterBtnTapActionClosure != nil {
            laterBtnTapActionClosure!()
        }
    }
    @IBAction func backUpNowAction(_ sender: UIButton) {
        if backUpNowBtnTapActionClosure != nil {
            backUpNowBtnTapActionClosure!()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
