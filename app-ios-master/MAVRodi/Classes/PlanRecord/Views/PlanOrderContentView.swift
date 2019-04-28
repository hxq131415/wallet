//
//  PlanOrderContentView.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/24.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class PlanOrderContentView: UICollectionViewCell,UITextFieldDelegate {

    @IBOutlet weak var reservationAmountLabel: UILabel!
    @IBOutlet weak var reservationAmountField: UITextField!
    @IBOutlet weak var queueNoLabel: UILabel!
    @IBOutlet weak var queueNoField: UITextField!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    @IBOutlet weak var waitingTimeField: UITextField!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var takeNoBtn: UIButton!
    
    var takeNoTapClosure:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        subViewInitialization()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //先边框
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor(red: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.5).cgColor
        
        //中阴影
        self.layer.shadowColor = UIColor(red: 138.0 / 255.0, green: 138.0 / 255.0, blue: 138.0 / 255.0, alpha: 0.5).cgColor
        self.layer.shadowOpacity = 1//不透明度
        self.layer.shadowRadius = 2//设置阴影所照射的范围
        self.layer.shadowOffset = CGSize(width: 0, height: 0)// 设置阴影的偏
        //后设置圆角
        self.layer.cornerRadius = 4
    }
    
    func subViewInitialization() {
        
        self.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        
        reservationAmountField.borderStyle = .none
        queueNoField.borderStyle = .none
        waitingTimeField.borderStyle = .none
        
        reservationAmountField.setValue(UIColorFromRGB(hexRGB: 0xAAAAAA), forKeyPath: "_placeholderLabel.textColor")
        reservationAmountField.setValue(UIFont.systemFont(ofSize: 15), forKeyPath: "_placeholderLabel.font")
        
        reservationAmountField.placeholder = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanOrderPage_amount_textfield_placehorder_text_key)
        reservationAmountField.font = UIFont.systemFont(ofSize: 16)
        reservationAmountField.keyboardType = UIKeyboardType.decimalPad
        reservationAmountField.returnKeyType = .done
        reservationAmountField.delegate = self
        
        let amountRightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        amountRightLbl.configLabel(text: "ETC", textAlignment: .right, textColor: UIColorFromRGB(hexRGB: 0x2e2922), font: UIFont.systemFont(ofSize: 18))
        amountRightLbl.sizeToFit()
        reservationAmountField.rightView = amountRightLbl
        reservationAmountField.rightViewMode = .always
        
        reservationAmountLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanOrderPage_amount_Title_text_key)
        queueNoLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanOrderPage_amount_queueNo_text_key)
        waitingTimeLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanOrderPage_amount_waiting_time_text_key)
        bottomLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanOrderPage_amount_bottom_lbl_text_key)
        takeNoBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanOrderPage_amount_takeNo_btn_title_key), for: UIControlState.normal)
        takeNoBtn.cornerRadius = 24
        
    }
    
    @IBAction func takeNoAction(_ sender: UIButton) {
        self.endEditing(true)
        if takeNoTapClosure != nil {
            takeNoTapClosure!()
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
