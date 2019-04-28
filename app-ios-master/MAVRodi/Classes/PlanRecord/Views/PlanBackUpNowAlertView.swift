//
//  BackUpNowAlertView.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/25.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class PlanBackUpNowAlertView: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancleBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        confirmBtn.layer.cornerRadius = confirmBtn.height() / 2
        confirmBtn.layer.masksToBounds = true
        titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MRPlan_Unfreeze_title_key)
        titleLabel2.textAlignment = .center
        detailLabel.text = ""
        if let userInfo = MRCommonShared.shared.userInfo {
            titleLabel2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MRPlan_Unfreeze_Account_title_key)+String(format: "%.0fMcoin", userInfo.unlock_need_mcoin)
        }
//        titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_title_key)
//        titleLabel2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_title2_key)
//        detailLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletHomePage_detail_title_key)
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_bottom_btn_unfreeze_title_key), for: UIControlState.normal)
        
    }

    var confirmActionClosure:(() -> ())?
    var cancleActionClosure:(() -> ())?
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        if confirmActionClosure != nil {
            confirmActionClosure!()
        }
    }
    
    @IBAction func cancleAction(_ sender: UIButton) {
        
        if cancleActionClosure != nil {
            cancleActionClosure!()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PlanBackUpNowAlertView {
    
    static func showPlanBackUpNowAlertView(superV: UIView, confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        if (superV.viewWithTag(678) != nil){
            return //父视图中存在，返回
        }
        let agreementView = Bundle.main.loadNibNamed("PlanBackUpNowAlertView", owner: self, options: nil)?.last as! PlanBackUpNowAlertView
        agreementView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 190 * theScaleToiPhone_6)
        agreementView.tag = 678
        let backView = UIView(frame: superV.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        agreementView.center = backView.center
        backView.addSubview(agreementView)
        superV.addSubview(backView)
        
        agreementView.confirmActionClosure = {
            backView.removeFromSuperview()
            confirmTapClosure()
        }
        
        agreementView.cancleActionClosure = {
            backView.removeFromSuperview()
        }
        
        
    
    }
    
    
}
