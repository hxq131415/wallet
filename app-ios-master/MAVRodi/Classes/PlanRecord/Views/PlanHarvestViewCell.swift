//
//  PlanHarvestViewCell.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/24.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit
@objc protocol PlanHarvestViewCellDelegate: NSObjectProtocol {
    
    // 点击了申请提现
    @objc func applyButtonClick(indexPath:IndexPath)
    @objc func applyButton2Click(indexPath:IndexPath)
}
class PlanHarvestViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var etcLabel: UILabel!
    @IBOutlet weak var canLabel: UILabel!
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var price1Label: UILabel!
    @IBOutlet weak var etc1Label: UILabel!
    @IBOutlet weak var canLabel1: UILabel!
    @IBOutlet weak var applyBtn1: UIButton!
    
    @IBOutlet weak var price2Label: UILabel!
    @IBOutlet weak var etc2Label: UILabel!
    @IBOutlet weak var canLabel2: UILabel!
    @IBOutlet weak var applyBtn2: UIButton!
    
    @IBOutlet weak var bgView1: UIView!
    var indexPath:IndexPath = IndexPath.init(row: 0, section: 0)
    var harvestRewardModel: PlanHarvestAmountModel?
    weak var delegate: PlanHarvestViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.cornerRadius = 8
        applyBtn.cornerRadius = 10
        applyBtn.layer.borderWidth = 1
        applyBtn.layer.borderColor = UIColor.white.cgColor
        
        applyBtn1.cornerRadius = 10
        applyBtn1.layer.borderWidth = 1
        applyBtn1.layer.borderColor = UIColor.white.cgColor
        
        applyBtn2.cornerRadius = 10
        applyBtn2.layer.borderWidth = 1
        applyBtn2.layer.borderColor = UIColor.white.cgColor
//        titleLabel.font = UIFont.systemFont(ofSize: 13 * theScaleToiPhone_6)
//        priceLabel.font = UIFont.systemFont(ofSize: 20 * theScaleToiPhone_6)
//        etcLabel.font = UIFont.systemFont(ofSize: 16 * theScaleToiPhone_6)
    }
    func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let statusLabelText: String = labelStr
        
        let size = CGSize(width: 900, height:height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any], context: nil).size
        
        return strSize.width > 140 ? 140 : strSize.width
        
    }
    func configCell(price: String, indexPath: IndexPath, model: PlanHarvestAmountModel) {
        self.indexPath = indexPath
        self.harvestRewardModel = model
        bgView.alpha = 1
        bgView1.alpha = 0
        if indexPath.section == 0 {
            //投资收益
            titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_cell_game_revenue_title_key)
            priceLabel.text = price
            bgView.setGradient(colors: [UIColorFromRGB(hexRGB: 0x2abbb0),UIColorFromRGB(hexRGB: 0x33c6b3)], startPoint: CGPoint.zero, endPoint: CGPoint(x: bgView.width(), y: bgView.height()))
        }
        else if indexPath.section == 1 {
            //分享收益
            titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_cell_sharing_rewards_title_key)
            priceLabel.text = price
            bgView.setGradient(colors: [UIColorFromRGB(hexRGB: 0xf7cf5f),UIColorFromRGB(hexRGB: 0xda231)], startPoint: CGPoint.zero, endPoint: CGPoint(x: bgView.width(), y: bgView.height()))
            
        }
        else {
            //领导奖励
            titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_cell_team_rewards_title_key)
            priceLabel.text = price
            bgView.setGradient(colors: [UIColorFromRGB(hexRGB: 0x2abbb0),UIColorFromRGB(hexRGB: 0x33c6b3)], startPoint: CGPoint.zero, endPoint: CGPoint(x: bgView.width(), y: bgView.height()))
            
        }
    }
    func configCellForFrozen(price: String, indexPath: IndexPath, model: PlanHarvestAmountModel,frozenBonus:String) {
        
        //分享收益
        title1Label.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_cell_sharing_rewards_title_key)
        price1Label.text = price
//        let size = CGSize(width: getLabWidth(labelStr: price, font: UIFont.systemFont(ofSize: 20 * theScaleToiPhone_6), height: price1Label.bounds.height), height:price1Label.bounds.height)
//        price1Label.frame = CGRect(x: price1Label.frame.origin.x, y: price1Label.frame.origin.y, width: size.width, height: size.height)
        price2Label.text = frozenBonus
        bgView1.setGradient(colors: [UIColorFromRGB(hexRGB: 0xf7cf5f),UIColorFromRGB(hexRGB: 0xda231)], startPoint: CGPoint.zero, endPoint: CGPoint(x: bgView.width(), y: bgView.height()))
        bgView1.alpha = 1
        bgView.alpha = 0
        
    }
    @IBAction func applyBtnClick(_ sender: UIButton) {
        Log(message: "URL--> \(self.indexPath.section)")
        if self.delegate != nil && self.delegate!.responds(to: #selector(PlanHarvestViewCellDelegate.applyButtonClick(indexPath:))) {
            self.delegate!.applyButtonClick(indexPath:indexPath)
        }
    }
    
    @IBAction func applyBtn1Click(_ sender: UIButton) {
        Log(message: "URL--> \(self.indexPath.section)")
        if self.delegate != nil && self.delegate!.responds(to: #selector(PlanHarvestViewCellDelegate.applyButtonClick(indexPath:))) {
            self.delegate!.applyButtonClick(indexPath:indexPath)
        }
    }
    
    @IBAction func applyBtn2Click(_ sender: UIButton) {
        Log(message: "URL--> \(self.indexPath.section)")
        if self.delegate != nil && self.delegate!.responds(to: #selector(PlanHarvestViewCellDelegate.applyButtonClick(indexPath:))) {
            self.delegate!.applyButton2Click(indexPath:indexPath)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
