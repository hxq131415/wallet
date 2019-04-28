//
//  WalletHomeListCell.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/25.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class WalletHomeListCell: UITableViewCell {
    
    @IBOutlet weak var leftImgVw: UIImageView!
    @IBOutlet weak var leftTextLbl: UILabel!
    @IBOutlet weak var rightTextLbl: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.leftTextLbl.numberOfLines = 0
        self.rightTextLbl.numberOfLines = 0
        
        
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        bgView.layer.borderColor = MRColorManager.LightGrayBorderColor.cgColor
        bgView.layer.borderWidth = 0.5
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWithModel(model: WalletHomeListModel) {
        
        leftImgVw.oss_ntSetImageWithURL(urlStr: model.logo, placeholderImage: nil)
        
        let uintText = MRLocalizableStringManager.localizableStringFromTableHandle(key: MR_money_uint_text_key)
        let leftText = String(format: "%@\n≈\(uintText)%@", model.name ?? "", model.usdtPrice ?? "0.000")
        
        let leftAttrText = NSMutableAttributedString(string: leftText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e)])
        leftAttrText.addAttributes([NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x2e2922), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 19)], range: (leftText as NSString).range(of: model.name ?? ""))
        leftTextLbl.attributedText = leftAttrText
        
        
        var balance = model.balance ?? ""
        if model.name != "Mcoin" {// ETC  ETH
            balance = String.stringFormatMultiplyingByPowerOf10_18(str: model.balance ?? "")
        }
        else {
            balance = String(format: "%.6f", Double(balance)!)
        }
        let rightText = String(format: "%@\n≈\(uintText)%@", balance, model.worth ?? "0.000")
        
        let rightAttrText = NSMutableAttributedString(string: rightText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x7e7e7e)])
        rightAttrText.addAttributes([NSAttributedStringKey.foregroundColor: UIColorFromRGB(hexRGB: 0x2e2922), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], range: (rightText as NSString).range(of: String(format: "%@", balance)))
        rightTextLbl.attributedText = rightAttrText
    }
    
}
