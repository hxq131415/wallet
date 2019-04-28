//
//  WalletTradingRecordHeaderView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/6.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit
@objc protocol PlainRecordListTableViewDelegate: NSObjectProtocol {
    
    // 倒计时为0
    @objc func remainingCountReset()
}
class PlanRecordTableHeaderView: UIView {

    @IBOutlet weak var CapitaloutLabel: UILabel!
    @IBOutlet weak var CapitalinLabel: UILabel!
    @IBOutlet weak var priceLabel3: UILabel!
    @IBOutlet weak var priceLabel2: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introBtn: UIButton!
    
    @IBOutlet weak var joinRecordBtn: UIButton!
    @IBOutlet weak var getRecordBtn: UIButton!
    
    @IBOutlet weak var grapTipsLabel: UILabel!
    @IBOutlet weak var progressView: LGProgressView!
    
    var recordSelectBtn: UIButton?
    var selectBtn: UIButton?
    // 在global线程里创建一个时间源
    let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
    
    var joinBtnTapClosure: (() -> ())?
    var getBtnTapClosure: (() -> ())?
    var introBtnTapClosure: (() -> ())?
    var finishBtnTapClosure: (() -> ())?
    
    var recordBtnChangedClosure: ((_ recordType: PlanRecordListType) -> ())?
//    var recordStatusBtnTapClosure: ((_ recordStatus: PlanRecordJoinStatus , _ harvestStatus: PlanRecordHarvestStatus) -> ())?
    
    var recordListType: PlanRecordListType = .join
    weak var delegate: PlainRecordListTableViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressView.backgroundColor = UIColorFromRGB(hexRGB: 0xb20f03)
        progressView.progressBorderMode = .round
        progressView.progressTintColor = UIColorFromRGB(hexRGB: 0x1ed2b0)
        progressView.pause = false
        
        joinRecordBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x111111), for: UIControlState.selected)
        joinRecordBtn.setTitleColor(UIColorFromRGB(hexRGB: 0xaaaaaa), for: UIControlState.normal)
        
        getRecordBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x111111), for: UIControlState.selected)
        getRecordBtn.setTitleColor(UIColorFromRGB(hexRGB: 0xaaaaaa), for: UIControlState.normal)
        
        
        joinRecordBtn.addTarget(self, action: #selector(self.changedBtnAction(btn:)), for: UIControlEvents.touchUpInside)
        getRecordBtn.addTarget(self, action: #selector(self.changedBtnAction(btn:)), for: UIControlEvents.touchUpInside)
        
        joinRecordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_segment_title_key), for: UIControlState.normal)
        joinRecordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_join_record_segment_title_key), for: UIControlState.selected)
        
        getRecordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_segment_title_key), for: UIControlState.normal)
        getRecordBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_harvest_record_segment_title_key), for: UIControlState.selected)
        
        
        //投资本金
        //总收益资产(ETC)
        //总收益(ETC)
        //总回报率
        titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title_key)
        titleLabel2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title2_key)
        titleLabel3.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title3_key)
        
        CapitalinLabel.text =  MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_capitalin_text_key)
        CapitaloutLabel.text =  MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_capitalout_text_key)
        
        self.changedBtnAction(btn: joinRecordBtn)
        
        introBtn.addTarget(self, action: #selector(self.introBtnAction), for: UIControlEvents.touchUpInside)
        
        progressView.progress = 0.5
        
        
        grapTipsLabel.layer.cornerRadius = 10.0
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //配置抢单提示信息
    func configGrapTipsLabel(grapStatusModel:PlanJoinGrapStatusModel)
    {
        if(grapStatusModel.status == 1)
        {
            self.grapTipsLabel.backgroundColor = UIColorFromRGB(hexRGB: 0xEDA639)
            self.grapTipsLabel.textColor = UIColor.red
            grapTipsLabel.text = " 抢单中 "
        }
        else
        {
            if(grapStatusModel.nexttime - grapStatusModel.servertime < 1800 &&
                grapStatusModel.nexttime - grapStatusModel.servertime > 0)
            {
                countDown(count: Int(grapStatusModel.nexttime - grapStatusModel.servertime))
            }
            else
            {
                self.grapTipsLabel.backgroundColor = UIColor.lightGray
                self.grapTipsLabel.textColor = UIColor.white
                grapTipsLabel.text = String(format: " 下一轮抢单时间:%@    ", grapStatusModel.nexttimestr!)
            }
        }
        
        
        
//        let size = CGSize(width: 350, height: grapTipsLabel.frame.height)
//
//        let dic = NSDictionary(object: grapTipsLabel.font, forKey: NSAttributedStringKey.font as NSCopying)
//
//        let strSize = tipsStr.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
//        let tempwidth = 20+strSize.width * theScaleToiPhone_6
//        grapTipsLabel.frame = CGRect(x: grapTipsLabel.frame.origin.x, y: grapTipsLabel.frame.origin.y, width: tempwidth, height: grapTipsLabel.frame.height)
        
        
        
    }
    func cancelTimer()
    {
        codeTimer.cancel()
    }
    func countDown(count: Int){
        // 设置倒计时,按钮背景颜色
        
        self.grapTipsLabel.backgroundColor = UIColorFromRGB(hexRGB: 0xEDA639)
        self.grapTipsLabel.textColor = UIColor.red
        var remainingCount: Int = count {
            willSet {
                let min = newValue/60
                let sec = newValue%60
                grapTipsLabel.text = "  抢单开始倒计时：\(min)M\(sec)S   "
                
                if newValue <= 0 {
                    grapTipsLabel.text = "  抢单中  "//调用抢单状态接口
                    if self.delegate != nil && self.delegate!.responds(to: #selector(PlainRecordListTableViewDelegate.remainingCountReset)) {
                        self.delegate!.remainingCountReset()
                    }
//                    self.loginView.loginBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_login_button_title_Key), for: UIControlState.normal)
                }
            }
        }
        
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    // 配置收益信息
    var model: ProfitInfoListModel? = nil {
        didSet{
            
            if let model_ = model {
                priceLabel.text = String(format: "%.6f", model_.invest)
                priceLabel2.text = String(format: "%.6f", model_.gain)
                if((Double(model_.invest)+Double(model_.gain)) != 0)
                {
                    priceLabel3.text = String(format: "%.0f%%",Double(model_.gain)/Double(model_.invest)*100)
                }
                else{
                    priceLabel3.text = String(format: "%.0f%%",0)
                }
                let pro:CGFloat = CGFloat(model_.investAll)/(CGFloat(model_.gainAll)+CGFloat(model_.investAll))
                progressView.progress = pro
                
            }
            
        }
    }
    
    func selectRecordListTypeBtnWithType(recordListType: PlanRecordListType) {
        
        self.recordListType = recordListType
        if recordListType == .join {
            self.changedBtnAction(btn: joinRecordBtn)
            titleLabel2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title2_key)
        }
        else if recordListType == .harvest  {
            self.changedBtnAction(btn: getRecordBtn)
            titleLabel2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title22_key)
        }
        else {
            self.changedBtnAction(btn: joinRecordBtn)
            titleLabel2.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanRecordHome_investment_title22_key)
        }
    }
    
    func selectRecordStatusBtnWithRecordStatus(status: PlanRecordJoinStatus, harvestStatus: PlanRecordHarvestStatus) {
        
//        if self.recordListType == .join {
//            switch status {
//            case .all:
//                self.btnAction(btn: allRecordBtn)
//            case .queuing:
//                self.btnAction(btn: planingBtn)
//            case .waitTransfer:
//                self.btnAction(btn: waitingPayBtn)
//            case .finished:
//                self.btnAction(btn: finishedBtn)
//            default:
//                break
//            }
//        }
//        else {
//            switch harvestStatus {
//            case .all:
//                self.btnAction(btn: allRecordBtn)
//            case .queuing:
//                self.btnAction(btn: planingBtn)
//            case .waitConfirm:
//                self.btnAction(btn: waitingPayBtn)
//            case .finished:
//                self.btnAction(btn: finishedBtn)
//            }
//        }
        
    }
    
    // MARK: - Action
    
    @objc func changedBtnAction(btn: UIButton) {
        
        if btn != recordSelectBtn {
            changedButtonAction(btn: btn)
            
            if self.recordBtnChangedClosure != nil {
                self.recordBtnChangedClosure!(recordListType)
            }
        }
    }
    
    func changedButtonAction(btn: UIButton) {
        
        btn.isSelected = true
        recordSelectBtn?.isSelected = false
        recordSelectBtn = btn
        
        if btn.isEqual(joinRecordBtn) {
            recordListType = .join
        }
        else if btn.isEqual(getRecordBtn) {
            recordListType = .harvest
        }
        else {
            recordListType = .finished
        }
    }
    
//    @objc func btnAction(btn: UIButton) {
//
//        var status: PlanRecordJoinStatus = .all
//        var harvestStatus: PlanRecordHarvestStatus = .all
//
//        if btn != selectBtn {
//            btn.isSelected = true
//            selectBtn?.isSelected = false
//            selectBtn = btn
//
//            if btn == allRecordBtn {
//                status = .all
//                harvestStatus = .all
//            }
//            else if btn == planingBtn {
//                status = .queuing
//                harvestStatus = .queuing
//            }
//            else if btn == waitingPayBtn {
//                status = .waitTransfer
//                harvestStatus = .waitConfirm
//            }
//            else if btn == finishedBtn {
//                status = .finished
//                harvestStatus = .finished
//            }
//
//            if self.recordStatusBtnTapClosure != nil {
//                self.recordStatusBtnTapClosure!(status, harvestStatus)
//            }
//        }
//    }
    
    @objc func joinBtnAction() {
        
        if self.joinBtnTapClosure != nil {
            self.joinBtnTapClosure!()
        }
    }
    
    @objc func getBtnAction() {
        
        if self.getBtnTapClosure != nil {
            self.getBtnTapClosure!()
        }
    }
    
    @objc func finishBtnAction() {
        
        if self.finishBtnTapClosure != nil {
            self.finishBtnTapClosure!()
        }
    }
    
    @objc func introBtnAction() {
        
        if self.introBtnTapClosure != nil {
            self.introBtnTapClosure!()
        }
    }
    
}
