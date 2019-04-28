//
//  WalletTransferResultContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/7.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class WalletTransferResultContentView: UIView {
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var topLogoImageVw: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var etcLbl: UILabel!
    
    @IBOutlet weak var statusBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusBtn.layer.cornerRadius = statusBtn.height() / 2
        statusBtn.layer.masksToBounds = true
        statusBtn.layer.borderWidth = 1.0
        statusBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x16a2ac).cgColor
        statusBtn.titleRightAndImageLeftSetting(withSpace: 3)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = MRColorManager.LightGrayBorderColor.cgColor
    }
    
}
