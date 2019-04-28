//
//  InnvitationBottomDescripView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class InnvitationBottomDescripView: UIView {

    @IBOutlet weak var topTextLbl: UILabel!
    @IBOutlet weak var invitationCodeLbl: UILabel!
    @IBOutlet weak var downloadReminderLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topTextLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key:  MyInvitation_myinvitation_lbl_text_key)
        downloadReminderLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyInvitation_scancode_download_reminder_text_key)
        bottomLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyInvitation_bottom_lbl_text_key)
        
        copyBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: ExportPublicKeyPage_copy_btn_title_key), for: UIControlState.normal)
        copyBtn.layer.cornerRadius = 25 * 0.5
        copyBtn.layer.masksToBounds = true
        
        copyBtn.addTarget(self, action: #selector(self.copyBtnAction), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: - Action
    @objc func copyBtnAction() {
        
        if let invitateInfo = MRCommonShared.shared.userInfo?.invitationInformation {
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = invitateInfo
            MRTools.currentDisplayingViewController()?.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_copyed_prompt_text_key))
        }
    }
    
}
