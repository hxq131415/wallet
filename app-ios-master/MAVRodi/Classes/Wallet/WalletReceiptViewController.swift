//
//  WalletReceiptViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  收款

import UIKit

class WalletReceiptViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var receiptView: WalletReceiptContentView = {
        let receiptView_ = WalletReceiptContentView(frame: CGRect.zero)
        return receiptView_
    }()
    
    var model: WalletHomeListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xe9eaeb)
        
        self.subViewInitialization()
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Intialization
    func subViewInitialization() {
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.statusBar.backgroundColor = MRColorManager.StatusBarBackgroundColor
        navBarView.bottomLine.isHidden = true
        navBarView.titleLbl.text = (model.name ?? "") + "-" + MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletReceiptPage_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        self.view.addSubview(receiptView)
        receiptView.snp.makeConstraints { (make) in
            make.width.equalTo(332 * theScaleToiPhone_6)
            make.height.equalTo(455 * theScaleToiPhone_6)
            make.top.equalTo(self.navBarView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        receiptView.iocnImgView.oss_ntSetImageWithURL(urlStr: model.logo ?? "", placeholderImage: nil)
        receiptView.topLbl.configLabel(text: model.address, textAlignment: NSTextAlignment.left, textColor: MRColorManager.DarkBlackTextColor, font: UIFont.systemFont(ofSize: 15))
        receiptView.topLbl.numberOfLines = 0
        receiptView.qrCodeView.configQRCodeContent(content: model.address ?? "")
        
        
        receiptView.copyBtnTapClosure = { [weak self] in
            if let weakSelf = self {
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = weakSelf.model.address
                
                weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_copyed_prompt_text_key))
            }
        }
        
        receiptView.shareAddressBtnTapClosure = {
            
        }
    }
    

}
