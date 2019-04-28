//
//  MRImageAndTipsAlertView.swift
//  FriendOfFish
//
//  Created by rttx on 2018/7/18.
//  Copyright © 2018年 rttx. All rights reserved.
//

import UIKit

class MRImageAndTipsAlertView: UIView {

    private var iconImgView:UIImageView = UIImageView()
    var textLabel:UILabel = UILabel()
    
    var textColor:UIColor = UIColorFromRGB(hexRGB: 0x333333) {
        didSet{
            textLabel.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configAlertView(imageName:String?, text:String?) {
        
        iconImgView.image = UIImage(named: imageName ?? "")
        textLabel.text = text
    }
    
    func initUI() {
        
        iconImgView.contentMode = .scaleAspectFit
        self.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
            if Main_Screen_Width < 375 {
                make.top.equalTo(38 * theScaleToiPhone_6)
            }
            else {
                make.top.equalTo(38)
            }
        }
        
        textLabel.textColor = textColor
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgView.snp.bottom).offset(12)
        }
    }
    

}
