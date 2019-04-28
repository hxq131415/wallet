//
//  UserCenterTableHeaderView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/4.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class UserCenterTableHeaderView: UIView {
    
//    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var headerTopConstaint: NSLayoutConstraint!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userInfoLbl: UILabel!
    @IBOutlet weak var leftLbl: UILabel!
    @IBOutlet weak var rightLbl: UILabel!
    
    var addFriendBtnTapClosure: (() -> ())?
    var textLblTapClosure: ((_ isLeft: Bool) -> ())?
    var headImageViewTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userInfoView.backgroundColor = UIColor.clear
        self.userInfoView.layer.shadowColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0.2).cgColor
        self.userInfoView.layer.shadowOffset = CGSize(width: -1, height: -1)
        self.userInfoView.layer.shadowRadius = 23
        self.userInfoView.layer.shadowOpacity = 1
        
        if iSiPhoneX() {
            headerTopConstaint.constant = 86 * theScaleToiPhone_6
        }
        
        self.contentBackgroundView.layer.masksToBounds = true
        self.contentBackgroundView.layer.cornerRadius = 8
        
        self.contentBackgroundView.layer.borderColor = MRColorManager.LightGrayBorderColor.cgColor
        self.contentBackgroundView.layer.borderWidth = 1
        
        self.headerImgView.layer.masksToBounds = true
        self.headerImgView.layer.cornerRadius = self.headerImgView.height() * 0.5
//        self.headerImgView.layer.borderColor = UIColor.white.cgColor
//        self.headerImgView.layer.borderWidth = 2
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.headImageViewTapAction))
        tapGesture.numberOfTapsRequired = 1
        self.headerImgView.isUserInteractionEnabled = true
        self.headerImgView.addGestureRecognizer(tapGesture)
        
//        self.addFriendBtn.addTarget(self, action: #selector(self.addFriendBtnAction), for: UIControlEvents.touchUpInside)
        
        userNameLbl.text = nil
        userInfoLbl.text = nil
        
        leftLbl.numberOfLines = 2
        leftLbl.textAlignment = .center
        
        rightLbl.numberOfLines = 2
        rightLbl.textAlignment = .center
        
        let leftLblTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.leftLblTapGestrueAction))
        leftLblTapGesture.numberOfTapsRequired = 1
        leftLbl.isUserInteractionEnabled = true
        leftLbl.addGestureRecognizer(leftLblTapGesture)
        
        let rightLblTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.rightLblTapGestrueAction))
        rightLblTapGesture.numberOfTapsRequired = 1
        rightLbl.isUserInteractionEnabled = true
        rightLbl.addGestureRecognizer(rightLblTapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // MARK: - Action
    @objc func addFriendBtnAction() {
        
        if self.addFriendBtnTapClosure != nil {
            self.addFriendBtnTapClosure!()
        }
    }
    
    @objc func leftLblTapGestrueAction() {
        
        if self.textLblTapClosure != nil {
            self.textLblTapClosure!(true)
        }
    }
    
    @objc func rightLblTapGestrueAction() {
        
        if self.textLblTapClosure != nil {
            self.textLblTapClosure!(false)
        }
    }
    
    @objc func headImageViewTapAction() {
        
        if self.headImageViewTapClosure != nil {
            self.headImageViewTapClosure!()
        }
    }
    
    func configHeaderViewWithUserModel(userInfo: UserDataModel?) {
        
        if let userModel = userInfo {
            
            headerImgView.oss_ntSetImageWithURL(urlStr: userInfo?.avatar, placeholderImage: UIImage(named: "icon_default_head"))
            
            userNameLbl.text = userModel.nickname
            userInfoLbl.font = UIFont.systemFont(ofSize: 15)
            userInfoLbl.text = userModel.level
            
            let leftTextString = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_sharing_navigation_title_key)
            let leftText = String(format: "%@\n%.6f", leftTextString, userModel.invitation_reward)
            
            let leftTextParaphStyle = NSMutableParagraphStyle()
            leftTextParaphStyle.alignment = .center
            leftTextParaphStyle.lineSpacing = 4
            
            var textFontSize: CGFloat = 15
            if Main_Screen_Width < 375.0 {
                textFontSize = 14
            }
            
            let leftAttrText = NSMutableAttributedString(string: leftText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: textFontSize), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e), NSAttributedStringKey.paragraphStyle: leftTextParaphStyle])
            leftAttrText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x2e2922)], range: (leftText as NSString).range(of: String(format: "%.6f", userModel.invitation_reward)))
            leftLbl.attributedText = leftAttrText
            
            let rightTextString = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_leadership_navigation_title_key)
            let rightText = String(format: "%@\n%.6f", rightTextString, userModel.management_reward)
            
            let rightTextParaphStyle = NSMutableParagraphStyle()
            rightTextParaphStyle.alignment = .center
            
            let rightAttrText = NSMutableAttributedString(string: rightText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: textFontSize), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e), NSAttributedStringKey.paragraphStyle: leftTextParaphStyle])
            rightAttrText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x2e2922)], range: (rightText as NSString).range(of: String(format: "%.6f", userModel.management_reward)))
            rightLbl.attributedText = rightAttrText
        }
        else {
            let leftTextString = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_sharing_navigation_title_key)
            let leftText = String(format: "%@\n%.6f", leftTextString, 0)
            
            let leftTextParaphStyle = NSMutableParagraphStyle()
            leftTextParaphStyle.alignment = .center
            leftTextParaphStyle.lineSpacing = 4
            
            var textFontSize: CGFloat = 15
            if Main_Screen_Width < 375.0 {
                textFontSize = 14
            }
            
            let leftAttrText = NSMutableAttributedString(string: leftText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: textFontSize), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e), NSAttributedStringKey.paragraphStyle: leftTextParaphStyle])
            leftAttrText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x2e2922)], range: (leftText as NSString).range(of: String(format: "%.6f", 0)))
            leftLbl.attributedText = leftAttrText
            
            let rightTextString = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_leadership_navigation_title_key)
            let rightText = String(format: "%@\n%.6f", rightTextString, 0)
            
            let rightTextParaphStyle = NSMutableParagraphStyle()
            rightTextParaphStyle.alignment = .center
            
            let rightAttrText = NSMutableAttributedString(string: rightText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: textFontSize), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e), NSAttributedStringKey.paragraphStyle: leftTextParaphStyle])
            rightAttrText.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x2e2922)], range: (rightText as NSString).range(of: String(format: "%.6f", 0)))
            rightLbl.attributedText = rightAttrText
        }
    }
    
}
