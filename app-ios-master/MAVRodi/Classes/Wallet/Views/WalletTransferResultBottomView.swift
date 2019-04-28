//
//  WalletTransferResultBottomView.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/26.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class WalletTransferResultBottomView: UITableViewCell {

    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var seeDetailBtn: UIButton!
    
    @IBOutlet weak var returnBottomConstraint: NSLayoutConstraint!
    var returnActionClosure:(() -> ())?
    var seeMoreDetailActionClosure:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        returnBottomConstraint.constant = 54 * theScaleToiPhone_6
        returnBtn.layer.cornerRadius = returnBtn.height() / 2
        returnBtn.layer.masksToBounds = true
        returnBtn.layer.borderWidth = 1.0
        returnBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x16a2ac).cgColor
        
        returnBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_return_title_key), for: UIControlState.normal)
        seeDetailBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_see_more_detail_title_key), for: UIControlState.normal)
    }

    @IBAction func returnAction(_ sender: UIButton) {
        if returnActionClosure != nil {
            returnActionClosure!()
        }
    }
    @IBAction func seeMoreDetailAction(_ sender: UIButton) {
        if seeMoreDetailActionClosure != nil {
            seeMoreDetailActionClosure!()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
