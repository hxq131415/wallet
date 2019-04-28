//
//  MRCustomAlertView.swift
//  NTMember
//
//  Created by rttx on 2018/2/7.
//  Copyright © 2018年 MT. All rights reserved.
//
//  公用弹框

/**
 1、标题，内容，左边按钮，右边按钮
 2、内容，左边按钮，右边按钮（标红，普通）
 3、内容，单个按钮 （标红，普通，灰色）
 4、标题，左边按钮，右边按钮（标红，普通）
 5、标题，单个按钮 （标红，普通，灰色）
 6、标题，内容，左边按钮，右边按钮（标红，普通，灰色）
 7、标题，内容，单个按钮（标红，普通，灰色）
 */

import UIKit
import SnapKit

enum MRCustomAlertActionStyle {
    
    case `default`
    case cancel
    case destructive
}

class MRCustomAlertAction: NSObject {
    
    var title: String?
    var style: MRCustomAlertActionStyle?
    
    var handler: ((_ action: MRCustomAlertAction, _ select: Bool) -> Swift.Void)?
    
    convenience init(title: String?, style: MRCustomAlertActionStyle, handler: ((_ action: MRCustomAlertAction, _ select: Bool) -> Swift.Void)? = nil) {
        self.init()
        
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    private override init() {
        super.init()
    }
    
}

private let kAlertButtonBaseTag: Int = 989292

class MRCustomAlertView: UIView {
    
    var contentBackgroundView: UIView = UIView(frame: CGRect.zero)
    
    var titleLbl: UILabel = UILabel(frame: CGRect.zero)
    var textLbl: UILabel = UILabel(frame: CGRect.zero)
    
    var hLineView: UIView = UIView(frame: CGRect.zero)
    var vLineView: UIView = UIView(frame: CGRect.zero)
    
    var leftBtn: UIButton = UIButton(type: UIButtonType.custom)
    var rightBtn: UIButton = UIButton(type: UIButtonType.custom)
    var selectBtn: UIButton = UIButton(type: UIButtonType.custom)
//    var isShow:Bool = false
    var selected:Bool = false
    
    var leftBtnClickClosure: (() -> Void)?
    var rightBtnClickClosure: (() -> Void)?
    
    static var kAlertViewLeftAndRightInset: CGFloat = 20
    static var kAlertViewTitleTop: CGFloat = 25
    static var kAlertViewMessageToTitleDistance: CGFloat = 5
    static var kAlertViewMessageToBottomDistance: CGFloat = 45
    static var kAlertViewMessageToHorizLineTopistance: CGFloat = 15
    
    var title: String?
    var message: String?
    
    var alertActions: [MRCustomAlertAction] = [] {
        
        didSet {
            if alertActions.count > 0 {
                self.updateActions()
            }
        }
    }
    
    convenience init(frame: CGRect, title: String?, message: String?) {
        self.init(frame: frame)
        self.title = title
        self.message = message
        self.initilzationSubViews()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initilzationSubViews()
    }
    
    func initilzationSubViews() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentBackgroundView)
        contentBackgroundView.snp.remakeConstraints { [weak self](make) in
            if let weakSelf = self {
                make.left.right.top.bottom.equalTo(weakSelf)
            }
        }
        
        contentBackgroundView.backgroundColor = UIColorFromRGB(hexRGB: 0xffffff)
        contentBackgroundView.layer.masksToBounds = true
        contentBackgroundView.layer.cornerRadius = 15
        
        contentBackgroundView.addSubview(titleLbl)
        
        var titleHeight: CGFloat = 0.0
        
        if let alert_title = title , !alert_title.isEmpty {
            let alertViewWidth: CGFloat = 300 * theScaleToiPhone_6
            let titleSize = alert_title.calculateTextSizeConstrainedToSize(size: CGSize(width: alertViewWidth - MRCustomAlertView.kAlertViewLeftAndRightInset * 2.0, height: CGFloat(MAXFLOAT)), textFont: UIFont.boldSystemFont(ofSize: 16), numberOfLines: 2)
            titleHeight = titleSize.height
        }
        
        titleLbl.snp.remakeConstraints { [weak self](make) in
            if let weakSelf = self {
                make.left.equalTo(weakSelf.contentBackgroundView.snp.left).offset(MRCustomAlertView.kAlertViewLeftAndRightInset)
                make.right.equalTo(weakSelf.contentBackgroundView.snp.right).offset(-MRCustomAlertView.kAlertViewLeftAndRightInset)
                make.top.equalTo(weakSelf.contentBackgroundView.snp.top).offset(MRCustomAlertView.kAlertViewTitleTop)
                make.height.equalTo(titleHeight)
            }
        }
        
        titleLbl.textColor = UIColorFromRGB(hexRGB: 0x333333)
        titleLbl.font = UIFont.boldSystemFont(ofSize: 16)
        titleLbl.textAlignment = .center
        titleLbl.text = title
        titleLbl.numberOfLines = 2
        
        contentBackgroundView.addSubview(textLbl)
        textLbl.snp.remakeConstraints { [weak self](make) in
            if let weakSelf = self {
                make.left.equalTo(weakSelf.contentBackgroundView.snp.left).offset(MRCustomAlertView.kAlertViewLeftAndRightInset)
                make.right.equalTo(weakSelf.contentBackgroundView.snp.right).offset(-MRCustomAlertView.kAlertViewLeftAndRightInset)
                make.top.equalTo(weakSelf.titleLbl.snp.bottom).offset(MRCustomAlertView.kAlertViewMessageToTitleDistance)
                make.bottom.equalTo(weakSelf.contentBackgroundView.snp.bottom).offset(-MRCustomAlertView.kAlertViewMessageToHorizLineTopistance - MRCustomAlertView.kAlertViewMessageToBottomDistance)
            }
        }
        
        textLbl.text = message
        textLbl.font = UIFont.systemFont(ofSize: 14)
        textLbl.textColor = UIColorFromRGB(hexRGB: 0xa8a8a8)
//        let words = ["1.", "2.", "3.", "4.", "5.", "6.", "7.", "8.", "9.",  "*."]
//        if(words.contains(where: message!.contains))
        if(message!.contains("\n"))
        {
            textLbl.textAlignment = .left
        }
        else
        {
            textLbl.textAlignment = .center
        }
        textLbl.numberOfLines = 0
        
        contentBackgroundView.addSubview(selectBtn)
        selectBtn.snp.remakeConstraints { [weak self](make) in
            if let weakSelf = self {
                make.left.equalTo(MRCustomAlertView.kAlertViewLeftAndRightInset)
            make.bottom.equalTo(weakSelf.contentBackgroundView.snp.bottom).offset(-MRCustomAlertView.kAlertViewMessageToBottomDistance-MRCustomAlertView.kAlertViewMessageToTitleDistance)
                    make.height.equalTo(35)
            }
        }
    selectBtn.setTitle(MRLocalizableStringManager.localizableStringFromTableHandle(key: Login_loginEnterTips_selectBtn_title_Key), for: UIControlState.normal)
        selectBtn.setTitleColor(UIColorFromRGB(hexRGB: 0x333333), for: UIControlState.normal)
        selectBtn.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        selectBtn.setImage(UIImage(named: "icon_user_agement_normal"), for: UIControlState.normal)
        selectBtn.setImage(UIImage(named: "icon_user_agement_selected"), for: UIControlState.selected)
        selectBtn.titleRightAndImageLeftSetting(withSpace: 2)
        selectBtn.isSelected = false
        selectBtn.addTarget(self, action: #selector(self.agreeSelectBtnTapAction(btn:)), for: UIControlEvents.touchUpInside)
        selectBtn.alpha = 0
        
        
        contentBackgroundView.addSubview(hLineView)
        hLineView.snp.remakeConstraints { [weak self](make) in
            if let weakSelf = self {
                make.left.right.equalToSuperview()
                make.height.equalTo(0.5)
                make.bottom.equalTo(weakSelf.contentBackgroundView.snp.bottom).offset(-MRCustomAlertView.kAlertViewMessageToBottomDistance)
            }
        }
        
        hLineView.backgroundColor = UIColorFromRGB(hexRGB: 0xdedede)
    }
    
    // MARK: - Methods
    public func addAlertActions(actions: [MRCustomAlertAction]) {
        
        alertActions.removeAll()
        alertActions += actions
    }
    public func isShow(isShow:Bool){
        if(isShow)
        {
            selectBtn.alpha = 1
        }
        else
        {
            selectBtn.alpha = 0
        }
    }
    // MARK: - Action
    @objc func agreeSelectBtnTapAction(btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
        self.selected = btn.isSelected
    }
    
    func updateActions() {
        
        if alertActions.count > 0 {
            
            if alertActions.count == 1 {
                let action = alertActions[0]
                let button = UIButton(type: UIButtonType.custom)
                button.tag = kAlertButtonBaseTag + 0
                
                contentBackgroundView.addSubview(button)
                button.snp.remakeConstraints { [weak self](make) in
                    if let weakSelf = self {
                        make.left.bottom.right.equalToSuperview()
                        make.top.equalTo(weakSelf.hLineView.snp.bottom)
                    }
                }
                
                button.titleLabel?.textAlignment = .center
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                if action.style == .default {
                    button.setTitleColor(UIColorFromRGB(hexRGB: 0x333333), for: .normal)
                }
                else if action.style == .cancel {
                    button.setTitleColor(UIColorFromRGB(hexRGB: 0xa8a8a8), for: .normal)
                }
                else if action.style == .destructive {
                    button.setTitleColor(UIColorFromRGB(hexRGB: 0xB1282D), for: .normal)
                }
                
                button.setTitle(action.title, for: .normal)
                button.addTarget(self, action: #selector(self.btnAction(btn:)), for: .touchUpInside)
            }
            else if alertActions.count == 2 {
                let action1 = alertActions[0]
                let button1 = UIButton(type: UIButtonType.custom)
                button1.tag = kAlertButtonBaseTag + 0
                
                contentBackgroundView.addSubview(button1)
                button1.snp.remakeConstraints { [weak self](make) in
                    if let weakSelf = self {
                        make.left.bottom.equalToSuperview()
                        make.right.equalTo(weakSelf.contentBackgroundView.snp.centerX)
                        make.top.equalTo(weakSelf.hLineView.snp.bottom)
                    }
                }
                
                button1.titleLabel?.textAlignment = .center
                button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                if action1.style == .default {
                    button1.setTitleColor(UIColorFromRGB(hexRGB: 0x333333), for: .normal)
                }
                else if action1.style == .cancel {
                    button1.setTitleColor(UIColorFromRGB(hexRGB: 0xa8a8a8), for: .normal)
                }
                else if action1.style == .destructive {
                    button1.setTitleColor(UIColorFromRGB(hexRGB: 0xB1282D), for: .normal)
                }
                
                button1.setTitle(action1.title, for: .normal)
                button1.addTarget(self, action: #selector(self.btnAction(btn:)), for: .touchUpInside)
                
                contentBackgroundView.addSubview(vLineView)
                vLineView.snp.remakeConstraints { [weak self](make) in
                    if let weakSelf = self {
                        make.top.equalTo(weakSelf.hLineView.snp.bottom)
                        make.bottom.equalToSuperview()
                        make.width.equalTo(0.5)
                        make.centerX.equalToSuperview()
                    }
                }
                
                vLineView.backgroundColor = UIColorFromRGB(hexRGB: 0xdedede)
                
                let action2 = alertActions[1]
                let button2 = UIButton(type: UIButtonType.custom)
                button2.tag = kAlertButtonBaseTag + 1
                
                contentBackgroundView.addSubview(button2)
                button2.snp.remakeConstraints { [weak self](make) in
                    if let weakSelf = self {
                        make.left.equalTo(weakSelf.vLineView.snp.right)
                        make.bottom.equalToSuperview()
                        make.right.equalToSuperview()
                        make.top.equalTo(weakSelf.hLineView.snp.bottom)
                    }
                }
                
                button2.titleLabel?.textAlignment = .center
                button2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                if action2.style == .default {
                    button2.setTitleColor(UIColorFromRGB(hexRGB: 0x333333), for: .normal)
                }
                else if action2.style == .cancel {
                    button2.setTitleColor(UIColorFromRGB(hexRGB: 0xa8a8a8), for: .normal)
                }
                else if action2.style == .destructive {
                    button2.setTitleColor(UIColorFromRGB(hexRGB: 0xB1282D), for: .normal)
                }
                
                button2.setTitle(action2.title, for: .normal)
                button2.addTarget(self, action: #selector(self.btnAction(btn:)), for: .touchUpInside)
            }
            else {
                // 多个按钮
                
            }
        }
        else {
            // 没有添加按钮
        }
    }
    
    // MARK: - Action
    @objc func btnAction(btn: UIButton) {
        
        let index = btn.tag - kAlertButtonBaseTag
        if index < alertActions.count {
            let action = alertActions[index]
            if action.handler != nil {
                action.handler!(action,self.selected)
            }
        }
    }
    
}
