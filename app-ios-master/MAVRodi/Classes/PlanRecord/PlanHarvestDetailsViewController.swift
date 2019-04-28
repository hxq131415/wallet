//
//  PlanHarvestDetailsViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/12.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  收获详情

import UIKit

class PlanHarvestDetailsViewController: MRBaseViewController {
    
    var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    var tableHeaderView: PlanHarvestDetailsHeaderView!
    
    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    private var confirmBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    // 收获记录
    var harvestRecord: PlanHarvestRecordListModel?
    // 参与记录
    private var harvestStatusType: PlanRecordHarvestStatus = .all
    var harvestList: [PlanHarvestRecordListModel] = [] {
        didSet {
            if let harvestReocrdTemp = harvestList.first {
                harvestStatusType = harvestReocrdTemp.harvestStatusType
            }
        }
    }
    
    private var timr: Timer?
    
    //    private let itemCellHeight: CGFloat = 310
    //
    //    private var curIndex: Int = 0
    //    private var startDragging_x: CGFloat = 0
    //    private var endDragging_x: CGFloat = 0
    
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestDetailsPage_navigation_title_key)
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        // 收获规则
        navBarView.rightButtonClosure = {
            
            let title = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_order_rule_title_key)
            let msg = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_order_rule_text_key)
            CustomAlertView.showCustomAlertView(superV: self.view, title: title, detail: msg) {
                
            }
//            let confirm = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_Alert_determine_btn_title_key)
            
//            MRCustomAlertController.showAlertController(title: title, message: msg, confirm: confirm, confirmClosure: {
            
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
//        PlanJoinPage_bottom_investment_text_key
    }
    
    override func appLanguageChanged(notifi: Notification) {
        if let model = harvestList.first {
            tableHeaderView.configCellWithHarvestRecordListModel(model: model)
        }
        self.tableView.reloadData()
    }
    
    func initTableHeaderView() {
        
        tableHeaderView = Bundle.main.loadNibNamed("PlanHarvestDetailsHeaderView", owner: self, options: nil)?.last as? PlanHarvestDetailsHeaderView
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 215)
        self.tableView.tableHeaderView = tableHeaderView
        if let model = harvestList.first {
            tableHeaderView.configCellWithHarvestRecordListModel(model: model)
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
    
    //获取收获详情
    func requestForArrivalDetail() {
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        var params: [String: Any] = [:]
        let harvestReocrdTemp = harvestList.first
        params["id"] = harvestReocrdTemp?.id
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_GET_HEARVEST_LISTDETAI, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let dict = data as? [String: Any] {
                        weakSelf.harvestRecord = PlanHarvestRecordListModel(JSON: dict)
                        weakSelf.tableHeaderView.configCellWithHarvestRecordListModel(model: weakSelf.harvestRecord!)
                            
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
    
    // MARK: - Request
    // 确认收款
    func requestForConfirmReceipt(record: PlanHarvestRecordListModel) {
        
        var params: [String: Any] = [:]
        params["id"] = record.id
        
        TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
        
        TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_CONFIRM_RECEIPT, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
            if let weakSelf = self {
                TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
                if status == 0 {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("收款成功")
                    }
                    
                    let receiptConfirmCtrl = WalletReceiptConfirmViewController()
                    receiptConfirmCtrl.harvestRecordModel = record
                    weakSelf.navigationController?.pushViewController(receiptConfirmCtrl, animated: true)
                }
                else {
                    if let msg = message, !msg.isEmpty {
                        weakSelf.showMessage(msg)
                    }
                    else {
                        weakSelf.showMessage("收款失败")
                    }
                }
            }
        }
    }
}

extension PlanHarvestDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        }else if indexPath.row == 3 {
            cell.greenDotViewWidthConstraint.constant = 8
        }else if indexPath.row == 2 {
            cell.greenDotViewWidthConstraint.constant = 12
            cell.greenLineView.isHidden = true
        }
        cell.configCellWithHarvestRecordListModel(model: harvestRecord!,row: indexPath.row)
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
/*
 , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate
 
 private var mainCollectionView: UICollectionView = {
 let flowLayout = UICollectionViewFlowLayout()
 flowLayout.estimatedItemSize = .zero
 flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
 flowLayout.scrollDirection = .horizontal
 
 let collectionVw_ = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
 return collectionVw_
 }()
 
 lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
 // 倒计时View
 private var countDownView: PlanHarvestCountDownView = {
 let downVw = Bundle.main.loadNibNamed("PlanHarvestCountDownView", owner: nil, options: nil)?.first as! PlanHarvestCountDownView
 return downVw
 }()
 
 private var confirmBtn: UIButton = {
 let btn = UIButton(type: UIButtonType.custom)
 return btn
 }()
 
 private var harvestStatusType: PlanRecordHarvestStatus = .all
 var harvestList: [PlanHarvestRecordListModel] = [] {
 didSet {
 if let harvestReocrd = harvestList.first {
 harvestStatusType = harvestReocrd.harvestStatusType
 }
 }
 }
 
 private var timr: Timer?
 
 private var itemCellHeight: CGFloat = {
 if Main_Screen_Width < 375 {
 return 280
 }
 else {
 return 310
 }
 }()
 
 private var curIndex: Int = 0
 private var startDragging_x: CGFloat = 0
 private var endDragging_x: CGFloat = 0
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Do any additional setup after loading the view.
 self.view.backgroundColor = UIColorFromRGB(hexRGB: 0x061c69)
 
 self.subViewInitialization()
 }
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 
 if mainCollectionView.numberOfItems(inSection: 0) > 0 {
 mainCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
 curIndex = 0
 
 self.startTimer()
 }
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
 
 navBarView.goBackClosure = { [weak self] in
 if let weakSelf = self {
 weakSelf.popWithAnimate()
 }
 }
 
 self.view.addSubview(mainCollectionView)
 mainCollectionView.snp.makeConstraints { (make) in
 make.left.right.equalToSuperview()
 if Main_Screen_Width < 375 {
 make.top.equalTo(self.navBarView.snp.bottom).offset(20)
 }
 else {
 make.top.equalTo(self.navBarView.snp.bottom).offset(30 * theScaleToiPhone_6)
 }
 make.height.equalTo(self.itemCellHeight)
 }
 
 mainCollectionView.backgroundColor = UIColor.clear
 mainCollectionView.isPagingEnabled = false
 mainCollectionView.showsHorizontalScrollIndicator = false
 mainCollectionView.showsVerticalScrollIndicator = false
 mainCollectionView.delegate = self
 mainCollectionView.dataSource = self
 
 // register cells
 mainCollectionView.register(UINib(nibName: "PlanHarvestDetailsCell", bundle: nil), forCellWithReuseIdentifier: "PlanHarvestDetailsCell")
 mainCollectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCellForNull")
 
 self.view.addSubview(confirmBtn)
 confirmBtn.snp.makeConstraints { (make) in
 make.top.equalTo(self.mainCollectionView.snp.bottom).offset(30 * theScaleToiPhone_6)
 make.width.equalTo(317 * theScaleToiPhone_6)
 if Main_Screen_Width < 375 {
 make.height.equalTo(40)
 }
 else {
 make.height.equalTo(50)
 }
 make.centerX.equalToSuperview()
 }
 
 confirmBtn.layer.masksToBounds = true
 confirmBtn.layer.cornerRadius = 8
 
 confirmBtn.addTarget(self, action: #selector(self.confirmBtnAction), for: UIControlEvents.touchUpInside)
 
 countDownView.frame = CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 60)
 self.view.addSubview(countDownView)
 countDownView.snp.makeConstraints { (make) in
 make.left.right.equalToSuperview()
 make.height.equalTo(52)
 make.top.equalTo(self.confirmBtn.snp.bottom).offset(5)
 }
 
 countDownView.backgroundColor = UIColor.clear
 countDownView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_wait_confirm_countdown_left_title_key)
 
 let ruleLbl = UILabel(frame: CGRect.zero)
 self.view.addSubview(ruleLbl)
 ruleLbl.snp.makeConstraints { (make) in
 make.left.equalTo(self.confirmBtn.snp.left).offset(0)
 make.right.equalTo(self.confirmBtn.snp.right).offset(0)
 make.height.greaterThanOrEqualTo(10)
 if Main_Screen_Width < 375 {
 make.top.equalTo(countDownView.snp.bottom).offset(20)
 }
 else {
 make.top.equalTo(countDownView.snp.bottom).offset(40)
 }
 }
 
 ruleLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_order_rule_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
 ruleLbl.numberOfLines = 0
 
 let bottomLbl = UILabel(frame: CGRect.zero)
 self.view.addSubview(bottomLbl)
 bottomLbl.snp.makeConstraints { (make) in
 make.width.greaterThanOrEqualTo(10)
 make.height.greaterThanOrEqualTo(10)
 make.centerX.equalToSuperview()
 make.bottom.equalToSuperview().offset(-15 - Main_IndicatorBar_Height)
 }
 
 bottomLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinPage_bottom_investment_text_key), textAlignment: .center, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
 
 switch harvestStatusType {
 case .queuing:
 navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_order_navigation_title_key)
 confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_order_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e))
 confirmBtn.isEnabled = false
 countDownView.isHidden = true
 countDownView.snp.updateConstraints { (make) in
 make.height.equalTo(0)
 }
 ruleLbl.isHidden = false
 ruleLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_queuing_order_rule_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
 ruleLbl.numberOfLines = 0
 break
 case .waitConfirm:
 navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_wait_confirm_navigation_title_key)
 confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_wait_confirm_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x365ad8))
 confirmBtn.isEnabled = true
 countDownView.isHidden = false
 countDownView.snp.updateConstraints { (make) in
 make.height.equalTo(52)
 }
 ruleLbl.isHidden = false
 ruleLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_wait_confirm_rule_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
 ruleLbl.numberOfLines = 0
 break
 case .finished:
 navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_finish_navigation_title_key)
 confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestRecordDetailsPage_finish_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e))
 confirmBtn.isEnabled = false
 countDownView.isHidden = true
 countDownView.snp.updateConstraints { (make) in
 make.height.equalTo(0)
 }
 ruleLbl.isHidden = true
 break
 default:
 break
 }
 }
 
 // MARK: - Action
 @objc func confirmBtnAction() {
 
 // 确认收款
 if curIndex < harvestList.count {
 let record = harvestList[curIndex]
 self.requestForConfirmReceipt(record: record)
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
 
 if curIndex < harvestList.count {
 let record = harvestList[curIndex]
 countDownView.configCountDownView(confirmStartTime: record.confirmStart, transferTime: record.transferDeadline)
 
 if let curCell = mainCollectionView.cellForItem(at: IndexPath(item: curIndex, section: 0)) as? PlanHarvestDetailsCell {
 curCell.configCellWithHarvestRecordListModel(model: record)
 }
 }
 }
 
 // MARK: - Request
 // 确认收款
 func requestForConfirmReceipt(record: PlanHarvestRecordListModel) {
 
 var params: [String: Any] = [:]
 params["id"] = record.id
 
 TEActingLoadingView.showSystemActingLoadingViewToSuperView(superView: self.view)
 
 TERequestManager.dataRequestForPOSTWithCode(with: MR_REQ_CODE_PLAN_CONFIRM_RECEIPT, parameters: params, requestInfo: nil) { [weak self](data, status, message) in
 if let weakSelf = self {
 TEActingLoadingView.hideActingLoadingViewInSuperView(superView: weakSelf.view)
 if status == 0 {
 if let msg = message, !msg.isEmpty {
 weakSelf.showMessage(msg)
 }
 else {
 weakSelf.showMessage("收款成功")
 }
 
 let receiptConfirmCtrl = WalletReceiptConfirmViewController()
 receiptConfirmCtrl.harvestRecordModel = record
 weakSelf.navigationController?.pushViewController(receiptConfirmCtrl, animated: true)
 }
 else {
 if let msg = message, !msg.isEmpty {
 weakSelf.showMessage(msg)
 }
 else {
 weakSelf.showMessage("收款失败")
 }
 }
 }
 }
 }
 
 // 将UICollectionViewCell居中
 func scrollCellItemToCenter() {
 
 let distance: CGFloat = 20 * theScaleToiPhone_6
 
 if startDragging_x - endDragging_x > distance {
 // 向左滑动
 curIndex = curIndex - 1
 }
 else if endDragging_x - startDragging_x > distance {
 // 向右滑动
 curIndex = curIndex + 1
 }
 
 let maxIndex = mainCollectionView.numberOfItems(inSection: 0) - 1
 curIndex = curIndex <= 0 ? 0 : curIndex
 curIndex = curIndex >= maxIndex ? maxIndex : curIndex
 
 mainCollectionView.scrollToItem(at: IndexPath(item: curIndex, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
 }
 
 // MARK: - UICollectionViewDelegate & DataSource
 func numberOfSections(in collectionView: UICollectionView) -> Int {
 return 1
 }
 
 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 return harvestList.count
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
 if indexPath.item < self.harvestList.count {
 let record = harvestList[indexPath.item]
 if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanHarvestDetailsCell", for: indexPath) as? PlanHarvestDetailsCell {
 
 cell.configCellWithHarvestRecordListModel(model: record)
 return cell
 }
 }
 
 return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellForNull", for: indexPath)
 }
 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
 }
 
 // MARK: - UICollectionViewDelegateFlowLayout
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
 
 return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
 let itemWidth: CGFloat = Main_Screen_Width - 60
 let itemHeight: CGFloat = itemCellHeight
 
 return CGSize(width: itemWidth, height: itemHeight)
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
 return 10
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
 return 10
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
 return CGSize.zero
 }
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
 return CGSize.zero
 }
 
 // MARK: - ScrollViewDelegate
 func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
 startDragging_x = scrollView.contentOffset.x
 }
 
 func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
 endDragging_x = scrollView.contentOffset.x
 DispatchQueue.main.async { [weak self] in
 if let weakSelf = self {
 weakSelf.scrollCellItemToCenter()
 }
 }
 }
 */
