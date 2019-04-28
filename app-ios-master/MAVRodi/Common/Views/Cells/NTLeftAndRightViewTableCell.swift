//
//  NTLeftAndRightViewTableCell.swift
//  NTMember
//
//  Created by rttx on 2018/3/20.
//  Copyright © 2018年 MT. All rights reserved.
//
//  left Label and Right Button

import UIKit

class NTLeftAndRightViewTableCell: UITableViewCell {

    @IBOutlet weak var leftTextLbl: UILabel!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var topSepatorLine: UIView!
    @IBOutlet weak var bottomSepatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftTextLbl.textColor = MRColorManager.DarkBlackTextColor
        leftTextLbl.textAlignment = .left
        leftTextLbl.font = UIFont.systemFont(ofSize: 14)
        
        topSepatorLine.isHidden = true
        bottomSepatorLine.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
