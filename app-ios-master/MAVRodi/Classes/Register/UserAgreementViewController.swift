//
//  UserAgreementViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/11.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  用户协议

import UIKit

class UserAgreementViewController: MRBaseViewController {

    private var textView: UITextView = {
        let textVw_ = UITextView(frame: CGRect.zero)
        return textVw_
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: UserAgreement_Navigation_title_key)
        
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
        
        if let htmlText = MRCommonShared.shared.config?.registrationAgreement , let data = htmlText.data(using: String.Encoding.unicode) {
            
            do {
                textView.attributedText = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        }
    }
    
    override var statusBarBackgroundColor: UIColor? {
        return MRColorManager.StatusBarBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
