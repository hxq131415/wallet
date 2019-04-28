//
//  ManagerRewardContentView.swift
//  MAVRodi
//
//  Created by HJY on 2018/12/1.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit

class ManagerRewardContentView: UIView {

    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var principalTitleLabel: UILabel!
    @IBOutlet weak var principalLabel: UILabel!
    @IBOutlet weak var leadershipTitlelabel: UILabel!
    @IBOutlet weak var leadershipLabel: UILabel!
    
    @IBOutlet weak var selectDateBtn: UIButton!
    
    @IBOutlet weak var todayInputLabel: UILabel!
    
    @IBOutlet weak var yesterdayView: CircularProgressView!
    @IBOutlet weak var weeklyView: CircularProgressView!
    @IBOutlet weak var monthlyView: CircularProgressView!
    
    @IBOutlet weak var yesterdayTitleLabel: UILabel!
    @IBOutlet weak var weeklyTitleLabel: UILabel!
    @IBOutlet weak var monthlyTitleLabel: UILabel!
    
    @IBOutlet weak var myLevelTitleLabel: UILabel!
    @IBOutlet weak var myDirectlyTitleLabel: UILabel!
    @IBOutlet weak var thePrincipalTitleLabel: UILabel!
    @IBOutlet weak var myTeamTitleLabel: UILabel!
    @IBOutlet weak var thePrincipalMyTeamTitleLabel: UILabel!
    
    @IBOutlet weak var myLevelLabel: UILabel!
    @IBOutlet weak var myDirectlyLabel: UILabel!
    @IBOutlet weak var thePrincipalLabel: UILabel!
    @IBOutlet weak var myTeamLabel: UILabel!
    @IBOutlet weak var thePrincipalMyTeamLabel: UILabel!
    
    
    var selectDateBtnTapClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func selectDateBtnClick(_ sender: UIButton) {
        if self.selectDateBtnTapClosure != nil {
            self.selectDateBtnTapClosure!()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentViewTopConstraint.constant = 98 * theScaleToiPhone_6
        
        contentView.backgroundColor = UIColor.clear
        contentView.layer.masksToBounds = false
        contentView.setShadowWithColor(shadowColor: UIColorFromRGB(hexRGB: 0x000000).withAlphaComponent(0.2), shadowOffset: CGSize(width: 0, height: -1), shadowRadius: 8)
        
        whiteView.cornerRadius = 8
        
        
        principalTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_principal_title_key)
        leadershipTitlelabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_leadership_title_key)
        
        yesterdayTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_yesterday_title_key)
        weeklyTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_weekly_title_key)
        monthlyTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_monthly_title_key)
        
        myLevelTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_myLevel_title_key)
        myDirectlyTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_myDirectly_title_key)
        thePrincipalTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_thePrincipal_title_key)
        myTeamTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_myTeam_title_key)
        thePrincipalMyTeamTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_thePrincipalMyTeam_title_key)
        
        
        let date = NSDate()
        
        let timeFormatter = DateFormatter()
        
        timeFormatter.dateFormat = "yyyy/MM/dd"

        let strNowTime = timeFormatter.string(from: date as Date) as String
       
        let str:String = String(format: "%@  ▼", strNowTime)
        selectDateBtn.setTitle(str, for: UIControlState.normal)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setProgressView(progress: yesterdayView ,progerssColor: UIColorFromRGB(hexRGB: 0x77dcdb))
        setProgressView(progress: weeklyView ,progerssColor: UIColorFromRGB(hexRGB: 0xeda231))
        setProgressView(progress: monthlyView ,progerssColor: UIColorFromRGB(hexRGB: 0xb20f03))
        
    }
    
    func setProgressView(progress: CircularProgressView,progerssColor: UIColor) {
        
        progress.progerssBackgroundColor = UIColorFromRGB(hexRGB: 0xAAAAAA)
        progress.progerWidth = 4.0
        progress.progerssColor = progerssColor
        progress.progress = 1.0
        progress.cLabel?.font = UIFont.systemFont(ofSize: 20)
        progress.cLabel?.textColor = UIColorFromRGB(hexRGB: 0x111111)
    }
    
    var rewardType: MRRewardType = .sharing {
        didSet{
            
            if rewardType == .sharing {
                
                leadershipTitlelabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_sharing_title_key)
                
                myLevelTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_directly_invited_amount_title_key)
                myDirectlyTitleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: ManagetReward_content_view_principal_invited_title_key)
                
                thePrincipalTitleLabel.isHidden = true
                myTeamTitleLabel.isHidden = true
                thePrincipalMyTeamTitleLabel.isHidden = true
                
                thePrincipalLabel.isHidden = true
                myTeamLabel.isHidden = true
                thePrincipalMyTeamLabel.isHidden = true
            }

            contentHeightConstraint.constant = rewardType == .sharing ? 300 : 383
            
            
        }
    }
    
    var model: MyRewardModel? = nil {
        didSet{
            
            if let model_ = model {
                
                principalLabel.text = String(format: "%.6f", model_.corpus)
                leadershipLabel.text = String(format: "%.6f", model_.bonus_total)
                yesterdayView.cLabel?.text = String(format: "%.2f", model_.bonus_yesterday)
                weeklyView.cLabel?.text = String(format: "%.2f", model_.bonus_weekly)
                monthlyView.cLabel?.text = String(format: "%.2f", model_.bonus_monthly)
                
                if rewardType == .sharing {
                    myLevelLabel.text = String(format: "%d", model_.underlings)
                    myDirectlyLabel.text = String(format: "%.fETC", model_.underling_corpus)
                }else {
                    myLevelLabel.text = model_.level
                    myDirectlyLabel.text = String(format: "%d", model_.underlings)
                    thePrincipalLabel.text = String(format: "%.f", model_.underling_corpus)
                    myTeamLabel.text = String(format: "%d", model_.team)
                    thePrincipalMyTeamLabel.text = String(format: "%.f", model_.team_corpus)
                }
            }
            
        }
    }
}
