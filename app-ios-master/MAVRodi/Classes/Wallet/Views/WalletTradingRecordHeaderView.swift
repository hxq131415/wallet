//
//  WalletTradingRecordHeaderView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class WalletTradingRecordHeaderView: UIView {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var btnBackgroundVIew: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var receiptBtn: UIButton!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var amoutLbl: UILabel!
    @IBOutlet weak var iconImgTopConstroint: NSLayoutConstraint!
    
    var receiptBtnTapClosure: (() -> ())?
    var transferBtnTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if iSiPhoneX() {
            iconImgTopConstroint.constant = 70 * theScaleToiPhone_6
        }else {
            iconImgTopConstroint.constant = 60 * theScaleToiPhone_6
        }
        btnBackgroundVIew.backgroundColor = UIColor.clear
        
        btnBackgroundVIew.layer.masksToBounds = false
        btnBackgroundVIew.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0.2), shadowOffset: CGSize(width: -1, height: -1), shadowRadius: 23)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = contentView.height() / 2
        
        receiptBtn.setImage(UIImage(named: "icon_receive"), for: UIControlState.normal)
        transferBtn.setImage(UIImage(named: "icon_transfer"), for: UIControlState.normal)
        receiptBtn.titleRightAndImageLeftSetting(withSpace: 20)
        transferBtn.titleLeftImageRightSetting(withSpace: 20)
        
        receiptBtn.addTarget(self, action: #selector(self.receiptBtnAction), for: UIControlEvents.touchUpInside)
        transferBtn.addTarget(self, action: #selector(self.tranferBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: - Action
    @objc func receiptBtnAction() {
        
        if self.receiptBtnTapClosure != nil {
            self.receiptBtnTapClosure!()
        }
    }
    
    @objc func tranferBtnAction() {
        
        if self.transferBtnTapClosure != nil {
            self.transferBtnTapClosure!()
        }
    }
    
    
    
}
