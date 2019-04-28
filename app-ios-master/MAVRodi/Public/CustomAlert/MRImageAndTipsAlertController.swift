//
//  MRImageAndTipsAlertController.swift
//  FriendOfFish
//
//  Created by rttx on 2018/7/18.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MRImageAndTipsAlertController: UIViewController {
    
    lazy var alertView: MRImageAndTipsAlertView = MRImageAndTipsAlertView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var alertViewWidth: CGFloat = 300
        var alertViewHeight: CGFloat = 242
        
        if Main_Screen_Width < 375 {
            alertViewWidth = 300 * theScaleToiPhone_6
            alertViewHeight = 242 * theScaleToiPhone_6
        }
        
        self.view.addSubview(alertView)
        alertView.snp.remakeConstraints { (make) in
            make.width.equalTo(alertViewWidth)
            make.height.equalTo(alertViewHeight)
            make.center.equalToSuperview()
        }
        
        alertView.textColor = MRColorManager.LightGrayTextColor
        alertView.configAlertView(imageName: "icon_home_equipment_ing", text: "正在喂食中...")
        alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        alertView.alpha = 0.0
        alertView.cornerRadius = 8
        
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertView() {
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let weakSelf = self {
                weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0.3)
                weakSelf.alertView.transform = CGAffineTransform.identity
                weakSelf.alertView.alpha = 1.0
            }
        }) { (_) in
            
        }
    }
    
    func hideAlertView() {
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            if let weakSelf = self {
                weakSelf.view.backgroundColor = UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0)
                weakSelf.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                weakSelf.alertView.alpha = 0.0
            }
        }) { [weak self](_) in
            if let weakSelf = self {
                weakSelf.dismiss(animated: false, completion: {
                    
                })
            }
        }
    }
    

}
