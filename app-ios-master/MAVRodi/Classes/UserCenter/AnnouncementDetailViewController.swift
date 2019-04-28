//
//  AnnouncementDetailViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/19.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  公告详情

import UIKit

class AnnouncementDetailViewController: MRWebViewController {

    var model: AnnouncementListModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.requestForAnnouncementDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var statusBarBackgroundColor: UIColor? {
        return MRColorManager.StatusBarBackgroundColor
    }
    
    // MARK: - Request
    // 只为刷掉未读状态
    func requestForAnnouncementDetail() {
        
        var params: [String: Any] = [:]
        params["type"] = model.type
        params["id"] = model.id
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_NOTICE_ANNOUNCEMENT_DETAIL, parameters: params, requestInfo: nil) { (_, _, _) in
            
        }
    }
    

}
