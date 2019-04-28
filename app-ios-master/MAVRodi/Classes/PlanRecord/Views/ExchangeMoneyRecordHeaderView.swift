//
//  WalletTradingRecordHeaderView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class ExchangeMoneyRecordHeaderView: UIView {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var btnBackgroundVIew: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var receiptBtn: UIButton!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var amoutLbl: UILabel!
    @IBOutlet weak var iconImgTopConstroint: NSLayoutConstraint!
    
    var applyWithdrawBtnTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    
    @IBAction func applyWithdrawBtnAction(_ sender: UIButton) {
        
        if self.applyWithdrawBtnTapClosure != nil {
            self.applyWithdrawBtnTapClosure!()
        }
    }
 
    
    
    
    
}
