//
//  InvestmentTransferContentView.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/27.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class InvestmentTransferContentView: UIView {

    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var minerView: MRMinerFeeView!
    
    @IBOutlet weak var amountLabel: UILabel!
  
    @IBOutlet weak var todayTopLabel: UILabel!
    
    @IBOutlet weak var todayInputLabel: UILabel!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    
    var confirmBtnTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func confirmBtnAction(_ sender: UIButton) {
        
        if confirmBtnTapClosure != nil {
            confirmBtnTapClosure!()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x7e7e7e).withAlphaComponent(0.29), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 1, shadowPath: nil)
        
        self.contentBackgroundView.layer.masksToBounds = true
        self.contentBackgroundView.layer.cornerRadius = 8
        
        numTextField.borderStyle = .none
        numTextField.setValue( UIColorFromRGB(hexRGB: 0xaaaaaa), forKeyPath: "_placeholderLabel.textColor")
        numTextField.setValue(UIFont.systemFont(ofSize: 15), forKeyPath: "_placeholderLabel.font")
        
        numTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_amount_placeholder_text_key)
        numTextField.keyboardType = .numberPad
        
        amountLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: InvestmentTransferPage_amount_left_text_key)
        balanceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: InvestmentTransferPage_balance_left_text_key)
        
        let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
        constRightLbl.configLabel(text: "ETC", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x111111), font: UIFont.systemFont(ofSize: 13))
        constRightLbl.sizeToFit()
        numTextField.rightView = constRightLbl
        numTextField.rightViewMode = .always
        
        confirmBtn.layer.cornerRadius = confirmBtn.height() / 2
        confirmBtn.layer.masksToBounds = true
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_transfer_btn_title_key), for: UIControlState.normal)
    }

}
