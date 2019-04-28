//
//  MRBaseResultsViewController.swift
//  FriendOfFish
//
//  Created by rttx on 2018/7/17.
//  Copyright © 2018年 rttx. All rights reserved.
//
//  图片 文字  按钮  组合父类

import UIKit

class MRBaseResultsViewController: MRBaseViewController {

    lazy var imageView: UIImageView = UIImageView()
    lazy var detailLbl: UILabel = UILabel()
    lazy var confirmBtn: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSetupUI()
    }
    
    func initSetupUI() {
        
        imageView.image = UIImage(named: "icon_successful_operation")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(120 * theScaleToiPhone_6)
        }
        
        detailLbl.text = "注册成功"
        detailLbl.font = UIFont.systemFont(ofSize: 14)
        detailLbl.textColor = UIColorFromRGB(hexRGB: 0x333333)
        detailLbl.numberOfLines = 0
        detailLbl.textAlignment = .center
        self.view.addSubview(detailLbl)
        detailLbl.snp.makeConstraints { (make) in
            make.left.equalTo(38 * theScaleToiPhone_6)
            make.right.equalTo(-38 * theScaleToiPhone_6)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        
        confirmBtn = buttonWithFrame(frame: .zero, imageName: nil, selectedImageName: nil, buttonTitle: "去登录", titleColor: UIColor.white, titleFont: UIFont.systemFont(ofSize: 16), addTarget: self, action: #selector(self.confirmAction(_:)))
        confirmBtn.layer.cornerRadius = 4
        confirmBtn.layer.masksToBounds = true
        confirmBtn.backgroundColor = UIColorFromRGB(hexRGB: 0x3887FD)
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(26 * theScaleToiPhone_6)
            make.right.equalTo(-26 * theScaleToiPhone_6)
            make.top.equalTo(detailLbl.snp.bottom).offset(100 * theScaleToiPhone_6)
            make.height.equalTo(47 * theScaleToiPhone_6)
        }
    }

    @objc func confirmAction(_ btn: UIButton) {
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
