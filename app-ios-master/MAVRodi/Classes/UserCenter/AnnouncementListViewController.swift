//
//  AnnouncementListViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/19.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  公告列表

import UIKit
import ObjectMapper

class AnnouncementListViewController: MRBaseViewController {

    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    let bgView = UIView(frame:CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    let bgView1 = UIView(frame:CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
    
    private var announceList: [AnnouncementListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: AnnouncementListPage_navigation_title_key)
        
        self.subViewInitalzations()
        self.requestForAnnouncementList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return false
    }
    
    override func navigationBarStyle() -> UIBarStyle {
        return UIBarStyle.default
    }
    
    override var statusBarBackgroundColor: UIColor? {
        return MRColorManager.StatusBarBackgroundColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initlzations
    func subViewInitalzations() {
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = MRColorManager.TableViewSeparatorLineDarkColor
        mainTableView.backgroundColor = MRColorManager.Table_Collection_ViewBackgroundColor
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        mainTableView.register(UINib(nibName: "AnnouncementListCell", bundle: nil), forCellReuseIdentifier: "AnnouncementListCell")
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
        
        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))

        let imageView = TableViewBgView(frame:CGRect.zero)
        imageView.addBgViewToSuperView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: Main_Screen_Width), tips:  MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Announcement_title_key), image: UIImage(named: "bgImage")!)
        bgView.addSubview(imageView)
        
        mainTableView.backgroundView=bgView
        
    }
    
    // MARK: - Action
    
    
    // MARK: - Request
    func requestForAnnouncementList() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_NOTICE_ANNOUNCEMENT_LIST, parameters: nil, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dataArr = data as? [[String: Any]] {
                        weakSelf.announceList = Mapper<AnnouncementListModel>().mapArray(JSONArray: dataArr)
                    }
                    
                    weakSelf.mainTableView.reloadData()
                }
                else {
                    if let msg = message , !msg.isEmpty {
                        weakSelf.showBottomMessage(msg)
                    }
                }
            }
        }
    }
}

// MAKR: - UITableViewDelegate & UITableViewDataSource
extension AnnouncementListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.announceList.count != 0)
        {
            mainTableView.backgroundView=bgView1
        }
        else
        {
            mainTableView.backgroundView=bgView
        }
        return self.announceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < self.announceList.count else {
            return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementListCell", for: indexPath) as? AnnouncementListCell {
            
            let model = self.announceList[indexPath.row]
            cell.configCellWithModel(model: model)
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < self.announceList.count {
            let model = self.announceList[indexPath.row]
            model.is_read = true
            
            if let cell = tableView.cellForRow(at: indexPath) as? AnnouncementListCell {
                cell.configCellWithModel(model: model)
            }
            
            let detailViewCtrl = AnnouncementDetailViewController(title:MRLocalizableStringManager.localizableStringFromTableHandle(key: AnnouncementDetailPage_navigation_title_key)
                , url: nil, htmlText: model.content)
            detailViewCtrl.model = model
            self.navigationController?.pushViewController(detailViewCtrl, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
