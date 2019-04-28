//
//  CustomAlertView.swift
//  MAVRodi
//
//  Created by HJY on 2018/12/1.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
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

extension CustomAlertView {
    
    static func showCustomAlertView(superV: UIView, title: String, detail: String, confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        let alertView = Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)?.last as! CustomAlertView
        alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 270 * theScaleToiPhone_6)
        alertView.titleLabel.text = title
        alertView.contentLabel.adjustsFontSizeToFitWidth = true
        alertView.contentLabel.text = detail
        
        let statusLabelText: NSString = detail as NSString
        let size = CGSize(width: alertView.contentLabel.frame.width, height: 900)
        
        let dic = NSDictionary(object: alertView.contentLabel.font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
        
        let lableHeight = strSize.height
        
        alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 120+lableHeight)
        
        alertView.IknowBtn.contentHorizontalAlignment = .center
        alertView.IknowBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanReservation_bottom_alert_Iknow_key), for:UIControlState.normal)
        
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
