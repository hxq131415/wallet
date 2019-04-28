//
//  MyRewardViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/10.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit


class MyRewardViewController: MRBaseViewController {

//    var rewardType: MRRewardType = .sharing
//
//    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
//    var tableHeaderVw: MyRewardHeaderView!
//
//    private var rewardModel: MyRewardModel?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        if rewardType == .sharing {
//            self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_sharing_navigation_title_key)
//        }
//        else {
//            self.navigationItem.title = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_leadership_navigation_title_key)
//        }
//
//        self.subViewInitalzations()
//
//        self.requestForGetRewardInfo()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
//
//    override func isNavigationBarToHidden() -> Bool {
//        return false
//    }
//
//    override func navigationBarStyle() -> UIBarStyle {
//        return UIBarStyle.black
//    }
//
//    override var statusBarBackgroundColor: UIColor? {
//        return MRColorManager.StatusBarBackgroundColor
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.default
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Initlzations
//    func subViewInitalzations() {
//
//        self.view.addSubview(mainTableView)
//        mainTableView.snp.remakeConstraints { (make) in
//            make.top.equalToSuperview().offset(0)
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//
//        mainTableView.delegate = self
//        mainTableView.dataSource = self
//        mainTableView.separatorColor = MRColorManager.TableViewSeparatorLineDarkColor
//        mainTableView.backgroundColor = MRColorManager.Table_Collection_ViewBackgroundColor
//
//        mainTableView.showsVerticalScrollIndicator = false
//        mainTableView.showsHorizontalScrollIndicator = false
//
//        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCellNull")
//
//        mainTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
//
//        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: CGFloat.leastNormalMagnitude))
//
//    }
//
//    // MARK: - Request
//    func requestForGetRewardInfo() {
//
//        var params: [String: Any] = [:]
//        params["type"] = rewardType.rawValue
//
//        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
//
//        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_GET_REWARD_INFO, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
//            if let weakSelf = self {
//                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
//                if status == 0 {
//                    if let dict = data as? [String: Any] {
//                        weakSelf.rewardModel = MyRewardModel(JSON: dict)
//                    }
//
//                    weakSelf.mainTableView.reloadData()
//                }
//                else {
//                    // 加载失败了
//                    if let errMsg = message , !errMsg.isEmpty {
//                        weakSelf.showBottomMessage(errMsg)
//                    }
//                    else {
//                        weakSelf.showBottomMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_loading_faild_message))
//                    }
//                }
//            }
//        }
//    }
//
//}
//
//// MAKR: - UITableViewDelegate & UITableViewDataSource
//extension MyRewardViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let model = self.rewardModel else {
//            return 0
//        }
//
//        return model.recordList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let model = self.rewardModel else {
//            return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
//        }
//
//        if indexPath.row < model.recordList.count {
//            var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellForMyRewardList")
//
//            if cell == nil {
//                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "UITableViewCellForMyRewardList")
//            }
//
//            cell?.selectionStyle = .default
//
//            let recordModel = model.recordList[indexPath.row]
//
//            cell?.textLabel?.textColor = MRColorManager.DarkBlackTextColor
//            cell?.textLabel?.textAlignment = .left
//            cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
//            if rewardType == .sharing {
//                cell?.textLabel?.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_sharing_navigation_title_key)
//            }
//            else {
//                cell?.textLabel?.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: MyReward_leadership_navigation_title_key)
//            }
//
//            cell?.detailTextLabel?.textColor = UIColorFromRGB(hexRGB: 0x7e7e7e)
//            cell?.detailTextLabel?.textAlignment = .left
//            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 10)
//            cell?.detailTextLabel?.text = recordModel.add_time
//
//            cell?.accessoryType = .none
//
//            let rightLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//            rightLbl.textColor = UIColorFromRGB(hexRGB: 0x365ad8)
//            rightLbl.textAlignment = .right
//            rightLbl.font = UIFont.systemFont(ofSize: 18)
//            rightLbl.text = recordModel.amount
//            rightLbl.sizeToFit()
//
//            cell?.accessoryView = rightLbl
//
//            return cell ?? tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
//        }
//
//        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCellNull", for: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if section == 0 {
//            let tableHeaderVw = Bundle.main.loadNibNamed("MyRewardHeaderView", owner: nil, options: nil)?.first as! MyRewardHeaderView
//            tableHeaderVw.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 202)
//            tableHeaderVw.configHeaderViewWithModel(rewardModel: self.rewardModel, rewardType: rewardType)
//            return tableHeaderVw
//        }
//        return nil
//    }
//
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return nil
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 202
//        }
//        return CGFloat.leastNormalMagnitude
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.leastNormalMagnitude
//    }
    
}



