//
//  MyInvitationContentView.swift
//  MAVRodi
//
//  Created by HJY on 2018/11/26.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit
import EFQRCode

class MyInvitationContentView: UITableViewCell {

    @IBOutlet weak var qrCodeView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var invitationNumLabel: UILabel!
    @IBOutlet weak var invitationTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyInvitation_scancode_download_reminder_text_key)
        invitationTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyInvitation_myinvitation_lbl_text_key)
        
        copyBtn.layer.cornerRadius = copyBtn.height() / 2
        copyBtn.layer.masksToBounds = true
    copyBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportPublicKeyPage_copy_btn_title_key), for: UIControlState.normal)
        
        let betaImageVw = UIImageView(frame: CGRect.zero)
        self.addSubview(betaImageVw)
        betaImageVw.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.greaterThanOrEqualTo(10)
            make.top.equalTo(10)
        }
        betaImageVw.image = UIImage(named: "icon_beta")
        betaImageVw.isHidden = (iSBETA != 1)
        
        
    }

    // 生成二维码信息的字符串
    var qrcodeString: String = "" {
        didSet{
            if let qrCodeImg = EFQRCode.generate(content: qrcodeString, backgroundColor: UIColor.white.cgColor, foregroundColor: UIColorFromRGB(hexRGB: 0x424242).cgColor, watermark: nil) {
                self.qrCodeView.image = UIImage(cgImage: qrCodeImg)
            }
        }
    }
    // 邀请码
    var invitationCode: String? = nil {
        didSet{
            invitationNumLabel.text = invitationCode
        }
    }
    
    @IBAction func copyAction(_ sender: UIButton) {
        if let invitateInfo = MRCommonShared.shared.userInfo?.invitationInformation {
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = invitateInfo
            MRTools.currentDisplayingViewController()?.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_copyed_prompt_text_key))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
