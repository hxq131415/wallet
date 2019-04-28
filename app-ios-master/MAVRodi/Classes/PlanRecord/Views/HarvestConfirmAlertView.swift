//
//  HarvestConfirmAlertView.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/27.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class HarvestConfirmAlertView: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var confirmActionClosure:(()-> ())?
    var cancelActionClosure:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: HarvestConfirmAlertViewPage_title_lbl_text_key)
        detailLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: HarvestConfirmAlertViewPage_detail_lbl_text_key)
        cancelBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: HarvestConfirmAlertViewPage_cancelBtn_title_key), for: UIControlState.normal)
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: HarvestConfirmAlertViewPage_confirmBtn_title_key), for: UIControlState.normal)
        confirmBtn.layer.cornerRadius = 22.5
        
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        if cancelActionClosure != nil {
            cancelActionClosure!()
        }
    }
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

extension HarvestConfirmAlertView {
    
    static func showHarvestConfirmAlertView(superV: UIView, confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        let alertView = Bundle.main.loadNibNamed("HarvestConfirmAlertView", owner: self, options: nil)?.last as! HarvestConfirmAlertView
        alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 213 * theScaleToiPhone_6)
        
        let backView = UIView(frame: superV.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        alertView.center = backView.center
        backView.addSubview(alertView)
        
        superV.addSubview(backView)
        
        alertView.confirmActionClosure = {
            backView.removeFromSuperview()
            confirmTapClosure()
        }
        alertView.cancelActionClosure = {
            backView.removeFromSuperview()
        }
    }
    
    static func showHarvestConfirmAlertViewWithDetail(superV: UIView, title:String, detail:String, confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        let alertView = Bundle.main.loadNibNamed("HarvestConfirmAlertView", owner: self, options: nil)?.last as! HarvestConfirmAlertView
        alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 233 * theScaleToiPhone_6)
        alertView.titleLabel.text = title
        alertView.detailLabel.text = detail
        alertView.detailLabel.textColor = UIColorFromRGB(hexRGB: 0xaaaaaa)

        let backView = UIView(frame: superV.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        alertView.center = backView.center
        backView.addSubview(alertView)
        
        superV.addSubview(backView)
        
        alertView.confirmActionClosure = {
            backView.removeFromSuperview()
            confirmTapClosure()
        }
        alertView.cancelActionClosure = {
            backView.removeFromSuperview()
        }
    }
    
}
