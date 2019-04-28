//
//  WalletTransferContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class WalletTransferContentView: UIView {
    
    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var bottomDescripLbl: UILabel!
    @IBOutlet weak var minerView: MRMinerFeeView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    var qrCodeScanBtnTapClosure: (() -> ())?
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
    @IBAction func scanAction(_ sender: UIButton) {
        self.qrCodeScanBtnAction()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x7e7e7e).withAlphaComponent(0.29), shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 1, shadowPath: nil)
        
        self.contentBackgroundView.layer.masksToBounds = true
        self.contentBackgroundView.layer.cornerRadius = 8
        
        addressTextField.borderStyle = .none
        addressTextField.setValue( UIColorFromRGB(hexRGB: 0xaaaaaa), forKeyPath: "_placeholderLabel.textColor")
        addressTextField.setValue(UIFont.systemFont(ofSize: 15), forKeyPath: "_placeholderLabel.font")
        
        addressTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_address_placeholder_text_key)
        addressTextField.keyboardType = .asciiCapable
        
        addressLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_address_left_text_key)
        
        numTextField.borderStyle = .none
        numTextField.setValue( UIColorFromRGB(hexRGB: 0xaaaaaa), forKeyPath: "_placeholderLabel.textColor")
        numTextField.setValue(UIFont.systemFont(ofSize: 15), forKeyPath: "_placeholderLabel.font")
        
        numTextField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_amount_placeholder_text_key)
        numTextField.keyboardType = .numberPad
        
        amountLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_amount_left_text_key)
        balanceLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_left_balance_text_key)
        
        let constRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
        constRightLbl.configLabel(text: "MCOIN", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
        constRightLbl.sizeToFit()
        numTextField.rightView = constRightLbl
        numTextField.rightViewMode = .always
        
        confirmBtn.layer.cornerRadius = confirmBtn.height() / 2
        confirmBtn.layer.masksToBounds = true
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferPage_transfer_btn_title_key), for: UIControlState.normal)
    }
    
    @objc func qrCodeScanBtnAction() {
        
        if self.qrCodeScanBtnTapClosure != nil {
            self.qrCodeScanBtnTapClosure!()
        }
    }
    
    
}
