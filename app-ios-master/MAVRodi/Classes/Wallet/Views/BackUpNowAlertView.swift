//
//  BackUpNowAlertView.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/25.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class BackUpNowAlertView: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        confirmBtn.layer.cornerRadius = confirmBtn.height() / 2
        confirmBtn.layer.masksToBounds = true
        
        titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_title_key)
        titleLabel2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_title2_key)
        detailLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_detail_title_key)
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_confirm_title_key), for: UIControlState.normal)
        
    }

    var confirmActionClosure:(() -> ())?
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        if confirmActionClosure != nil {
            confirmActionClosure!()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BackUpNowAlertView {
    
    static func showWalletBackUpNowAlertView(superV: UIView, confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        let agreementView = Bundle.main.loadNibNamed("BackUpNowAlertView", owner: self, options: nil)?.last as! BackUpNowAlertView
        agreementView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 360 * theScaleToiPhone_6)
        
        let backView = UIView(frame: superV.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        agreementView.center = backView.center
        backView.addSubview(agreementView)
        superV.addSubview(backView)
        
        agreementView.confirmActionClosure = {
            backView.removeFromSuperview()
            confirmTapClosure()
        }
    
    }
    
    
}
