//
//  BucketPrivateKeyContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class BucketPrivateKeyContentView: UIView {

    @IBOutlet weak var checkPrivateKeyBtn: UIButton!
    @IBOutlet weak var topContentBackgroundVw: UIView!
    @IBOutlet weak var topTitleLblContentView: UIView!
    
    @IBOutlet weak var ethTitleLbl: UILabel!
    @IBOutlet weak var etcTitleLbl: UILabel!
    @IBOutlet weak var topTitleLbl: UILabel!
    @IBOutlet weak var topContentLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var ethPrivateKeyLbl: UILabel!
    @IBOutlet weak var etcPrivateKeyLbl: UILabel!
    @IBOutlet weak var topTextLbl: UILabel!
    
    var checkPrivateKeyBtnTapClosure: (() -> ())?
    var confirmBtnTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topContentBackgroundVw.backgroundColor = UIColor.white
        
        topTitleLblContentView.layer.cornerRadius = 8
        topTitleLblContentView.layer.masksToBounds = true
        topTitleLblContentView.layer.borderWidth = 1
        topTitleLblContentView.layer.borderColor = UIColorFromRGB(hexRGB: 0xe80000).cgColor
        
        topTextLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: BucketPrivateKeyPage_top_lbl_text_key)
        
        topTitleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: BucketPrivateKeyPage_top_reminder_title_key)
        topContentLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: BucketPrivateKeyPage_top_reminder_content_key)
        
        ethTitleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: BucketPrivateKeyPage_eth_lbl_title_key)
        etcTitleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: BucketPrivateKeyPage_etc_lbl_title_key)
        
        checkPrivateKeyBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: BucketPrivateKeyPage_what_privatekey_btn_title_key), for: UIControlState.normal)
        checkPrivateKeyBtn.addTarget(self, action: #selector(self.checkPrivateKeyBtnAction), for: UIControlEvents.touchUpInside)
        
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: BucketPrivateKeyPage_bottom_btn_title_key), for: UIControlState.normal)
        confirmBtn.addTarget(self, action: #selector(self.confirmBtnAction), for: UIControlEvents.touchUpInside)
        confirmBtn.layer.cornerRadius = confirmBtn.height() / 2
        confirmBtn.layer.masksToBounds = true
    }
    
    @objc func checkPrivateKeyBtnAction() {
        
        if checkPrivateKeyBtnTapClosure != nil {
            checkPrivateKeyBtnTapClosure!()
        }
    }
    
    @objc func confirmBtnAction() {
        
        if confirmBtnTapClosure != nil {
            confirmBtnTapClosure!()
        }
    }
    
}
