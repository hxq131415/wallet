//
//  WalletTransferResultViewController.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  转账结果

import UIKit

class WalletTransferResultViewController: MRBaseViewController {

    lazy var navBarView: MRTopNavView = MRTopNavView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: MR_Custom_NavigationBar_Height))
    
    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    lazy var titleArray: [String] = []
    lazy var dataArray: [String] = []
    
    private var resultView: WalletTransferResultContentView = {
        let resultView_ = Bundle.main.loadNibNamed("WalletTransferResultContentView", owner: nil, options: nil)?.first as! WalletTransferResultContentView
        return resultView_
    }()
    
    private var bottomView: WalletTransferResultBottomView = {
        let bottomView_ = Bundle.main.loadNibNamed("WalletTransferResultBottomView", owner: nil, options: nil)?.first as! WalletTransferResultBottomView
        return bottomView_
    }()
    
    
    // 是否转账成功
    var isSuccess: Bool = false
    var mcoinName: String?
    
    var detailModel: WalletTransferRecordListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColorFromRGB(hexRGB: 0xF6FAFB)
        
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
        navBarView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_navigation_title_key)
        
        navBarView.goBackClosure = { [weak self] in
            if let weakSelf = self {
                weakSelf.popWithAnimate()
            }
        }
        
        resultView.frame = CGRect(x: 0, y: navBarView.frame.maxY, width: Main_Screen_Width, height: 132)
        self.view.addSubview(resultView)
        
        var bottomHeight = 110 * theScaleToiPhone_6
        // 1打包中 2打包成功 3打包失败
        if detailModel?.status == 2 {
            bottomHeight = 154 * theScaleToiPhone_6
        }
        
        bottomView.frame = CGRect(x: 0, y: Main_Screen_Height -  bottomHeight, width: Main_Screen_Width, height: bottomHeight)
        self.view.addSubview(bottomView)
        bottomView.returnActionClosure = {
            self.popWithAnimate()
        }
        
        //MARK: - 查看更多详情
        bottomView.seeMoreDetailActionClosure = {[weak self] in
            if let weakSelf = self {
                guard let detail = weakSelf.detailModel else {
                    return
                }
                let webCtrl = MRWebViewController(title: weakSelf.mcoinName, url: detail.url)
                weakSelf.pushToViewController(viewCtrl: webCtrl)
            }
        }
        
        self.view.addSubview(mainTableView)
        mainTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(resultView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorColor = UIColor.clear
        mainTableView.backgroundColor = UIColorFromRGB(hexRGB: 0xF6FAFB)
        
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        
        mainTableView.register(UINib(nibName: "WalletTransferResultViewCell", bundle: nil), forCellReuseIdentifier: "WalletTransferResultViewCell")
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        
        mainTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: Main_Screen_Width, height: 35))
        
        let to = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_to_text_key)
        let from = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_from_text_key)
        let fee = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_fee_text_key)
        let height = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_height_text_key)
        let txHash = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_txHash_text_key)
        let time = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_time_text_key)
  
        // 类型 1转出 2转入
        if detailModel?.type == 1 {
            resultView.iconImgView.image = UIImage(named: "icon_zhuanchu_green")
            resultView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_Transfer_text_key)
        }else {
            resultView.iconImgView.image = UIImage(named: "icon_zhuanru")
            resultView.titleLbl.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_Receive_text_key)
        }
        
        titleArray = [to,from,fee,height,txHash,time]
        
        let num = detailModel?.num ?? "0"
//        if mcoinName != "Mcoin" {// ETC  ETH
//            num = String.stringFormatMultiplyingByPowerOf10_18(str: num)
//        }
        resultView.priceLbl.text = num
        
        resultView.etcLbl.text = mcoinName
        
        dataArray.removeAll()
        
        if isSuccess {
            if let model = detailModel {
                // 1打包中 2打包成功
                if model.status == 1 {
                    resultView.statusBtn.setImage(UIImage(named: "icon_wallet_transfer_result_wait"), for: UIControlState.normal)
                    resultView.statusBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_wait_text_key), for: UIControlState.normal)
                    
                }else  {
                    resultView.statusBtn.setImage(UIImage(named: "icon_wallet_transfer_result_success"), for: UIControlState.normal)
                    resultView.statusBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_successful_text_key), for: UIControlState.normal)
                    var fee = model.fee
//                    if mcoinName != "Mcoin" {// ETC  ETH
                        fee = String.stringFormatMultiplyingByPowerOf10_18(str: fee)
//                    }
                    
                    if mcoinName == "ETC"
                    {
                        fee = fee + "ETC"
                    }
                    else{
                        fee = fee + "ETH"
                    }
                    
                    dataArray = [model.toAddress,model.fromAddress,fee,model.block_height,model.block_hash,model.add_time]
                }
            }
        }else {
            resultView.statusBtn.setImage(UIImage(named: ""), for: UIControlState.normal)
            resultView.statusBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: WalletTransferResultPage_transfer_fail_text_key), for: UIControlState.normal)
        }
        
        resultView.statusBtn.titleRightAndImageLeftSetting(withSpace: 10)
    }
    
    
}

extension WalletTransferResultViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:WalletTransferResultViewCell = tableView.dequeueReusableCell(withIdentifier: "WalletTransferResultViewCell", for: indexPath) as! WalletTransferResultViewCell
        cell.leftLabel.text = titleArray[indexPath.row]
        cell.rightLabel.text = dataArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
    
    
}
