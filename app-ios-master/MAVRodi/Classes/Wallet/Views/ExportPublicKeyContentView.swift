//
//  BucketPrivateKeyContentView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class ExportPublicKeyContentView: UIView {

    @IBOutlet weak var topContentBackgroundVw: UIView!
    
    @IBOutlet weak var ethPrivateKeyLbl: UILabel!
    @IBOutlet weak var etcPrivateKeyLbl: UILabel!
    @IBOutlet weak var ethCopyBtn: UIButton!
    @IBOutlet weak var etcCopyBtn: UIButton!
    
    @IBOutlet weak var ethTitleLbl: UILabel!
    @IBOutlet weak var etcTitleLbl: UILabel!
    
    var ethCopyBtnTapClosure: (() -> ())?
    var etcCopyBtnTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ethTitleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportPublicKeyPage_eth_lbl_title_key)
        etcTitleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportPublicKeyPage_etc_lbl_title_key)
        
        topContentBackgroundVw.backgroundColor = UIColor.white
        
        ethCopyBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportPublicKeyPage_copy_btn_title_key), for: UIControlState.normal)
        etcCopyBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportPublicKeyPage_copy_btn_title_key), for: UIControlState.normal)
        
        ethCopyBtn.addTarget(self, action: #selector(self.ethCopyBtnAction), for: UIControlEvents.touchUpInside)
        etcCopyBtn.addTarget(self, action: #selector(self.etcCopyBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    @objc func ethCopyBtnAction() {
        
        if ethCopyBtnTapClosure != nil {
            ethCopyBtnTapClosure!()
        }
    }
    
    @objc func etcCopyBtnAction() {
        
        if etcCopyBtnTapClosure != nil {
            etcCopyBtnTapClosure!()
        }
    }
    
}
