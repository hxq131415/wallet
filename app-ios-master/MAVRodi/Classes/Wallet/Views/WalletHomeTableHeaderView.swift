//
//  WalletHomeTableHeaderView.swift
//  MAVRodi
//
//  Created by rttx on 2018/9/5.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class WalletHomeTableHeaderView: UIView {
    
    @IBOutlet weak var topTitleLbl: UILabel!
    @IBOutlet weak var valueTextLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
    }
    
}
