//
//  NTTopNavView.swift
//  NTMember
//
//  Created by 王 顺强 on 2017/8/9.
//  Copyright © 2017年 MT. All rights reserved.
//
//  自定制NavigationBar

import UIKit

typealias TECallBackClosure = () -> ()

class MRTopNavView: UIView {

    var statusBar: UIView = {
        let statusBar_ = UIView(frame: CGRect.zero)
        statusBar_.backgroundColor = UIColor.clear
        return statusBar_
    }()
    
    var backButton: UIButton = UIButton(type: .custom)
    var titleLbl: UILabel = UILabel(frame: .zero)
    var rightButton: UIButton = UIButton(type: .custom)
    var bottomLine: UIView = UIView(frame: CGRect.zero)
    
    var topOffset: CGFloat = Sys_Status_Bar_Height
    
    var goBackClosure: TECallBackClosure?
    var rightButtonClosure: TECallBackClosure?

    var backButtonImage:UIImage? = nil {
        didSet{
            if backButtonImage != nil {
                backButton.setImage(backButtonImage!, for: .normal)
            }
        }
    }
    
    var rightButtonImage:UIImage? = nil {
        didSet{
            if rightButtonImage != nil {
                rightButton.setImage(rightButtonImage!, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.subViewInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.subViewInitialization()
    }
    
    func subViewInitialization() {
        
        self.addSubview(self.statusBar)
        
        backButton.setImage(UIImage(named: "icon_back_black"), for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize:14.0)
        backButton.setTitleColor(UIColorFromRGB(hexRGB: 0x333333), for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(self.goBackClickAction), for: UIControlEvents.touchUpInside)
        self.addSubview(backButton)
        
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        rightButton.setTitleColor(UIColorFromRGB(hexRGB: 0x333333), for: UIControlState.normal)
        rightButton.addTarget(self, action: #selector(self.rightButtonClickAction), for: UIControlEvents.touchUpInside)
        self.addSubview(rightButton)
        
        //center
        titleLbl.textColor = UIColorFromRGB(hexRGB: 0x333333)
        titleLbl.textAlignment = .center
        titleLbl.font = TE_NavigationTitle_Font
        self.addSubview(titleLbl)
        
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColorFromRGB(hexRGB: 0xe9eaeb)
        
        self.updateTopNavView()
    }
    
    func updateTopNavView() {
        
        self.statusBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(Sys_Status_Bar_Height)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(5)
            make.top.equalTo(self.statusBar.snp.bottom).offset(0)
            make.height.equalTo(44)
            make.width.equalTo(40)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-5)
            make.top.equalTo(self.statusBar.snp.bottom).offset(0)
            make.height.equalTo(44)
            make.width.equalTo(50)
        }
        
        titleLbl.snp.makeConstraints { [weak self](make) in
            if let weakSelf = self {
                make.centerX.equalTo(weakSelf.snp.centerX).offset(0)
                make.centerY.equalTo(weakSelf.backButton.snp.centerY).offset(0)
                make.height.greaterThanOrEqualTo(0)
                make.width.greaterThanOrEqualTo(0)
            }
        }
        
        bottomLine.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }
    
    @objc func goBackClickAction() {
        if let block = goBackClosure {
            block()
        }
    }
    
    @objc func rightButtonClickAction() {
        if let block = rightButtonClosure {
            block()
        }
    }

}
