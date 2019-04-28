//
//  CustomAlertView.swift
//  MAVRodi
//
//  Created by HJY on 2018/12/1.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class CustomAlertView1: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: TTTAttributedLabel!
    
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

extension CustomAlertView1 {
    
    static func showCustomAlertView1(superV: UIView, lastTime: String, nextTime: String, confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        let alertView = Bundle.main.loadNibNamed("CustomAlertView1", owner: self, options: nil)?.last as! CustomAlertView1
        alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 270 * theScaleToiPhone_6)
//        alertView.titleLabel.text = title
        alertView.contentLabel.adjustsFontSizeToFitWidth = true
        let text1 = "您于"
        let text2 = lastTime
        let text3 = "刚提取过领导奖金，请在"

        let text4 = nextTime
        let text5 = "以后再提取"
        let bottomInfoText = text1+text2+text3+text4+text5
//        alertView.contentLabel.text = text1+text2+text3+text4+text5
        
        
        let attributeText: NSMutableAttributedString = NSMutableAttributedString(string: bottomInfoText)
        attributeText.addAttributes([NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x676767), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], range: NSMakeRange(0, attributeText.string.count))
        
        let range1 = (bottomInfoText as NSString).range(of: text2)
        let range2 = (bottomInfoText as NSString).range(of: text4)
        attributeText.addAttributes([NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x64CAFF), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], range: range1)
        attributeText.addAttributes([NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x64CAFF), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], range: range2)

        alertView.contentLabel.text = attributeText
        
        let statusLabelText: NSString = bottomInfoText as NSString
        let size = CGSize(width: alertView.contentLabel.frame.width, height: 900)
        
        let dic = NSDictionary(object: alertView.contentLabel.font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
        
        let lableHeight = strSize.height
        
        alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 180+lableHeight)
        
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
