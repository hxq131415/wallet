//
//  CustomAlertView.swift
//  MAVRodi
//
//  Created by HJY on 2018/12/1.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class CustomTipAlertView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    //@IBOutlet weak var contentLabel: TTTAttributedLabel!
    
    @IBOutlet weak var IknowBtn: UIButton!
    var returnActionClosure:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
    }
//    func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
//
//        let statusLabelText: NSString = labelStr as NSString
//        let size = CGSize(width: width, height: 900)
//
//        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
//
//        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
//
//        return strSize.height
//
//    }
    @IBAction func returnAction(_ sender: UIButton) {
    
        if returnActionClosure != nil {
            returnActionClosure!()
        }
    }
}

extension CustomTipAlertView {
    
    static func showCustomTipAlertView(superV: UIView,  confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        let alertView = Bundle.main.loadNibNamed("CustomTipAlertView", owner: self, options: nil)?.last as! CustomTipAlertView
        alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 270 * theScaleToiPhone_6)
        alertView.titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key:PlanReservation_bottom_alert_quantified_amount_rule)
        alertView.descLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanReservation_bottom_alert_quantified_title )
        //alertView.contentLabel.adjustsFontSizeToFitWidth = true
        
//        alertView.IknowBtn.contentHorizontalAlignment = .center
//        alertView.IknowBtn.setTitle(, for:UIControlState.normal)
        
        let backView = UIView(frame: superV.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        alertView.center = backView.center
        backView.addSubview(alertView)
        
        superV.addSubview(backView)
        
        alertView.returnActionClosure = {
            backView.removeFromSuperview()
            confirmTapClosure()
        }
    }
    
    

    
}
