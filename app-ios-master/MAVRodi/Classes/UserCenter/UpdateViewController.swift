//
//  UpdateViewController.swift
//  MAVRodi
//
//  Created by HJY on 2018/11/26.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class UpdateViewController: MRBaseViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    //Latest version already
    @IBOutlet weak var detailLael: UILabel!
    @IBOutlet weak var UpdateDetailLbl: UILabel!
    
    var needUpdate: Bool = false
    
    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBtn.frame = CGRect(x: 0, y: 0, width: 160 * theScaleToiPhone_6, height: 48 * theScaleToiPhone_6)

        updateBtn.snp.makeConstraints { (make) in
            make.width.equalTo(160 * theScaleToiPhone_6)
            make.height.equalTo(48 * theScaleToiPhone_6)
            make.top.equalTo(versionLabel.snp.bottom).offset(26)
//            make.centerX.equalToSuperview()
        }
        
        
        updateBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x33c6b3)
        
        updateBtn.layer.cornerRadius = updateBtn.height() / 2
        updateBtn.layer.masksToBounds = true
//        updateBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x16a2ac).cgColor
//        updateBtn.layer.borderWidth = 1.0
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.bottomLine.isHidden = true
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: UpdatePage_navigationItem_title_key)
        navBarView.backButtonImage = UIImage(named: "icon_back_black")
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        detailLael.text = ""
        UpdateDetailLbl.text = ""
        UpdateDetailLbl.alpha = 0.0
        if let appVersion = appBundleShortVersion {
            versionLabel.text = "v.\(appVersion)"
        }
        
        updateBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: UpdatePage_update_btn_title_key), for: UIControlState.normal)
        
        let udAppVersion = MRCommonShared.shared.config?.version
        let currentVersion = appBundleShortVersion
        
        if let udVersion = udAppVersion, let curVersion = currentVersion {
            if udVersion.compare(curVersion, options: NSString.CompareOptions.numeric) == .orderedDescending {
                // 1.0 -> 1.2 版本升级
                needUpdate = true
//                UpdateDetailLbl.alpha = 1.0
            }else {
//                UpdateDetailLbl.alpha = 0.0
                detailLael.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: UpdatePage_update_lbl_text_key)
            }
        }
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    @IBAction func updateAction(_ sender: UIButton) {
        
        if needUpdate {
            UpdateAlertView.showUpdateAlertView(superV: ShareDelegate.window ?? self.view) {
                //下载
                if let download_url = MRCommonShared.shared.config?.download_url , let url = URL(string: download_url),  UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
            
            /*
            let alertCtrl = MRAlertController(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MRUpdateVersioAlert_title_key), message: MRLocalizableStringManager.localizableStringFromTableHandle(key: MRUpdateVersioAlert_update_content_key), preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MRUpdateVersioAlert_update_left_btn_title_key), style: UIAlertActionStyle.cancel) { (_) in
                
            }
            
            let confirmAction = UIAlertAction(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: MRUpdateVersioAlert_update_right_btn_title_key), style: UIAlertActionStyle.default) { (_) in
                
                if let download_url = MRCommonShared.shared.config?.download_url , let url = URL(string: download_url),  UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
            
            alertCtrl.addAction(cancelAction)
            alertCtrl.addAction(confirmAction)
            
            dispatch_after_in_main(1, block: {
                MRTools.currentDisplayingViewController()?.present(alertCtrl, animated: true, completion: nil)
            })
            **/
        }
        else
        {
        self.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: UpdatePage_update_lbl_text_key))
        }
    }
    
}
