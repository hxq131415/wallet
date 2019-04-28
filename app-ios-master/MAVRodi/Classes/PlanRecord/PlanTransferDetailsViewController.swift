//
//  PlanTransferDetailsViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/12.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  转款详情

import UIKit

class PlanTransferDetailsViewController: MRBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    
    private var itemCellHeight: CGFloat = {
        if Main_Screen_Width < 375 {
            return 280
        }
        else {
            return 310
        }
    }()
    
    // 参与记录
    var joinRecordList: [PlanJoinRecordListModel] = []
    
    private var curIndex: Int = 0
    private var startDragging_x: CGFloat = 0
    private var endDragging_x: CGFloat = 0
    
    private var timr: Timer?
    
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_waiting_transfer_navigation_title_key)
        
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
        
        confirmBtn.configButtonForNormal(title: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_waiting_transfer_bottom_btn_title_key), textColor: UIColorFromRGB(hexRGB: 0xFFFFFF), font: UIFont.systemFont(ofSize: 19), normalImage: nil, selectedImage: nil, backgroundColor: UIColorFromRGB(hexRGB: 0x365ad8))
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
        countDownView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_waiting_transfer_countdown_left_title_key)
        
        let ruleLbl = UILabel(frame: CGRect.zero)
        self.view.addSubview(ruleLbl)
        ruleLbl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.greaterThanOrEqualTo(10)
            if Main_Screen_Width < 375 {
                make.top.equalTo(countDownView.snp.bottom).offset(20)
            }
            else {
                make.top.equalTo(countDownView.snp.bottom).offset(40)
            }
        }
        
        ruleLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_waiting_transfer_rule_text_key), textAlignment: .left, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
        ruleLbl.numberOfLines = 0
        
        let bottomLbl = UILabel(frame: CGRect.zero)
        self.view.addSubview(bottomLbl)
        bottomLbl.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(10)
            make.height.greaterThanOrEqualTo(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15 - Main_IndicatorBar_Height)
        }
        
        bottomLbl.configLabel(text: MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanJoinRecordDetailsPage_Common_bottom_investment_text_key), textAlignment: .center, textColor: UIColorFromRGB(hexRGB: 0x365ad8), font: UIFont.systemFont(ofSize: 10))
    }
    
    // MARK: - Action
    @objc func confirmBtnAction() {
        
        // 确认转款
        if curIndex < joinRecordList.count {
            let record = joinRecordList[curIndex]
            let transferConfirmCtrl = WalletTransferConfirmViewController()
            transferConfirmCtrl.joinRecordModel = record
            self.navigationController?.pushViewController(transferConfirmCtrl, animated: true)
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
        
        if curIndex < joinRecordList.count {
            let record = joinRecordList[curIndex]
            countDownView.configCountDownView(confirmStartTime: record.transferStart, transferTime: record.transferDeadline)
            
            if let curCell = mainCollectionView.cellForItem(at: IndexPath(item: curIndex, section: 0)) as? PlanHarvestDetailsCell {
                curCell.configCellWithJoinRecordListModel(model: record)
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
        return joinRecordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item < joinRecordList.count {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanHarvestDetailsCell", for: indexPath) as? PlanHarvestDetailsCell {
                
                let record = joinRecordList[indexPath.item]
                cell.configCellWithJoinRecordListModel(model: record)
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

}
