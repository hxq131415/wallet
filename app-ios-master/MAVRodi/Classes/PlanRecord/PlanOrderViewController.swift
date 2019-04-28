//
//  PlanOrderViewController.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/24.
//  Copyright © 2018年 是心作佛. All rights reserved.
//
//  预约排单

import UIKit

class PlanOrderViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    var contentView: PlanOrderContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xF5F5F5)
        self.subViewInitlzation()
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

    // MARK: - Intialization
    func subViewInitlzation() {
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.bottomLine.isHidden = true
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanReservation_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
     
        contentView = Bundle.main.loadNibNamed("PlanOrderContentView", owner: self, options: nil)?.last as? PlanOrderContentView
        contentView.frame = CGRect(x: 20, y: navBarView.height() + 12, width: Main_Screen_Width - 40, height: 455 * theScaleToiPhone_6)
        self.view.addSubview(contentView)
        
        contentView.backgroundColor = UIColor.white
        contentView.takeNoTapClosure = {
            
        }
        
    }
}
