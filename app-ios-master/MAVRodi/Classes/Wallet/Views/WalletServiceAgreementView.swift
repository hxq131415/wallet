//
//  WalletServiceAgreementView.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/25.
//  Copyright © 2018年 是心作佛. All rights reserved.
//
//  跳转创建钱包弹出的服务协议视图

import UIKit

class WalletServiceAgreementView: UITableViewCell {

    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var agreementBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    var confirmActionClosure:(() -> ())?
    var cancelonfirmActionClosure:(() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: Wallet_service_agreement_text_key)
        confirmBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Wallet_service_confirm_title_key), for: UIControlState.normal)
        agreementBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Wallet_service_agreemen_title_key), for: UIControlState.normal)
        
        agreementBtn.setImage(UIImage(named: "icon_reg_language_normal"), for: UIControlState.normal)
        agreementBtn.setImage(UIImage(named: "icon_reg_language_selected"), for: UIControlState.selected)
    
        confirmBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        confirmBtn.setTitleColor(UIColorFromRGB(hexRGB: 0xaaaaaa), for: UIControlState.disabled)
        confirmBtn.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0x33c6b3)), for: UIControlState.normal)
        confirmBtn.setBackgroundImage(UIImage(color: UIColorFromRGB(hexRGB: 0xeeeeee)), for: UIControlState.disabled)
        
        confirmBtn.layer.cornerRadius = confirmBtn.height() / 2
        confirmBtn.layer.masksToBounds = true
        
        agreementBtn.titleRightAndImageLeftSetting(withSpace: 5)
        agreementBtn.isSelected = false
        confirmBtn.isEnabled = agreementBtn.isSelected
        
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.scrollView.bouncesZoom = false
        webView.allowsInlineMediaPlayback = true
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        if #available(iOS 9.0, *) {
            webView.allowsPictureInPictureMediaPlayback = true
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        // 去掉WebView底部莫名黑色边
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        
        webView.dataDetectorTypes = .init(rawValue: 0)
        
    }

    func loadFile() {
        
        if let filePath = Bundle.main.path(forResource: MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletProtocolPage_what_privatekey_txt_filename_key), ofType: nil) {
            let fileUrl = URL(fileURLWithPath: filePath)
            let req = URLRequest(url: fileUrl)
            webView.loadRequest(req)
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        if cancelonfirmActionClosure != nil {
            cancelonfirmActionClosure!()
        }
    }
    @IBAction func agreementAction(_ sender: UIButton) {
        agreementBtn.isSelected = !agreementBtn.isSelected
        confirmBtn.isEnabled = agreementBtn.isSelected
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        if confirmActionClosure != nil {
            confirmActionClosure!()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension WalletServiceAgreementView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        // 禁止选择和长按弹框
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none';")
    }
}

extension WalletServiceAgreementView {
    
    static func showWalletServiceAgreementView(superV: UIView, confirmTapClosure: @escaping (() -> Void)) -> Void {
        
        let agreementView = Bundle.main.loadNibNamed("WalletServiceAgreementView", owner: self, options: nil)?.last as! WalletServiceAgreementView
        agreementView.frame = CGRect(x: 0, y: 0, width: 317 * theScaleToiPhone_6, height: 480 * theScaleToiPhone_6)
        
        let backView = UIView(frame: superV.bounds)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        agreementView.center = backView.center
        backView.addSubview(agreementView)
        
        superV.addSubview(backView)
        
        agreementView.loadFile()
        agreementView.confirmActionClosure = {
            backView.removeFromSuperview()
            confirmTapClosure()
        }
        agreementView.cancelonfirmActionClosure = {
            backView.removeFromSuperview()
        }
    }
    
}
