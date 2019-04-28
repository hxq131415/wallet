//
//  MPlanBillsView.swift
//  MAVRodi
//
//  Created by pan on 2019/2/16.
//  Copyright © 2019 是心作佛. All rights reserved.
//

import UIKit
typealias BVCallBackClosure = () -> ()
typealias CheckExPoolCallBackClosure = () -> ()

class MPlanBillsView: UIView {
    @IBOutlet weak var investLabel: UILabel!
    @IBOutlet weak var investETCLabel: UILabel!
    @IBOutlet weak var ROINumLabel: UILabel!
    @IBOutlet weak var ROILabel: UILabel!
    @IBOutlet weak var gainAllLabel: UILabel!
    @IBOutlet weak var gainAllETCLabel: UILabel!
    
    @IBOutlet weak var gameRewardLabel: UILabel!
    @IBOutlet weak var gameRewardETCLabel: UILabel!
    @IBOutlet weak var shareRewardLabel: UILabel!
    @IBOutlet weak var shareRewardETCLabel: UILabel!
    @IBOutlet weak var teamRewardLabel: UILabel!
    @IBOutlet weak var teamRewardETCLabel: UILabel!
    @IBOutlet weak var colorCircleView: ColorCircleView!
    
    @IBOutlet weak var myShareLabel: UILabel!
    @IBOutlet weak var myShareNumLabel: UILabel!
    @IBOutlet weak var myTeamLabel: UILabel!
    @IBOutlet weak var myTeamNumLabel: UILabel!
    @IBOutlet weak var teamTotalInvestLabel: UILabel!
    @IBOutlet weak var teamTotalInvestETCLabel: UILabel!
    
    @IBOutlet weak var cannotCompensationView: UIView!
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var compensationView: UIView!
    @IBOutlet weak var compensationLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var compensationETCLabel: UILabel!
    
    @IBOutlet weak var currencyMcoinLabel: UILabel!
    @IBOutlet weak var getCompensationBtn: UIButton!
    
    //查看兑换金
    @IBOutlet weak var checkExchangeBtn1: UIButton!
    @IBOutlet weak var checkExchangeBtn2: UIButton!
    
    var getCompensationBtnClosure: BVCallBackClosure?
    
    var checkExPcoolCallBackClosure: CheckExPoolCallBackClosure?
    
    @IBAction func getCompensation(_ sender: Any) {
        print("点击了领取")
        if let block = getCompensationBtnClosure {
            block()
        }
    }
    
    @IBAction func checkExchangeBtnAction(_ sender: Any) {
        print("点击了领取")
        if let block = checkExPcoolCallBackClosure {
            block()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //绿色 #1ed2b0  红色#b20f03
    }
    
    func setColorCircleView(dataArray: NSArray){
        let a:CGFloat = dataArray[0] as! CGFloat
        let b:CGFloat = dataArray[1] as! CGFloat
        let c:CGFloat = dataArray[2] as! CGFloat
        self.colorCircleView.circleArray = [[
                                                "strokeColor":UIColorFromRGB(hexRGB: 0xB8E986),
                                                "precent":(c/(a+b+c))
                                            ],
                                            [
                                                "strokeColor":UIColorFromRGB(hexRGB: 0x16F0C8),
                                                "precent":(b/(a+b+c))
                                            ],
                                            [
                                                "strokeColor":UIColorFromRGB(hexRGB: 0x2ABBB0),
                                                "precent":(a/(a+b+c))
                                            ]]
        
    }
    
    func configViewWithModel(model:PlanPersonalResetModel)
    {
        var a=model.gainAll,b=model.sub_prize,c=model.team_prize
        if(a == 0 && b == 0 && c == 0)
        {
            a = 12
            b = 12
            c = 12
        }
        let dataArr:NSArray = [a,b,c]
        self.setColorCircleView(dataArray: dataArr)
        
        investETCLabel.text = String(format: "%.6fETC", model.cur_principal)
        ROINumLabel.text = String(format: "%.0f", model.return_rate*100)//回报率
        gainAllETCLabel.text = String(format: "%.6fETC", model.cur_income)
        gameRewardETCLabel.text = String(format: "%.3fETC", model.gainAll)
        shareRewardETCLabel.text = String(format: "%.3fETC", model.sub_prize)
        teamRewardETCLabel.text = String(format: "%.3fETC", model.team_prize)
        myShareNumLabel.text = String(format: "%d", model.sub_count)
        myTeamNumLabel.text = String(format: "%d", model.team_count)
        teamTotalInvestETCLabel.text = String(format: "%.3fETC", model.team_principal)
        compensationETCLabel.text = String(format: "%.6f", model.loss_amount)
        currencyMcoinLabel.text = String(format: "%.6f", model.return_amount)
        
        if(model.loss_amount <= 0 && model.reset_id == 0)
        {
            //无亏损
            cannotCompensationView.alpha = 1.0
            compensationView.alpha = 0
        }
        else
        {
            if(model.reset_id == 0)
            {
                getCompensationBtn.isEnabled = true
                getCompensationBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
                getCompensationBtn.setTitle("兑换重启", for: UIControl.State.normal)
                getCompensationBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x2ABBB0)
                //边框宽度
                getCompensationBtn.layer.borderWidth = 1
                getCompensationBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x2ABBB0).cgColor
            }
            else
            {
                getCompensationBtn.isEnabled = false
                getCompensationBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x2ABBB0), for: UIControl.State.normal)
                getCompensationBtn.setTitle("已兑换", for: UIControl.State.normal)
                getCompensationBtn.backgroundColor = UIColor.white
                //边框宽度
                getCompensationBtn.layer.borderWidth = 1
                getCompensationBtn.layer.borderColor = UIColorFromRGB(hexRGB: 0x2ABBB0).cgColor
            }
            cannotCompensationView.alpha = 0
            compensationView.alpha = 1.0
            
            
        }
        
    }
}
