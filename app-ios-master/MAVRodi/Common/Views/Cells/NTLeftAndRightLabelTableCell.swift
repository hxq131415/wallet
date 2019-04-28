//
//  NTLeftAndRightLabelTableCell.swift
//  NTMember
//
//  Created by rttx on 2018/3/20.
//  Copyright © 2018年 MT. All rights reserved.
//
//  left Label and Right Label

import UIKit

enum NTCustomBouthCellStyle {
    case leftOnly
    case rightOnly
    case leftAndRight
}

class NTLeftAndRightLabelTableCell: UITableViewCell {

    @IBOutlet weak var leftTextLbl: UILabel!
    @IBOutlet weak var rightTextLbl: UILabel!
    @IBOutlet weak var topSepatorLine: UIView!
    @IBOutlet weak var bottomSepatorLine: UIView!
    @IBOutlet weak var topSepatorLineLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSepatorLineLeftConstaint: NSLayoutConstraint!
    @IBOutlet weak var rightLblTraingConstraint: NSLayoutConstraint!
    
    var style: NTCustomBouthCellStyle = .leftAndRight {
        didSet {
            switch style {
            case .leftOnly:
                leftTextLbl.isHidden = false
                rightTextLbl.isHidden = true
                rightTextLbl.text = nil
            case .rightOnly:
                leftTextLbl.isHidden = true
                leftTextLbl.text = nil
                rightTextLbl.isHidden = false
            case .leftAndRight:
                leftTextLbl.isHidden = false
                rightTextLbl.isHidden = false
            }
        }
    } // 默认两个label样式
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftTextLbl.textColor = MRColorManager.DarkBlackTextColor
        leftTextLbl.textAlignment = .left
        leftTextLbl.font = UIFont.systemFont(ofSize: 14)
        
        rightTextLbl.textColor = MRColorManager.DarkBlackTextColor
        rightTextLbl.textAlignment = .right
        rightTextLbl.font = UIFont.systemFont(ofSize: 14)
        
        topSepatorLine.isHidden = true
        bottomSepatorLine.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
