//
//  PlanHarvestViewCell.swift
//  MAVRodi
//
//  Created by 徐冉 on 2018/11/24.
//  Copyright © 2018年 是心作佛. All rights reserved.
//

import UIKit
@objc protocol PlanHarvestAmountViewCellDelegate: NSObjectProtocol {
    
    // 点击了申请提现
    @objc func applyButtonClick(indexPath:IndexPath)
    //提示
    @objc func applyTipClick(indexPath:IndexPath)
}
class PlanHarvestAmountViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var etcLabel: UILabel!
    @IBOutlet weak var canLabel: UILabel!
    
    @IBOutlet weak var applyBtn: UIButton!
 
    
    
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var price1Label: UILabel!
    @IBOutlet weak var etc1Label: UILabel!
    @IBOutlet weak var canLabel1: UILabel!
    @IBOutlet weak var applyTipBtn: UIButton!
 
    
    @IBOutlet weak var bgView: UIView!
    var indexPath:IndexPath = IndexPath.init(row: 0, section: 0)
    var harvestRewardModel: PlanHarvestAmountModel?
    weak var delegate: PlanHarvestAmountViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        bgView.cornerRadius = 8
        applyBtn.cornerRadius = 10
        applyBtn.layer.borderWidth = 1
        applyBtn.layer.borderColor = UIColor.white.cgColor
//
//        applyTipBtn.cornerRadius = 10
//        applyTipBtn.layer.borderWidth = 1
//        applyTipBtn.layer.borderColor = UIColor.white.cgColor
        
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
    func configCell(price: String, available: String,indexPath: IndexPath, model: PlanHarvestAmountModel) {
        self.indexPath = indexPath
        self.harvestRewardModel = model
        //bgView.alpha = 1
  
        //量化金额
        titleLabel.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_cell_quantitative_amount_title_key)
        priceLabel.text = price
        //释放金额
        title1Label.text = MRLocalizableStringManager.localizableStringFromTableHandle(key: PlanHarvestPage_cell_release_amount_title_key)
        price1Label.text = price
        bgView.setGradient(colors: [UIColorFromRGB(hexRGB: 0xf7cf5f),UIColorFromRGB(hexRGB: 0xda231)], startPoint: CGPoint.zero, endPoint: CGPoint(x: bgView.width(), y: bgView.height()))
    }
 
    @IBAction func applyBtnClick(_ sender: UIButton) {
        Log(message: "URL--> \(self.indexPath.section)")
        if self.delegate != nil && self.delegate!.responds(to: #selector(PlanHarvestAmountViewCellDelegate.applyButtonClick(indexPath:))) {
            self.delegate!.applyButtonClick(indexPath:indexPath)
        }
    }
    @IBAction func applyTipClick(_ sender: UIButton) {
        Log(message: "URL--> \(self.indexPath.section)")
        if self.delegate != nil && self.delegate!.responds(to: #selector(PlanHarvestAmountViewCellDelegate.applyTipClick(indexPath:))) {
            self.delegate!.applyTipClick(indexPath:indexPath)
        }
    }
 
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
