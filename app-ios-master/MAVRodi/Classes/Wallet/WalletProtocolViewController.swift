//
//  WalletProtocolViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/10/8.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class WalletProtocolViewController: MRWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.customLeftBackItemButtonWithImageName("icon_back_black")
        self.customNavigationTitleAttributes()
        self.customNavigationBarBackgroundImageWithoutBottomLine()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletProtocolPage_navigation_title_key)
        self.navTitle = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletProtocolPage_navigation_title_key)
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
    
    override func subViewInitlzation() {
        super.subViewInitlzation()
        
        mainWebView.scalesPageToFit = true
    }
    
    override func loadRequestForWebView() {
        
        if let filePath = Bundle.main.path(forResource: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletProtocolPage_what_privatekey_txt_filename_key), ofType: nil) {
            let fileUrl = URL(fileURLWithPath: filePath)
            let req = URLRequest(url: fileUrl)
            mainWebView.loadRequest(req)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
