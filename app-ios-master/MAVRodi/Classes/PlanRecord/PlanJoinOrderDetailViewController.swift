//
//  PlanJoinOrderDetailViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/11.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  参与排单详情

import UIKit
import ObjectMapper

class PlanJoinOrderDetailViewController: MRBaseViewController  {

    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableHeaderView: PlanJoinOrderDetailViewHeaderView!

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var confirmBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    // 参与记录
    var joinRecord: PlanJoinRecordListModel?
    
    private var timr: Timer?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = MRColorManager.ViewControllerLightGrayBackgroundColor
        
        self.requestForArrivalDetail()
        self.subViewInitialization()
        self.initSetupTableView()
        self.initTableHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if mainCollectionView.numberOfItems(inSection: 0) > 0 {
//            mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//            curIndex = 0
//
//        }
        self.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.stopTimer()
    }
    
    override func isNavigationBarToHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initialization
    func subViewInitialization() {
        
        self.view.addSubview(navBarView)
        navBarView.backgroundColor = UIColor.clear
        navBarView.bottomLine.isHidden = true
        navBarView.rightButtonImage = UIImage(named: "icon_wh")
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_order_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        // 参与规则
        navBarView.rightButtonClosure = {
            
            let title = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_order_rule_title_key)
            let msg = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_order_rule_text_key)
            CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: msg) {
                
            }
//            let confirm = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key)
//            
//            MRCustomAlertController.showAlertController(title: title, message: msg, confirm: confirm, confirmClosure: {
//                
//            })
            
        }
        
        
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.width.equalTo(300 * theScaleToiPhone_6)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-(54 + Main_IndicatorBar_Height) * theScaleToiPhone_6)
        }
        confirmBtn.layer.cornerRadius = 24
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x16a2ac).cgColor
        confirmBtn.layer.borderWidth = 1.0

        confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_return_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0x16a2ac), font: UIFont.systemFont(ofSize: 16), normalImage: nil, selectedImage: nil, backgroundColor: nil)
        
        confirmBtn.addTarget(self, action: #selector(self.confirmBtnAction), for: UIControlEvents.touchUpInside)
        
    }
    
    override func appLanguageChanged(notifi: Notification) {
        if let model = joinRecord {
            tableHeaderView.configCellWithJoinRecordListModel(model: model)
        }
        self.tableView.reloadData()
    }
    
    func initTableHeaderView() {
        
        tableHeaderView = Bundle.main.loadNibNamed("PlanJoinOrderDetailViewHeaderView", owner: self, options: nil)?.last as? PlanJoinOrderDetailViewHeaderView
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 250)
        self.tableView.tableHeaderView = tableHeaderView
        if let model = joinRecord {
            tableHeaderView.configCellWithJoinRecordListModel(model: model)
        }
    }
    
    //MARK: - 初始化创建TableView
    func initSetupTableView() {
        
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.estimatedRowHeight = 90
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.bounces = false
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBarView.snp.bottom)
            make.bottom.equalTo(confirmBtn.snp.top).offset(20 * theScaleToiPhone_6)
            make.left.right.equalToSuperview()
        }
        
        tableView.register(UINib(nibName: "PlanJoinOrderDetailCell2", bundle: nil), forCellReuseIdentifier: "PlanJoinOrderDetailCell2")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }

    // MARK: - Action
    @objc func confirmBtnAction() {

        self.navigationController?.popViewController(animated: true)
    }
    //获取参与详情
    func requestForArrivalDetail() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        var params: [String: Any] = [:]
        params["id"] = self.joinRecord?.id
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_JOIN_LIhSTDETAIL, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        weakSelf.joinRecord = PlanJoinRecordListModel(JSON: dict)
                    weakSelf.tableHeaderView.configCellWithJoinRecordListModel(model: weakSelf.joinRecord!)
                        weakSelf.tableView.reloadData()
                        
                    }
                }
                else {
                    if let errMsg = message, !errMsg.isEmpty {
                        weakSelf.showMessage(errMsg)
                    }
                    else {
                        weakSelf.showMessage(MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Request_Send_Faild_Key))
                    }
                }
            }
        }
    }
    // MARK: - Methods
    func startTimer() {

        if timr == nil {
            timr = Timer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timr!, forMode: RunLoopMode.commonModes)
        }
    }

    func stopTimer() {

        timr?.invalidate()
        timr = nil
    }

    @objc func updateTimerAction() {

        
//        if curIndex < joinRecordList.count {
//            let record = joinRecordList[curIndex]
//
//            if let curCell = mainCollectionView.cellForItem(at: IndexPath(item: curIndex, section: 0)) as? PlanJoinOrderDetailCell {
//                curCell.configCellWithJoinRecordListModel(model: record)
//            }
//        }
    }

}

extension PlanJoinOrderDetailViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PlanJoinOrderDetailCell2 = tableView.dequeueReusableCell(withIdentifier: "PlanJoinOrderDetailCell2", for: indexPath) as! PlanJoinOrderDetailCell2
        //green 0x16a2ac
        //gray  0xaaaaaa
        cell.greenLineView.isHidden = false
        if indexPath.row == 0{
            cell.greenDotViewWidthConstraint.constant = 12
        }else if indexPath.row == 1 {
            cell.greenDotViewWidthConstraint.constant = 8
        }else if indexPath.row == 2 {
            cell.greenDotViewWidthConstraint.constant = 8
        }else if indexPath.row == 3 {
            cell.greenDotViewWidthConstraint.constant = 8
        }else if indexPath.row == 4 {
            cell.greenDotViewWidthConstraint.constant = 12
            cell.greenLineView.isHidden = true
        }
        cell.configCellWithJoinRecordListModel(model: joinRecord!,row: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//        if joinRecordList.count > 0 {
//            let joinModel = joinRecordList[0]
//            confirmBtn.isEnabled = !joinModel.is_packed
//            if joinModel.is_packed {
//                confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_wait_package_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e))
//            }
//            else {
//                confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_order_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e))
//            }
//        }
//        else {
//            confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_order_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e))
//        }
//
//        confirmBtn.layer.masksToBounds = true
//        confirmBtn.layer.cornerRadius = 8
//
//        confirmBtn.addTarget(self, action: #selector(self.confirmBtnAction), for: UIControlEvents.touchUpInside)
//
//        let bottomLbl = UILabel(frame: CGRect.zero)
//        self.view.addSubview(bottomLbl)
//        bottomLbl.snp.makeConstraints { (make) in
//            make.width.greaterThanOrEqualTo(10)
//            make.height.greaterThanOrEqualTo(10)
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-25 - Main_IndicatorBar_Height)
//        }
//
//        bottomLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_bottom_investment_text_key), textAlignment: .center, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
//
//        let ruleLbl = UILabel(frame: CGRect.zero)
//        self.view.addSubview(ruleLbl)
//        ruleLbl.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(5)
//            make.right.equalToSuperview().offset(-5)
//            make.height.greaterThanOrEqualTo(10)
//            if Main_Screen_Width < 375 {
//                make.bottom.equalTo(bottomLbl.snp.top).offset(-20)
//            }
//            else {
//                make.bottom.equalTo(bottomLbl.snp.top).offset(-68 * theScaleToiPhone_6)
//            }
//        }
//
//        ruleLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_queuing_order_rule_text_key), textAlignment: .center, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
//    }

//
//    // 将UICollectionViewCell居中
//    func scrollCellItemToCenter() {
//
//        let distance: CGFloat = 20 * theScaleToiPhone_6
//
//        if startDragging_x - endDragging_x > distance {
//            // 向左滑动
//            curIndex = curIndex - 1
//        }
//        else if endDragging_x - startDragging_x > distance {
//            // 向右滑动
//            curIndex = curIndex + 1
//        }
//
//        let maxIndex = mainCollectionView.numberOfItems(inSection: 0) - 1
//        curIndex = curIndex <= 0 ? 0 : curIndex
//        curIndex = curIndex >= maxIndex ? maxIndex : curIndex
//
//        mainCollectionView.scrollToItem(at: IndexPath(item: curIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//    }
//
//    // MARK: - UICollectionViewDelegate & DataSource
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return joinRecordList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if indexPath.item < joinRecordList.count {
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanJoinOrderDetailCell", for: indexPath) as? PlanJoinOrderDetailCell {
//
//                let record = joinRecordList[indexPath.item]
//                cell.configCellWithJoinRecordListModel(model: record)
//                return cell
//            }
//        }
//
//        return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellForNull", for: indexPath)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//
//    // MARK: - UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let itemWidth: CGFloat = Main_Screen_Width - 60
//        let itemHeight: CGFloat = itemCellHeight
//
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize.zero
//    }
//
//    // MARK: - ScrollViewDelegate
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        startDragging_x = scrollView.contentOffset.x
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        endDragging_x = scrollView.contentOffset.x
//        DispatchQueue.main.async { [weak self] in
//            if let weakSelf = self {
//                weakSelf.scrollCellItemToCenter()
//            }
//        }
//    }

