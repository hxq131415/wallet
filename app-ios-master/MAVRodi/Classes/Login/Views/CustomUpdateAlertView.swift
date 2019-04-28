//
//  CustomAlertView.swift
//  MAVRodi
//
//  Created by HJY on 2018/12/1.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class CustomUpdateAlertView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var modifyText: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var getModifyBtn: UIButton!
    var sendVerifyCodeBtnTapClosure: (() -> Void)?
    var cancelBtnTapClosure: (() -> Void)?
    var determineBtnTapClosure: ((_ paymentPwd: String?, _ verifyCode: String?) -> Void)?
//    var returnActionClosure:(() -> ())?
    
    @IBAction func getModifyAction(_ sender: Any) {
        if self.sendVerifyCodeBtnTapClosure != nil {
            self.sendVerifyCodeBtnTapClosure!()
        }
    }
    @IBAction func comfirmAction(_ sender: Any) {
        if self.determineBtnTapClosure != nil {
            self.determineBtnTapClosure!(passwordText.text, modifyText.text)
        }
    }
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
        if self.cancelBtnTapClosure != nil {
            self.cancelBtnTapClosure!()
        }
    }
}

extension CustomUpdateAlertView: UITextFieldDelegate{
    
    static func showCustomUpdateAlertView(superV: UIView, title: String, detail: String, confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        let alertView = Bundle.main.loadNibNamed("CustomUpdateAlertView", owner: self, options: nil)?.last as! CustomUpdateAlertView
        alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 270 * theScaleToiPhone_6)
        alertView.titleLabel.text = title
        if(detail != "")
        {
            alertView.contentLabel.adjustsFontSizeToFitWidth = true
            alertView.contentLabel.text = detail
            
            let statusLabelText: NSString = detail as NSString
            let size = CGSize(width: alertView.contentLabel.frame.width, height: 900)
            
            let dic = NSDictionary(object: alertView.contentLabel.font, forKey: NSAttributedStringKey.font as NSCopying)
            
            let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
            
            let lableHeight = strSize.height
            
            alertView.frame = CGRect(x: 0, y: 0, width: 318 * theScaleToiPhone_6, height: 120+lableHeight)
        }
        else{
            alertView.contentLabel.alpha = 0
        }
        
        
        alertView.confirmBtn.contentHorizontalAlignment = .center
        alertView.confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanReservation_bottom_alert_Iknow_key), for:UIControlState.normal)
        
        let backView = UIView(frame: superV.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        alertView.center = backView.center
        backView.addSubview(alertView)
        
        superV.addSubview(backView)
        
        alertView.cancelBtnTapClosure = {
            backView.removeFromSuperview()
            confirmTapClosure()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == passwordText {
            if !isNull(str: textField.text) {
                modifyText.becomeFirstResponder()
                return true
            }
        }
        else if textField == modifyText {
            if !isNull(str: textField.text) {
                passwordText.becomeFirstResponder()
                return true
            }
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == passwordText {
            let text = textField.text!
            let len = text.characters.count + string.count - range.length
            return len<=4
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    

    
}


