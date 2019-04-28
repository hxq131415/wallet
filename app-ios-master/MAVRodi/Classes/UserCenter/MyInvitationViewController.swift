//
//  MyInvitationViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  邀请

import UIKit

class MyInvitationViewController: MRBaseViewController {
    
    lazy var headerImageVw: UIImageView = UIImageView(frame: CGRect.zero)
    
    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var titleLbl: UILabel = {
        let textLbl = UILabel(frame: CGRect.zero)
        return textLbl
    }()
    
    // 生成二维码信息的字符串
    var qrcodeString: String = ""
    // 邀请码
    var invitationCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x020202)
        self.subViewInitlzation()
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Intialization
    func subViewInitlzation() {
        
        headerImageVw.image = UIImage(named: "icon_invitation_bg")
        headerImageVw.frame = CGRect(x: 0, y: iSiPhoneX() ? 40 : 20, width: Main_Screen_Width, height: 215 * theScaleToiPhone_6)
        self.view.addSubview(headerImageVw)
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.bottomLine.isHidden = true
        navBarView.titleLbl.text = nil
        navBarView.backButtonImage = UIImage(named: "icon_back_white")
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        self.view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(headerImageVw.snp.bottom).offset(12 * theScaleToiPhone_6)
        }
        
        titleLbl.configLabel(text: "", numberOfLines: 0, textAlignment: NSTextAlignment.center, textColor: UIColorFromRGB(hexRGB: 0xf7ca5a), font: UIFont.systemFont(ofSize: 15))
        titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyInvitationPage_titleLbl_text_key)
        
        
        let qrContentView = Bundle.main.loadNibNamed("MyInvitationContentView", owner: self, options: nil)?.last as! MyInvitationContentView
        qrContentView.frame = CGRect(x: 20, y: headerImageVw.frame.maxY + 23 * theScaleToiPhone_6, width: 332 * theScaleToiPhone_6, height: 387 * theScaleToiPhone_6)
        self.view.addSubview(qrContentView)
        qrContentView.qrcodeString = self.qrcodeString
        qrContentView.invitationCode = self.invitationCode
        
        
    }
    
}
