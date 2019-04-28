//
//  TEErrorView.swift
//  TeaExpoentNet
//
//  Created by rttx on 2018/6/12.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit


class TableViewBgView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -设置背景页面
    /**
     -
     - frame 需要bgview的frame
     - tips 背景图下面文字提示
     -
     - @return tips
     */
    func addBgViewToSuperView(frame: CGRect, tips: String, image: UIImage) {
        let imageView = self
        imageView.frame = frame
        imageView.image = image
        imageView.contentMode = .center
        
        let tipsLable = UILabel(frame: CGRect.zero)
        imageView.addSubview(tipsLable)
        tipsLable.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(10)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(60)
        }
        tipsLable.configLabel(text: tips, textAlignment: .center, textColor: UIColorFromRGB(hexRGB: 0x999999), font: UIFont.systemFont(ofSize: 13))
        tipsLable.sizeToFit()
        imageView.addSubview(tipsLable)
        
        imageView.setNeedsLayout()
        imageView.layoutIfNeeded()
    }
    
}
