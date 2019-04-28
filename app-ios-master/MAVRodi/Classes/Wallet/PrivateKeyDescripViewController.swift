//
//  PrivateKeyDescripViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  什么是私钥？

import UIKit

class PrivateKeyDescripViewController: MRBaseViewController {

    private var textView: UITextView = {
        let textVw_ = UITextView(frame: CGRect.zero)
        return textVw_
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.customLeftBackItemButtonWithImageName("icon_back_black")
        self.customNavigationTitleAttributes()
        self.customNavigationBarBackgroundImageWithoutBottomLine()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: WhatIsPrivateKeyPage_navigation_title_key)
        
        self.view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textAlignment = .left
        textView.textColor = MRColorManager.DarkBlackTextColor
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 20, bottom: 11, right: 30)
        textView.isEditable = false
        textView.isSelectable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        
        if let filePath = Bundle.main.path(forResource: MRLocalizableStringManager.localizableStringFromTableHandle(key: WhatIsPrivateKeyPage_what_privatekey_txt_filename_key), ofType: nil) {
            if let textStr = try? String(contentsOfFile: filePath, encoding: String.Encoding.utf8) {
                
                let boldText = MRLocalizableStringManager.localizableStringFromTableHandle(key: WhatIsPrivateKeyPage_bold_text_key)
                let attributesText = NSMutableAttributedString(string: textStr, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x2e2922)])
                attributesText.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x2e2922)], range: (textStr as NSString).range(of: boldText))
                
                textView.attributedText = attributesText
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isNavigationBarToHidden() {
            self.customLeftBackItemButtonWithImageName("icon_back_black")
            self.customNavigationTitleAttributes()
            self.customNavigationBarBackgroundImageWithoutBottomLine()
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return false
    }
    
    // MARK: - Overrides
    override func customNavigationTitleAttributes() {
        
        let paragphStyle = NSMutableParagraphStyle()
        paragphStyle.alignment = .center
        
        let attributes = [NSAttributedStringKey.foregroundColor : UIColorFromRGB(hexRGB: 0x333333), NSAttributedStringKey.font : TE_NavigationTitle_Font, NSAttributedStringKey.paragraphStyle: paragphStyle]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    override func customNavigationBarBackgroundImageWithoutBottomLine() {
        
        let navBgImg = UIImage(color: MRColorManager.LightGrayBackgroundColor)
        self.navigationController?.navigationBar.setBackgroundImage(navBgImg, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
